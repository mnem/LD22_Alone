package entities.starfield
{
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;

	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * @author mnem
	 */
	public class Star extends Graphic
	{
		public var colour:uint;
		public var big:Boolean;

		public function Star(intensity:Number, big:Boolean)
		{
			intensity = FP.clamp(intensity + FP.random * 0.2 - 0.1, 0, 1);

			var g:uint = (intensity * 255) & 0xff;
			this.colour = g << 16 | g << 8 | g;

			this.big = big;
		}

		override public function render(target:BitmapData, point:Point, camera:Point):void
		{
			_point.x = (point.x + x) - (camera.x * scrollX);
			_point.y = (point.y + y) - (camera.y * scrollY);
			target.setPixel32(_point.x, _point.y, colour);

			if(big)
			{
				target.setPixel32(_point.x-1, _point.y, colour);
				target.setPixel32(_point.x+1, _point.y, colour);
				target.setPixel32(_point.x, _point.y-1, colour);
				target.setPixel32(_point.x, _point.y+1, colour);
			}
		}
	}
}
