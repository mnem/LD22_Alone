package entities.starfield
{
	import net.flashpunk.Graphic;

	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * @author mnem
	 */
	public class Star extends Graphic
	{
		override public function render(target:BitmapData, point:Point, camera:Point):void
		{
			_point.x = (point.x + x) - (camera.x * scrollX);
			_point.y = (point.y + y) - (camera.y * scrollY);
			target.setPixel(_point.x, _point.y, 0xffffff);
			//target.copyPixels(_source, _sourceRect, _point, null, null, true);
		}
	}
}
