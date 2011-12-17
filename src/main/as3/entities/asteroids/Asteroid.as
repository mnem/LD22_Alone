package entities.asteroids
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	/**
	 * @author mnem
	 */
	public class Asteroid extends Image
	{
		public var xV:Number;
		public var yV:Number;
		public var rV:Number;
		public var slinger:AsteroidSlinger;

		public function Asteroid()
		{
			super(PNGAsset.AsteroidA);

			originX = width / 2;
			originY = height / 2;

			relative = false;
		}

		override public function update():void
		{
			x += xV * FP.elapsed;
			y += yV * FP.elapsed;
			angle += rV * FP.elapsed;
		}
	}
}
