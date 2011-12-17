package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	import worlds.OuterSpace;

	[SWF(backgroundColor="#000000", frameRate="60", width="890", height="500")]
	public class Main
	extends Engine
	{
		public function Main()
		{
			super(890, 500, 60, false);
		}

		override public function init():void
		{
			FP.world = new OuterSpace();
		}
	}
}
