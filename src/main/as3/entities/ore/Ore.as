package entities.ore
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.utils.Ease;

	import flash.display.BitmapData;

	/**
	 * @author mnem
	 */
	public class Ore extends Entity
	{
		public var emitter:Emitter;
		public var currentLife:Number;
		public var life:Number;
		public var decayRate:Number;
		public var xV:Number;
		public var yV:Number;

		public function Ore()
		{
			emitter = new Emitter(PNGAsset.Particle);

			emitter.newType(ORE);
			emitter.setAlpha(ORE, 1, 0);
			emitter.setMotion(ORE, 0, 32, 2, 360, -26, -1, Ease.quadOut);

			super(0, 0, emitter);

			setHitbox(32, 32, 16, 16);

			layer = Layers.ORE;
			type = CollisionTypes.ORE;
		}

		public function spawn(r:uint, g:uint, b:uint):void
		{
			r &= 0xff;
			g &= 0xff;
			b &= 0xff;

			emitter.setColor(ORE, (r << 16) | (g << 8) | b, 0xffffff);

			life = r + g + b;
			currentLife = life;

			visible = true;
			active = true;
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

		public function expired():void
		{
			visible = false;
			active = false;
			var bob:MinerBob = world.getInstance(MinerBob.NAME) as MinerBob;
			if (bob)
			{
				bob.oreEaten(this);
			}
		}

		private static const ORE:String = "ore";
	}
}
