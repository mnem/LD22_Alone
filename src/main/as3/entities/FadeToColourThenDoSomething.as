package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.utils.Ease;

	import flash.display.BitmapData;

	/**
	 * @author mnem
	 */
	public class FadeToColourThenDoSomething extends Entity
	{
		public var something:Function;
		public var image:Image;
		public var ct:ColorTween;

		public function FadeToColourThenDoSomething(colour:uint, something:Function = null, fadeOut:Boolean = false, duration:Number = 1)
		{
			this.something = something;

			image = new Image(new BitmapData(FP.bounds.width, FP.bounds.height, false, colour));
			image.scrollX = 0;
			image.scrollY = 0;
			image.alpha = fadeOut ? 1 : 0;

			super(0, 0, image);

			ct = new ColorTween(fadeFinished);
			ct.tween(duration, colour, colour, fadeOut ? 1 : 0, fadeOut ? 0 : 1, Ease.quadOut);
			addTween(ct);

			layer = Layers.FADES;
		}

		override public function update():void
		{
			super.update();
			image.alpha = ct.alpha;
		}

		protected function fadeFinished():void
		{
			if (something != null) something();
		}
	}
}
