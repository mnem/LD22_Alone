package worlds
{
	import entities.Player;
	import entities.asteroids.AsteroidSlinger;
	import entities.bullets.BulletMaster;
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
		protected var bulletMaster:BulletMaster;
		protected var asteroidSlinger:AsteroidSlinger;
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

			starfields = new Vector.<Starfield>(5, true);
			starfields[0] = new Starfield(FP.bounds.width * 5, FP.bounds.height * 5, 1000, 1.0, 0.4);
			starfields[1] = new Starfield(FP.bounds.width * 5, FP.bounds.height * 5, 700, 0.7, 0.55);
			starfields[2] = new Starfield(FP.bounds.width * 5, FP.bounds.height * 5, 500, 0.5, 0.7);
			starfields[3] = new Starfield(FP.bounds.width * 5, FP.bounds.height * 5, 300, 0.3, 0.8);
			starfields[4] = new Starfield(FP.bounds.width * 5, FP.bounds.height * 5, 150, 0.15, 1);

			bulletMaster = new BulletMaster();
			asteroidSlinger = new AsteroidSlinger();
		}

		protected function addEntities():void
		{
			for (var i:uint = 0;i < starfields.length; i++)
			{
				add(starfields[i]);
			}

			add(asteroidSlinger);
			add(player);
			add(bulletMaster);
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
