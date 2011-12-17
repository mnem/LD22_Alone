package entities.asteroids
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	import utility.SimpleObjectPool;
	import utility.SimpleObjectPoolWatcher;

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
			super(0, 0, asteroids);
			name = NAME;
			pool = new SimpleObjectPool("Asteroids", Asteroid, this);

			Input.define("sling", Key.Q);
		}

		override public function update():void
		{
			if (Input.pressed("sling"))
			{
				sling();
			}
			asteroids.update();
		}

		public function sling():void
		{
			var asteroid:Asteroid = pool.take() as Asteroid;

			asteroid.x = 0;
			asteroid.y = 0;
			asteroid.xV = 20;
			asteroid.yV = 20;
			asteroid.rV = 20;

			asteroid.active = true;
			asteroid.visible = true;
		}

		public function itemWasCreated(item:*):void
		{
			var asteroid:Asteroid = item as Asteroid;
			asteroid.slinger = this;
			asteroids.add(asteroid);
		}

		protected var asteroids:Graphiclist = new Graphiclist();
		protected var pool:SimpleObjectPool;
	}
}
