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
		public var activeObjects:uint = 0;

		public function SimpleObjectPool(name:String, clazz:Class, watcher:SimpleObjectPoolWatcher = null)
		{
			this.clazz = clazz;
			this.name = name;
			this.watcher = watcher;
		}

		public function take():*
		{
			var item:*;
			var isNew:Boolean = false;

			if (nextPoolItem < 0)
			{
				item = new clazz();
				isNew = true;
				if (watcher)
				{
					try
					{
						watcher.itemWasCreated(item);
					}
					catch(e:Error)
					{
						FP.log(name + " watcher b0rked: " + e);
					}
				}
			}
			else
			{
				item = pool[nextPoolItem];
				nextPoolItem--;
			}

			activeObjects++;
			if (DEBUG && Main.DEBUG)
			{
				FP.log(name + " pool item take. New? " + isNew + " (" + activeObjects + "/" + pool.length + "/ " + nextPoolItem + ")");
			}
			return item;
		}

		public function give(taken:*):void
		{
			if (taken is clazz)
			{
				// Probably came from here. We'll take it anyway
				nextPoolItem++;
				pool[nextPoolItem] = taken;
				activeObjects--;

				if (DEBUG && Main.DEBUG)
				{
					FP.log(name + " pool item returned. (" + activeObjects + "/" + pool.length + "/ " + nextPoolItem + ")");
				}
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
		//
		private static const DEBUG:Boolean = false;
	}
}
