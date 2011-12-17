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
		public var bm:BulletMaster;
		public var image:Image;

		public function Bullet()
		{
			image = new Image(PNGAsset.Laser01);
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			super(0, 0, image);

			layer = Layers.LASERS;
		}

		public function grantNewLife(life:Number):void
		{
			this.life = life;
			this.currentLife = life;
			this.visible = true;
			this.active = true;
		}

		override public function update():void
		{
			x += vx * FP.elapsed;
			y += vy * FP.elapsed;
			currentLife -= decayRate * FP.elapsed;

			if (currentLife <= 0)
			{
				visible = false;
				active = false;
				if (bm)
				{
					bm.bulletExpired(this);
				}
			}
			else
			{
				image.alpha = currentLife / life;
			}
		}
	}
}
