package entities.bullets
{
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;

	import utility.SimpleObjectPool;
	import utility.SimpleObjectPoolWatcher;

	/**
	 * @author mnem
	 */
	public class BulletMaster
	extends Entity
	implements SimpleObjectPoolWatcher
	{
		public static const NAME:String = "BulletMaster";
		//
		public var laserA:Sfx;
		public var laserB:Sfx;
		public var shotsFired:uint = 0;

		public function BulletMaster()
		{
			name = NAME;
			pool = new SimpleObjectPool("Bullets", Bullet, this);
			collidable = false;
			laserA = new Sfx(AudioAsset.LaserA);
			laserB = new Sfx(AudioAsset.LaserB);
		}

		public function shoot(fromX:Number, fromY:Number, angle:Number, vx:Number, vy:Number):void
		{
			var bullet:Bullet = pool.take();

			bullet.x = fromX;
			bullet.y = fromY;
			bullet.image.angle = angle;
			bullet.vx = vx;
			bullet.vy = vy;
			bullet.decayRate = 50;
			bullet.grantNewLife(100);
			world.add(bullet);

			shotsFired++;

			shotsFired & 1 ? laserA.play(0.5) : laserB.play(0.5);
		}

		public function bulletExpired(bullet:Bullet):void
		{
			world.remove(bullet);
			pool.give(bullet);
		}

		public function itemWasCreated(item:*):void
		{
			// var bullet:Bullet = item as Bullet;
		}

		protected var pool:SimpleObjectPool;
	}
}
