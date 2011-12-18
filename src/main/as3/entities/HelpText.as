package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.ColorTween;

	/**
	 * @author mnem
	 */
	public class HelpText extends Entity
	{
		public var ct:ColorTween;
		public var text:Text;

		public function HelpText()
		{
			text = new Text("Click and hold to move.\n[SPACE] to fire blaster.\nCollect ore particles from asteroid remains.");
			text.scrollX = 0;
			text.scrollY = 0;
			text.color = 0xE8FF8E;

			super(3, FP.bounds.height - text.height - 3, text);

			layer = Layers.HUD;

			ct = new ColorTween(helpDone);
			ct.tween(20, 0, 0, 1, 0);
			addTween(ct);
		}

		override public function update():void
		{
			text.alpha = ct.alpha;
		}

		protected function helpDone():void
		{
			world.remove(this);
		}
	}
}
