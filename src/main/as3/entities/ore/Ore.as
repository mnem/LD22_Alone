package entities.ore
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.utils.Ease;

	/**
	 * @author mnem
	 */
	public class Ore extends Entity
	{
		public static const MAX:Number = 100;
		//
		public var emitter:Emitter;
		public var currentLife:Number;
		public var life:Number;
		public var decayRate:Number;
		public var xV:Number;
		public var yV:Number;
		public var r:Number;
		public var g:Number;
		public var b:Number;
		public var pickupSound:Sfx;
		public var goneSound:Sfx;

		public function Ore()
		{
			emitter = new Emitter(ImageAsset.Particle);

			emitter.newType(ORE);
			emitter.setAlpha(ORE, 1, 0);
			emitter.setMotion(ORE, 0, 32, 2, 360, -26, -1, Ease.quadOut);

			super(0, 0, emitter);

			setHitbox(32, 32, 16, 16);

			layer = Layers.ORE;
			type = CollisionTypes.ORE;

			pickupSound = new Sfx(AudioAsset.OrePickup);
			goneSound = new Sfx(AudioAsset.OreGone);
		}

		public function spawn(r:Number, g:Number, b:Number):void
		{
			r = FP.clamp(r, 0, 1);
			g = FP.clamp(g, 0, 1);
			b = FP.clamp(b, 0, 1);

			this.r = MAX * r;
			this.g = MAX * g;
			this.b = MAX * b;

			var rc:uint = r > g && r > b ? 0xff : 0xff * r;
			var gc:uint = g > r && g > b ? 0xff : 0xff * g;
			var bc:uint = b > g && b > r ? 0xff : 0xff * b;

			emitter.setColor(ORE, (rc << 16) | (gc << 8) | bc);

			life = this.r + this.g + this.b;
			currentLife = life;

			visible = true;
			active = true;
			collidable = true;
		}

		override public function update():void
		{
			x += xV * FP.elapsed;
			y += yV * FP.elapsed;
			currentLife -= decayRate * FP.elapsed;

			xV *= 0.9;
			yV *= 0.9;

			if (currentLife <= 0)
			{
				expired();
			}
			else
			{
				var toEmit:int = (currentLife - emitter.particleCount) * FP.elapsed;
				for (var i:int = 0; i < toEmit; i++)
				{
					emitter.emit(ORE, 0, 0);
				}
			}
		}

		public function expired(collected:Boolean = false):void
		{
			visible = false;
			active = false;
			collidable = false;

			collected ? pickupSound.play() : goneSound.play(0.1);

			var bob:MinerBob = world.getInstance(MinerBob.NAME) as MinerBob;
			if (bob)
			{
				bob.oreEaten(this);
			}
		}

		private static const ORE:String = "ore";
	}
}
