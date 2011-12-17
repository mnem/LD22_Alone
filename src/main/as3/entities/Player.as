package entities
{
	import entities.bullets.BulletMaster;

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	import flash.geom.Point;

	/**
	 * @author mnem
	 */
	public class Player extends Entity
	{
		public var image:Image;
		public var velocity:Point = new Point();
		public var laserCharge:Number = 0;

		public function Player(x:Number = 0, y:Number = 0)
		{
			screenCentreX = FP.bounds.width / 2;
			screenCentreY = FP.bounds.height / 2;

			image = new Image(PNGAsset.Player);
			image.originX = image.width / 2;
			image.originY = image.height / 2;

			setHitbox(image.width, image.height, image.width / 2, image.height / 2);

			laserChargeImage = new Image(PNGAsset.LaserCharge);
			laserChargeImage.originX = laserChargeImage.width / 2;
			laserChargeImage.originY = laserChargeImage.height / 2;
			laserChargeImage.visible = false;

			super(x, y, new Graphiclist(image, laserChargeImage));

			Input.define(ACTION_SHOOT, Key.SPACE, Key.X, Key.C);

			layer = Layers.PLAYER;
		}

		protected function gatherUserInput():void
		{
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
		}

		protected function hitByAnAsteroid():void
		{
			world.active = false;
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
		protected var laserChargeImage:Image;
		//
		protected var screenCentreX:int;
		protected var screenCentreY:int;
		protected var _scratchPoint:Point = new Point();
	}
}
