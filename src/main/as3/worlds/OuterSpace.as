package worlds
{
	import entities.FadeToColourThenDoSomething;
	import entities.HelpText;
	import entities.Player;
	import entities.asteroids.AsteroidSlinger;
	import entities.bullets.BulletMaster;
	import entities.hud.Asteroidotron;
	import entities.hud.Bar;
	import entities.ore.MinerBob;
	import entities.starfield.Starfield;

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;

	/**
	 * @author mnem
	 */
	public class OuterSpace extends World
	{
		public static const SPACE_WIDTH:int = 890 * 10;
		public static const SPACE_HEIGHT:int = 500 * 10;
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
		protected var indicator:Asteroidotron;
		protected var fade:FadeToColourThenDoSomething;
		protected var helpText:Text;

		public function OuterSpace()
		{
			halfBoundsWidth = FP.bounds.width / 2;
			halfBoundsHeight = FP.bounds.height / 2;

			createEntities();
			createHUD();
		}

		protected function createHUD():void
		{
			var x:int = 8;
			var y:int = 32;
			var bar:Bar = new Bar();

			bar.name = Bar.R;
			bar.setColour(0xff0000);
			bar.showValue(0, Config.ORE_TARGET);
			bar.y = y;
			bar.x = x;
			y += bar.marker.height + 2;
			bar.label.play(Bar.R);
			add(bar);

			bar = new Bar();
			bar.name = Bar.G;
			bar.setColour(0x00ff00);
			bar.showValue(0, Config.ORE_TARGET);
			bar.y = y;
			bar.x = x;
			y += bar.marker.height + 2;
			bar.label.play(Bar.G);
			add(bar);

			bar = new Bar();
			bar.name = Bar.B;
			bar.setColour(0x0000ff);
			bar.showValue(0, Config.ORE_TARGET);
			bar.y = y;
			bar.x = x;
			y += bar.marker.height + 2;
			bar.label.play(Bar.B);
			add(bar);

			indicator = new Asteroidotron();
			indicator.x = halfBoundsWidth;
			indicator.y = halfBoundsHeight;
			add(indicator);

			fade = new FadeToColourThenDoSomething(0x000000, removeFade, true);
			add(fade);

			add(new HelpText());
		}

		protected function removeFade():void
		{
			remove(fade);
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
			// Reset the asteroidotron
			indicator.distance = Number.MAX_VALUE;
			indicator.angle = NaN;

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

			indicator.postUpdate();

			// Camera always ensures player is centered
			camera.x = -halfBoundsWidth + player.x;
			camera.y = -halfBoundsHeight + player.y;
		}
	}
}
