package entities.ore
{
	import net.flashpunk.Entity;

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

		public function MinerBob()
		{
			super();
			name = NAME;
			pool = new SimpleObjectPool("Ores", Ore, this);
			layer = Layers.ORE;
			collidable = false;
		}

		public function spawn(x:Number, y:Number, xV:Number, yV:Number, r:Number, g:Number, b:Number):void
		{
			var ore:Ore = pool.take() as Ore;

			ore.spawn(r, g, b);
			ore.decayRate = 10;
			ore.x = x;
			ore.y = y;
			ore.xV = xV;
			ore.yV = yV;
			world.add(ore);
		}

		public function oreEaten(ore:Ore):void
		{
			world.remove(ore);
			pool.give(ore);
		}

		public function itemWasCreated(item:*):void
		{
			// var ore:Ore = item as Ore;
		}

		protected var pool:SimpleObjectPool;
	}
}
