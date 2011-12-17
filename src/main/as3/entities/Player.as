package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;

	/**
	 * @author mnem
	 */
	public class Player extends Entity
	{
		protected var playerImage:Image;
		protected var vPPS:int = 200;

		public function Player(x:Number = 0, y:Number = 0)
		{
			playerImage = new Image(PNGAsset.Player);

			playerImage.x -= playerImage.width / 2;
			playerImage.y -= playerImage.height / 2;

			super(x, y, playerImage);
		}

		override public function update():void
		{
			if(Input.mouseDown)
			{
				if(Input.mouseFlashX > FP.bounds.width / 2)
				{
					x += vPPS * FP.elapsed;
				}
				else
				{
					x -= vPPS * FP.elapsed;
				}

				if(Input.mouseFlashY > FP.bounds.height / 2)
				{
					y += vPPS * FP.elapsed;
				}
				else
				{
					y -= vPPS * FP.elapsed;
				}
			}
		}
	}
}
