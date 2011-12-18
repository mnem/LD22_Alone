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
		public var power:int;
		public var explosionSound:Sfx;
		public var hitSound:Sfx;

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

		override public function update():void
		{
			x += xV * FP.elapsed;
			y += yV * FP.elapsed;
			image.angle += rV * FP.elapsed;

			var bullet:Bullet = collide(CollisionTypes.BULLET, x, y) as Bullet;
			if (bullet)
			{
				hitSound.play();
				power -= bullet.currentLife;
				bullet.expired();

				if (power < 0)
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
			active = true;
			visible = true;
			collidable = true;
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
				bob.spawn(x, y, xV, yV, FP.random, FP.random, FP.random);
			}
		}
	}
}
