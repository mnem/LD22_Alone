package entities.bullets
{
	import net.flashpunk.Entity;

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

		public function BulletMaster()
		{
			name = NAME;
			pool = new SimpleObjectPool("Bullets", Bullet, this);
			collidable = false;
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
