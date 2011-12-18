package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Text;

	/**
	 * @author mnem
	 */
	public class FinText extends Entity
	{
		public var text:Text;
		public var keySound:Sfx;

		public function FinText()
		{
			text = new Text("");
			text.color = 0x000000;
			super(730, 400, text);
			keySound = new Sfx(AudioAsset.Letter);
			layer = Layers.HUD;
			pause = 1;
		}

		override public function update():void
		{
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
		protected static const TEXT:String = "Never Alone...\n\nFin.";
		//
		private static const NORMAL_PAUSE:Number = 0.03;
		private static const SENTENCE_PAUSE:Number = 0.15;
		private static const NEWLINE_PAUSE:Number = 2;
		private static const NO_PAUSE:Number = 0;
	}
}
