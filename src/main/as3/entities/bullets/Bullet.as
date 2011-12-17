package entities.bullets
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	/**
	 * @author mnem
	 */
	public class Bullet extends Image
	{
		public var vx:Number;
		public var vy:Number;
		public var life:Number;
		public var currentLife:Number;
		public var decayRate:Number;
		public var bm:BulletMaster;

		public function Bullet()
		{
			super(PNGAsset.Laser01);

			originX = width / 2;
			originY = height / 2;

			relative = false;
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
				alpha = currentLife / life;
			}
		}
	}
}
