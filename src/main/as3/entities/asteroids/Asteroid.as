package entities.asteroids
{
	import entities.Player;
	import entities.bullets.Bullet;
	import entities.hud.Asteroidotron;
	import entities.ore.MinerBob;

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;

	/**
	 * @author mnem
	 */
	public class Asteroid
	extends Entity
	{
		public var xV:Number;
		public var yV:Number;
		public var rV:Number;
		public var image:Image;
		public var currentPower:int;
		public var power:int;
		public var explosionSound:Sfx;
		public var hitSound:Sfx;
		public var r:Number;
		public var g:Number;
		public var b:Number;

		public function Asteroid()
		{
			image = new Image(ImageAsset.AsteroidA);
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			super(0, 0, image);

			setHitbox(image.width, image.height, image.width / 2, image.height / 2);

			layer = Layers.ASTEROIDS;
			type = CollisionTypes.ASTEROID;

			explosionSound = new Sfx(AudioAsset.ExplodeA);
			hitSound = new Sfx(AudioAsset.AsteroidHit);
		}

		protected function updateHitBox():void
		{
			var w:Number = image.width * image.scaleX;
			var h:Number = image.height * image.scaleY;
			setHitbox(w, h, w / 2, h / 2);
		}

		override public function update():void
		{
			x += xV * FP.elapsed;
			y += yV * FP.elapsed;
			image.angle += rV * FP.elapsed;

			var bullet:Bullet = collide(CollisionTypes.BULLET, x, y) as Bullet;
			if (bullet)
			{
				hitSound.play();
				currentPower -= bullet.currentLife;
				bullet.expired();

				image.scaleX = 0.7 + (0.3 * (currentPower / power));
				image.scaleY = 0.7 + (0.3 * (currentPower / power));
				updateHitBox();

				if (currentPower < 0)
				{
					explodeAsteroid();
				}
			}
			else
			{
				var player:Player = world.getInstance(Player.NAME) as Player;
				var asteroidotron:Asteroidotron = world.getInstance(Asteroidotron.NAME) as Asteroidotron;
				if (player && asteroidotron)
				{
					var distance:Number = FP.distance(player.x, player.y, x, y);
					if (distance < asteroidotron.distance)
					{
						// We're closer
						asteroidotron.distance = distance;
						asteroidotron.indicator.angle = FP.angle(player.x, player.y, x, y);
					}
				}
			}
		}

		public function spawn():void
		{
			r = FP.random;
			g = FP.random;
			b = FP.random;

			image.scaleX = 1;
			image.scaleY = 1;
			updateHitBox();
			image.tinting = 0.25;
			image.color = ((0xff * r) << 16) | ((0xff * g) << 8) | (0xff * b);

			active = true;
			visible = true;
			collidable = true;
		}

		public function setPower(power:int):void
		{
			this.power = power;
			this.currentPower = power;
		}

		public function explodeAsteroid():void
		{
			explosionSound.play();

			active = false;
			visible = false;
			collidable = false;
			var slinger:AsteroidSlinger = world.getInstance(AsteroidSlinger.NAME) as AsteroidSlinger;
			if (slinger)
			{
				slinger.asteroidExpired(this);
			}

			var bob:MinerBob = world.getInstance(MinerBob.NAME) as MinerBob;
			if (bob)
			{
				bob.spawn(x, y, xV, yV, r, g, b);
			}
		}
	}
}
