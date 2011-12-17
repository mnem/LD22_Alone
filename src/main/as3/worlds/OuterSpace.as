package worlds
{
	import entities.Player;
	import entities.starfield.Starfield;

	import net.flashpunk.FP;
	import net.flashpunk.World;

	/**
	 * @author mnem
	 */
	public class OuterSpace extends World
	{
		protected var halfBoundsWidth:int;
		protected var halfBoundsHeight:int;

		protected var player:Player;
		protected var starfields:Vector.<Starfield>;

		public function OuterSpace()
		{
			halfBoundsWidth = FP.bounds.width / 2;
			halfBoundsHeight = FP.bounds.height / 2;

			createEntities();
			addEntities();
		}

		protected function createEntities():void
		{
			player = new Player();

			starfields = new Vector.<Starfield>(1, true);
			starfields[0] = new Starfield(FP.bounds.width * 5, FP.bounds.height * 5, 1000);
		}

		protected function addEntities():void
		{
			for(var i:uint = 0;i < starfields.length; i++)
			{
				add(starfields[i]);
			}

			add(player);
		}

		override public function update():void
		{
			super.update();

			// Camera always ensures player is centered
			camera.x = -halfBoundsWidth + player.x;
			camera.y = -halfBoundsHeight + player.y;
		}
	}
}
