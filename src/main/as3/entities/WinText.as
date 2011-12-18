package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;

	import worlds.Intro;

	import flash.display.BitmapData;

	/**
	 * @author mnem
	 */
	public class WinText extends Entity
	{
		public static const BACK_COLOUR:uint = 0x9CE9FF;
		public var text:Text;
		public var keySound:Sfx;

		public function WinText()
		{
			var image:Image = new Image(new BitmapData(FP.bounds.width, FP.bounds.height, false, BACK_COLOUR));
			image.scrollX = 0;
			image.scrollY = 0;
			image.relative = false;

			var house:Image = new Image(ImageAsset.Win);
			house.scrollX = 0;
			house.scrollY = 0;
			house.x = FP.bounds.width - house.width;
			house.y = FP.bounds.height - house.height;
			house.relative = false;

			text = new Text("");
			text.color = 0x000000;
			super(10, 60, new Graphiclist(image, house, text));
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
						world.add(new WinPlayer());
					}
				}
			}

			if (finished && (Input.mousePressed || Input.check(-1)))
			{
				movingOn = true;
				keySound.stop();
				world.add(new FadeToColourThenDoSomething(0x000000, moveOn));
			}
		}

		protected function moveOn():void
		{
			FP.world = new Intro();
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
		protected static const TEXT:String = "I did it! There was enough ore for the repairs!\n\n\nI can go home!";
		//
		private static const NORMAL_PAUSE:Number = 0.03;
		private static const SENTENCE_PAUSE:Number = 0.15;
		private static const NEWLINE_PAUSE:Number = 0.5;
		private static const NO_PAUSE:Number = 0;
	}
}
