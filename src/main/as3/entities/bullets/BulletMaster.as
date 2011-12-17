package entities.bullets
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;

	/**
	 * @author mnem
	 */
	public class BulletMaster extends Entity
	{
		public static const NAME:String = "BulletMaster";
		//
		protected var bulletPool:Vector.<Bullet> = new Vector.<Bullet>();
		protected var nextPoolItem:int = -1;
		//
		protected var bullets:Graphiclist = new Graphiclist();

		public function BulletMaster()
		{
			super(0, 0, bullets);
			name = NAME;
		}

		public function shoot(fromX:Number, fromY:Number, angle:Number, vx:Number, vy:Number):void
		{
			var bullet:Bullet;

			if (nextPoolItem < 0)
			{
				// No bullets lying around, lets make one
				bullet = new Bullet();
				bullet.bm = this;
				bullets.add(bullet);
			}
			else
			{
				bullet = bulletPool[nextPoolItem];
				nextPoolItem--;
			}

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
			nextPoolItem++;

			if ((nextPoolItem + 1) >= bulletPool.length)
			{
				FP.log("Bullet pool increasing by " + ((nextPoolItem + 1) - bulletPool.length));
			}

			bulletPool[nextPoolItem] = bullet;
		}
	}
}
