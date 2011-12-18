package entities.hud
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;

	import flash.display.BitmapData;

	/**
	 * @author mnem
	 */
	public class Bar extends Entity
	{
		public static const R:String = "ore:red";
		public static const G:String = "ore:green";
		public static const B:String = "ore:blue";
		//
		public var marker:Image;
		public var fill:Image;
		public var label:Spritemap;

		public function Bar()
		{
			label = new Spritemap(ImageAsset.BarLabels, 42, 8);
			label.add(R, [0], 0, false);
			label.add(G, [1], 0, false);
			label.add(B, [2], 0, false);

			marker = new Image(ImageAsset.Bar);
			fill = new Image(new BitmapData(marker.width, marker.height, false, 0xffffff));

			marker.scrollX = 0;
			marker.scrollY = 0;
			fill.scrollX = 0;
			fill.scrollY = 0;
			label.scrollX = 0;
			label.scrollY = 0;

			marker.x = label.width + 2;
			fill.x = label.width + 2;

			collidable = false;
			layer = Layers.HUD;

			super(0, 0, new Graphiclist(fill, marker, label));
		}

		public function setColour(colour:uint):void
		{
			fill.color = colour;
		}

		public function showValue(current:int, max:int):Boolean
		{
			current = FP.clamp(current, 0, Config.ORE_TARGET);
			fill.scaleX = current / max;

			return current == max;
		}
	}
}
