package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;

	import worlds.OuterSpace;

	/**
	 * @author mnem
	 */
	public class IntroText extends Entity
	{
		public var text:Text;
		public var keySound:Sfx;

		public function IntroText()
		{
			text = new Text("");
			super(10, 60, text);
			keySound = new Sfx(AudioAsset.Letter);
			layer = Layers.HUD;
		}

		override public function update():void
		{
			if (movingOn) return;

			if (!finished)
			{
				pause -= FP.elapsed;
				if (pause <= 0)
				{
					var char:String = TEXT.charAt(currentChar);
					pause = pausePeriodAfterCharAt(currentChar);

					text.text += char;
					currentChar++;
					if (pause == NORMAL_PAUSE)
					{
						if (!keySound.playing)
						{
							keySound.loop(0.2);
						}
					}
					else
					{
						keySound.stop();
					}

					if (currentChar >= TEXT.length)
					{
						keySound.stop();
						finished = true;
					}
				}
			}

			if (Input.mousePressed || Input.check(-1))
			{
				movingOn = true;
				keySound.stop();
				world.add(new FadeToColourThenDoSomething(0x000000, moveToOuterSpace));
			}
		}

		protected function moveToOuterSpace():void
		{
			FP.world = new OuterSpace();
		}

		protected function pausePeriodAfterCharAt(index:uint):Number
		{
			if (index < TEXT.length)
			{
				var char:String = TEXT.charAt(index);
				var next:String = index + 1 < TEXT.length ? TEXT.charAt(index + 1) : "" ;
				if ((char == "." || char == "?" || char == "!") && next == " ")
				{
					return SENTENCE_PAUSE;
				}
				else if (char == "\n" && next == "\n")
				{
					return NO_PAUSE;
				}
				else if (char == "\n")
				{
					return NEWLINE_PAUSE;
				}
			}
			return NORMAL_PAUSE;
		}

		protected var currentChar:uint = 0;
		protected var pause:Number = 0;
		protected var finished:Boolean = false;
		protected var movingOn:Boolean = false;
		protected static const TEXT:String = "What... What happened? I remember pain. Pain then, darkness.\n\nMy ship. Something hit my ship. Ejected. I remember now. I'm stuck here, floating in space.\n\n\nAlone...\n\n\nI need to repair it. I need to escape.\n\nI was hit by an asteroid! I'm in an asteroid belt. Maybe I can gather ore to repair my ship!\n\nThe blaster in my exosuit looks like it's working. What an unexpected stroke of luck.\n\n\n\nTime to blast some 'roids!";
		//
		private static const NORMAL_PAUSE:Number = 0.03;
		private static const SENTENCE_PAUSE:Number = 0.25;
		private static const NEWLINE_PAUSE:Number = 0.6;
		private static const NO_PAUSE:Number = 0;
	}
}
