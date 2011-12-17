package entities.asteroids
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
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
		public var slinger:AsteroidSlinger;
		public var image:Image;

		public function Asteroid()
		{
			image = new Image(PNGAsset.AsteroidA);
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			super(0, 0, image);

			setHitbox(image.width, image.height, image.width / 2, image.height / 2);

			layer = Layers.ASTEROIDS;
			type = CollisionTypes.ASTEROID;
		}

		override public function update():void
		{
			x += xV * FP.elapsed;
			y += yV * FP.elapsed;
			image.angle += rV * FP.elapsed;
		}
	}
}
