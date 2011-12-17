package entities.starfield
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;

	/**
	 * @author mnem
	 */
	public class Starfield extends Entity
	{
		protected var _width:Number;
		protected var _height:Number;

		public function Starfield(width:Number, height:Number, numberOfStars:uint)
		{
			var stars:Graphiclist = new Graphiclist();
			for (var i:uint = 0; i < numberOfStars; i++)
			{
				var s:Star = new Star();

				s.x = (FP.random * width) - (width / 2);
				s.y = (FP.random * height) - (height / 2);

				stars.add(s);
			}

			super(0, 0, stars);
		}
	}
}
