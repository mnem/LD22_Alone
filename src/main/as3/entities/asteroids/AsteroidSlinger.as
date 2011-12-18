package entities.asteroids
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;

	import utility.SimpleObjectPool;
	import utility.SimpleObjectPoolWatcher;

	import worlds.OuterSpace;

	/**
	 * @author mnem
	 */
	public class AsteroidSlinger
	extends Entity
	implements SimpleObjectPoolWatcher
	{
		public static const NAME:String = "AsteroidSlinger";

		public function AsteroidSlinger()
		{
			super();
			name = NAME;
			pool = new SimpleObjectPool("Asteroids", Asteroid, this);
			layer = Layers.ASTEROIDS;
			collidable = false;
		}

		override public function update():void
		{
			if (pool.activeObjects < MAX_ASTEROIDS)
			{
				if (--timeToAdd <= 0)
				{
					sling();
					timeToAdd = (FP.random * 60) + 30;
				}
			}
		}

		public function sling():void
		{
			var asteroid:Asteroid = pool.take() as Asteroid;

			asteroid.x = OuterSpace.SPACE_WIDTH * FP.random;
			asteroid.y = OuterSpace.SPACE_HEIGHT * FP.random;

			if (asteroid.x > world.camera.x && asteroid.x < (world.camera.x + FP.bounds.width) && asteroid.y > world.camera.y && asteroid.y < (world.camera.y + FP.bounds.height))
			{
				if (Main.DEBUG)
				{
					FP.log("Whoops, an asteroid would have appeared on screen.");
				}
				asteroid.y += FP.bounds.height;
			}

			asteroid.xV = ((ASTEROID_MAX_V - ASTEROID_MIN_V) * FP.random) + ASTEROID_MIN_V;
			asteroid.yV = ((ASTEROID_MAX_V - ASTEROID_MIN_V) * FP.random) + ASTEROID_MIN_V;
			asteroid.rV = ((ASTEROID_MAX_RV - ASTEROID_MIN_RV) * FP.random) + ASTEROID_MIN_RV;

			asteroid.xV *= FP.random < 0.5 ? -1 : 1;
			asteroid.yV *= FP.random < 0.5 ? -1 : 1;
			asteroid.rV *= FP.random < 0.5 ? -1 : 1;

			asteroid.power = ((ASTEROID_MAX_POWER - ASTEROID_MIN_POWER) * FP.random) + ASTEROID_MIN_POWER;

			asteroid.active = true;
			asteroid.visible = true;
		}

		public function asteroidExpired(asteroid:Asteroid):void
		{
			pool.give(asteroid);
		}

		public function itemWasCreated(item:*):void
		{
			var asteroid:Asteroid = item as Asteroid;
			world.add(asteroid);
		}

		protected var timeToAdd:int = 0;
		protected var pool:SimpleObjectPool;
		//
		private static const ASTEROID_MIN_V:int = 10;
		private static const ASTEROID_MAX_V:int = 50;
		//
		private static const ASTEROID_MIN_RV:int = 0.2;
		private static const ASTEROID_MAX_RV:int = 100;
		//
		private static const ASTEROID_MIN_POWER:int = 50;
		private static const ASTEROID_MAX_POWER:int = 200;
		//
		private static const MAX_ASTEROIDS:int = 40;
	}
}
