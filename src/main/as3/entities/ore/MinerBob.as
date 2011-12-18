package entities.ore
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;

	import utility.SimpleObjectPool;
	import utility.SimpleObjectPoolWatcher;

	/**
	 * @author mnem
	 */
	public class MinerBob
	extends Entity
	implements SimpleObjectPoolWatcher
	{
		public static const NAME:String = "MinerBob";

		public function MinerBob(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null)
		{
			super();
			name = NAME;
			pool = new SimpleObjectPool("Ores", Ore, this);
			layer = Layers.ORE;
			collidable = false;
		}

		public function spawn(x:Number, y:Number, xV:Number, yV:Number, r:int, g:int, b:int):void
		{
			var ore:Ore = pool.take() as Ore;

			ore.spawn(r, g, b);
			ore.decayRate = 100;
			ore.x = x;
			ore.y = y;
			ore.xV = xV;
			ore.yV = yV;
		}

		public function oreEaten(ore:Ore):void
		{
			pool.give(ore);
		}

		public function itemWasCreated(item:*):void
		{
			var ore:Ore = item as Ore;
			world.add(ore);
		}

		protected var pool:SimpleObjectPool;
	}
}
