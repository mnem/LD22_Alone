package entities.hud
{
	import entities.Player;

	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;

	/**
	 * @author mnem
	 */
	public class Asteroidotron extends Entity
	{
		public static const NAME:String = "Asteroidotron";
		public static const ACTIVE:String = "active";
		public var indicator:Spritemap;
		//
		public var distance:Number;
		public var angle:Number;

		public function Asteroidotron()
		{
			indicator = new Spritemap(PNGAsset.AsteroidIndicator, 16, 16);
			indicator.add(ACTIVE, [0, 1, 2, 3, 4, 5], 15, true);
			indicator.play(ACTIVE);
			indicator.alpha = 0.75;

			indicator.originX = -100;
			indicator.originY = indicator.height / 2;

			indicator.scrollX = 0;
			indicator.scrollY = 0;
			indicator.angle = 90;
			super(0, 0, indicator);

			collidable = false;
			layer = Layers.HUD;
			name = NAME;
		}

		public function postUpdate():void
		{
			var player:Player = world.getInstance(Player.NAME)as Player;
			if (!isNaN(distance) && !isNaN(indicator.angle))
			{
				if (distance < 200 || (player && player.laserCharge > 0))
				{
					indicator.visible = false;
				}
				else
				{
					indicator.visible = true;
				}
			}
			else
			{
				indicator.visible = false;
			}
		}
	}
}
