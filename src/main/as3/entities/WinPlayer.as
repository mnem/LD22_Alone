package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.motion.CubicMotion;

	/**
	 * @author mnem
	 */
	public class WinPlayer extends Entity
	{
		public var image:Spritemap;
		public var engineSound:Sfx;
		public var home:Sfx;
		public var mt:CubicMotion;

		public function WinPlayer()
		{
			image = new Spritemap(ImageAsset.Player, 32, 32);
			image.add(Player.ANIM_REST, [0, 1], 4, true);
			// image = new Image(PNGAsset.Player);
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			image.play(Player.ANIM_REST);
			engineSound = new Sfx(AudioAsset.Engine);
			home = new Sfx(AudioAsset.Home);
			super(0, 250, image);

			mt = new CubicMotion(motionFinished);
			mt.setMotion(x, y, 200, 100, 400, 200, 700, 300, 5);
			addTween(mt);
			engineSound.loop(0.2);
		}

		protected function motionFinished():void
		{
			engineSound.stop();
			home.play(0.8);
			this.active = false;
			this.visible = false;
			world.add(new FinText());
		}

		override public function update():void
		{
			x = mt.x;
			y = mt.y;
		}
	}
}
