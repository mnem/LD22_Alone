package
{
	import net.flashpunk.Engine;

	[SWF(backgroundColor="#000000", frameRate="60", width="800", height="600")]
	public class Main
	extends Engine
	{
		public function Main()
		{
			super(800, 600, 60, false);
		}

		override public function init():void
		{
			trace("FlashPunk has started successfully!");
		}
	}
}
