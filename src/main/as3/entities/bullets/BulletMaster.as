package entities.bullets
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;

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
			super(0, 0, bullets);
			name = NAME;
			pool = new SimpleObjectPool("Bullets", Bullet, this);
		}

		public function shoot(fromX:Number, fromY:Number, angle:Number, vx:Number, vy:Number):void
		{
			var bullet:Bullet = pool.take();

			bullet.x = fromX;
			bullet.y = fromY;
			bullet.angle = angle;
			bullet.vx = vx;
			bullet.vy = vy;
			bullet.decayRate = 50;
			bullet.grantNewLife(100);
		}

		override public function update():void
		{
			bullets.update();
		}

		public function bulletExpired(bullet:Bullet):void
		{
			pool.give(bullet);
		}

		public function itemWasCreated(item:*):void
		{
			var bullet:Bullet = item as Bullet;
			bullet.bm = this;
			bullets.add(bullet);
		}

		protected var pool:SimpleObjectPool;
		protected var bullets:Graphiclist = new Graphiclist();
	}
}
