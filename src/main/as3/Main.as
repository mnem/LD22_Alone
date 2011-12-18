package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	import worlds.Intro;

	[SWF(backgroundColor="#000000", frameRate="30", width="890", height="500")]
	public class Main
	extends Engine
	{
		public static const DEBUG:Boolean = false;

		public function Main()
		{
			super(890, 500, 30, false);

			if (DEBUG)
			{
				FP.console.enable();
			}
		}

		override public function init():void
		{
			FP.world = new Intro();
		}
	}
}
