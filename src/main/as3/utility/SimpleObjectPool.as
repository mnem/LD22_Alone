package utility
{
	import net.flashpunk.FP;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author mnem
	 */
	public class SimpleObjectPool
	{
		public var name:String;
		public var watcher:SimpleObjectPoolWatcher;

		public function SimpleObjectPool(name:String, clazz:Class, watcher:SimpleObjectPoolWatcher = null)
		{
			this.clazz = clazz;
			this.name = name;
			this.watcher = watcher;
		}

		public function take():*
		{
			var item:*;
			if (nextPoolItem < 0)
			{
				item = new clazz();
				if (Main.DEBUG)
				{
					FP.log(name + " pool drained. Creating new " + getQualifiedClassName(clazz));
				}
				if (watcher)
				{
					watcher.itemWasCreated(item);
				}
			}
			else
			{
				item = pool[nextPoolItem];
				nextPoolItem--;
			}

			return item;
		}

		public function give(taken:*):void
		{
			if (taken is clazz)
			{
				// Probably came from here. We'll take it anyway
				nextPoolItem++;
				if (Main.DEBUG && nextPoolItem >= pool.length)
				{
					FP.log(name + " pool increasing by " + ((nextPoolItem + 1) - pool.length));
				}

				pool[nextPoolItem] = taken;
			}
			else
			{
				throw("Uh-oh. The ghost gave the wrong thing to the dead pool. Expected " + getQualifiedClassName(clazz) + " but got a " + getQualifiedClassName(taken) );
			}
		}

		protected var clazz:Class;
		//
		protected var pool:Array = [];
		protected var nextPoolItem:int = -1;
	}
}
