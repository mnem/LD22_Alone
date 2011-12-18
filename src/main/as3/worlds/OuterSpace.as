package worlds
{
	import entities.Player;
	import entities.asteroids.AsteroidSlinger;
	import entities.bullets.BulletMaster;
	import entities.ore.MinerBob;
	import entities.starfield.Starfield;

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;

	/**
	 * @author mnem
	 */
	public class OuterSpace extends World
	{
		public static const SPACE_WIDTH:int = 890 * 5;
		public static const SPACE_HEIGHT:int = 500 * 5;
		public static const HALF_SPACE_WIDTH:int = SPACE_WIDTH / 2;
		public static const HALF_SPACE_HEIGHT:int = SPACE_HEIGHT / 2;
		//
		protected var halfBoundsWidth:int;
		protected var halfBoundsHeight:int;
		protected var player:Player;
		protected var bulletMaster:BulletMaster;
		protected var asteroidSlinger:AsteroidSlinger;
		protected var bob:MinerBob;
		protected var starfields:Vector.<Starfield>;

		public function OuterSpace()
		{
			halfBoundsWidth = FP.bounds.width / 2;
			halfBoundsHeight = FP.bounds.height / 2;

			createEntities();
		}

		protected function createEntities():void
		{
			player = new Player();
			add(player);

			starfields = new Vector.<Starfield>(5, true);
			starfields[0] = new Starfield(SPACE_WIDTH, SPACE_HEIGHT, 1000, 1.0, 0.4);
			starfields[1] = new Starfield(SPACE_WIDTH, SPACE_HEIGHT, 700, 0.7, 0.55);
			starfields[2] = new Starfield(SPACE_WIDTH, SPACE_HEIGHT, 500, 0.5, 0.7);
			starfields[3] = new Starfield(SPACE_WIDTH, SPACE_HEIGHT, 300, 0.3, 0.8);
			starfields[4] = new Starfield(SPACE_WIDTH, SPACE_HEIGHT, 150, 0.15, 1);
			for (var i:uint = 0;i < starfields.length; i++) add(starfields[i]);

			bulletMaster = new BulletMaster();
			add(bulletMaster);

			asteroidSlinger = new AsteroidSlinger();
			add(asteroidSlinger);

			bob = new MinerBob();
			add(bob);
		}

		override public function update():void
		{
			// update the entities
			var e:Entity = _updateFirst;
			while (e)
			{
				if (e.active)
				{
					if (e._tween) e.updateTweens();
					e.update();

					// Wrap it
					if (e.x < -HALF_SPACE_WIDTH) e.x += SPACE_WIDTH;
					if (e.x > HALF_SPACE_WIDTH) e.x -= SPACE_WIDTH;
					if (e.y < -HALF_SPACE_HEIGHT) e.y += SPACE_HEIGHT;
					if (e.y > HALF_SPACE_HEIGHT) e.y -= SPACE_HEIGHT;
				}
				if (e._graphic && e._graphic.active) e._graphic.update();
				e = e._updateNext;
			}

			// Camera always ensures player is centered
			camera.x = -halfBoundsWidth + player.x;
			camera.y = -halfBoundsHeight + player.y;
		}
	}
}
