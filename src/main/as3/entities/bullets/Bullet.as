package entities.bullets
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	/**
	 * @author mnem
	 */
	public class Bullet
	extends Entity
	{
		public var vx:Number;
		public var vy:Number;
		public var life:Number;
		public var currentLife:Number;
		public var decayRate:Number;
		public var image:Image;

		public function Bullet()
		{
			image = new Image(ImageAsset.Laser01);
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			super(0, 0, image);

			setHitbox(image.width, image.height, image.width / 2, image.height / 2);

			layer = Layers.LASERS;
			type = CollisionTypes.BULLET;
		}

		public function grantNewLife(life:Number):void
		{
			this.life = life;
			this.currentLife = life;
			this.visible = true;
			this.active = true;
			this.collidable = true;
		}

		override public function update():void
		{
			x += vx * FP.elapsed;
			y += vy * FP.elapsed;
			currentLife -= decayRate * FP.elapsed;

			if (currentLife <= 0)
			{
				expired();
			}
			else
			{
				image.alpha = currentLife / life;
			}
		}

		public function expired():void
		{
			visible = false;
			active = false;
			collidable = false;
			var bm:BulletMaster = world.getInstance(BulletMaster.NAME) as BulletMaster;
			if (bm)
			{
				bm.bulletExpired(this);
			}
		}
	}
}
