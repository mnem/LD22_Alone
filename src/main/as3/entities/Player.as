package entities
{
	import entities.bullets.BulletMaster;
	import entities.hud.Bar;
	import entities.ore.Ore;

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	import flash.geom.Point;

	/**
	 * @author mnem
	 */
	public class Player extends Entity
	{
		public static const ANIM_REST:String = "rest";
		//
		public static const NAME:String = "player";
		//
		public var image:Spritemap;
		public var velocity:Point = new Point();
		public var laserCharge:Number = 0;
		//
		public var collectedRed:Number = 0;
		public var collectedGreen:Number = 0;
		public var collectedBlue:Number = 0;
		//
		public var won:Boolean = false;

		public function Player(x:Number = 0, y:Number = 0)
		{
			screenCentreX = FP.bounds.width / 2;
			screenCentreY = FP.bounds.height / 2;

			image = new Spritemap(PNGAsset.Player, 32, 32);
			image.add(ANIM_REST, [0, 1], 4, true);
			// image = new Image(PNGAsset.Player);
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			image.play(ANIM_REST);

			setHitbox(image.width, image.height, image.width / 2, image.height / 2);

			laserChargeImage = new Image(PNGAsset.LaserCharge);
			laserChargeImage.originX = laserChargeImage.width / 2;
			laserChargeImage.originY = laserChargeImage.height / 2;
			laserChargeImage.visible = false;

			super(x, y, new Graphiclist(image, laserChargeImage));

			Input.define(ACTION_SHOOT, Key.SPACE, Key.X, Key.C);

			name = NAME;
			layer = Layers.PLAYER;
		}

		protected function gatherUserInput():void
		{
			if (won)
			{
				return;
			}

			if (Input.mouseDown)
			{
				// Find the angle and distance from the centre point
				image.angle = FP.angle(screenCentreX, screenCentreY, Input.mouseFlashX, Input.mouseFlashY);

				_scratchPoint.x = FP.clamp(screenCentreX - Input.mouseFlashX, -MAX_MOUSE_DISTANCE, MAX_MOUSE_DISTANCE);
				_scratchPoint.y = FP.clamp(screenCentreY - Input.mouseFlashY, -MAX_MOUSE_DISTANCE, MAX_MOUSE_DISTANCE);

				velocity.x = _scratchPoint.x / MAX_MOUSE_DISTANCE * MAX_VELOCITY;
				velocity.y = _scratchPoint.y / MAX_MOUSE_DISTANCE * MAX_VELOCITY;
			}

			if (Input.check(ACTION_SHOOT))
			{
				laserChargeImage.visible = true;

				laserCharge += LASER_CHARGE_RATE * FP.elapsed;
				while (laserCharge >= LASER_POWER_REQUIREMENT)
				{
					emitLaser();
					laserCharge -= LASER_POWER_REQUIREMENT;
				}

				if (laserCharge >= 0)
				{
					laserChargeImage.alpha = laserCharge / LASER_POWER_REQUIREMENT;
				}
				else
				{
					laserChargeImage.alpha = 0;
				}
			}

			if (Input.released(ACTION_SHOOT))
			{
				laserCharge = 0;
				laserChargeImage.visible = false;
			}
		}

		protected function emitLaser():void
		{
			var bm:BulletMaster = world.getInstance(BulletMaster.NAME) as BulletMaster;
			if (bm)
			{
				FP.angleXY(_scratchPoint, image.angle, LASER_VELOCITY);
				bm.shoot(x, y, image.angle, _scratchPoint.x, _scratchPoint.y);

				// Recoil. Yes, I know it's a laser. Shut up.
				velocity.x += _scratchPoint.x * 0.2;
				velocity.y += _scratchPoint.y * 0.2;
			}
		}

		override public function update():void
		{
			gatherUserInput();

			x -= velocity.x * FP.elapsed;
			y -= velocity.y * FP.elapsed;

			velocity.x *= 0.95;
			velocity.y *= 0.95;

			if (collide(CollisionTypes.ASTEROID, x, y))
			{
				hitByAnAsteroid();
			}

			var ore:Ore = collide(CollisionTypes.ORE, x, y) as Ore;
			if (ore)
			{
				collectOre(ore);
			}
			else if (!won)
			{
				collectedRed = FP.clamp(collectedRed - ORE_DEPLETION_RATE * FP.elapsed, 0, Config.ORE_TARGET);
				collectedGreen = FP.clamp(collectedGreen - ORE_DEPLETION_RATE * FP.elapsed, 0, Config.ORE_TARGET);
				collectedBlue = FP.clamp(collectedBlue - ORE_DEPLETION_RATE * FP.elapsed, 0, Config.ORE_TARGET);
			}

			// Update HUD
			var barR:Bar = world.getInstance(Bar.R) as Bar;
			var barG:Bar = world.getInstance(Bar.G) as Bar;
			var barB:Bar = world.getInstance(Bar.B) as Bar;

			if (barR) barR.showValue(collectedRed, Config.ORE_TARGET);
			if (barG) barG.showValue(collectedGreen, Config.ORE_TARGET);
			if (barB) barB.showValue(collectedBlue, Config.ORE_TARGET);
		}

		public function collectOre(ore:Ore):void
		{
			collectedRed += ore.r;
			collectedGreen += ore.g;
			collectedBlue += ore.b;

			ore.expired();

			var upperLimit:Number = Config.ORE_TARGET - 2;
			if (collectedRed >= upperLimit && collectedGreen >= upperLimit && collectedBlue >= upperLimit)
			{
				win();
			}
		}

		public function win():void
		{
			collidable = false;
			won = true;
		}

		public function hitByAnAsteroid():void
		{
			// world.active = false;
			FP.log("HIT HIT HIT!");
		}

		private static const ACTION_SHOOT:String = "Shoot";
		//
		private static const MAX_MOUSE_DISTANCE:Number = 300;
		private static const MAX_VELOCITY:Number = 200;
		//
		private static const LASER_POWER_REQUIREMENT:Number = 100;
		private static const LASER_CHARGE_RATE:Number = 200;
		private static const LASER_VELOCITY:Number = 300;
		//
		private static const ORE_DEPLETION_RATE:Number = 1;
		//
		protected var laserChargeImage:Image;
		//
		protected var screenCentreX:int;
		protected var screenCentreY:int;
		protected var _scratchPoint:Point = new Point();
	}
}
