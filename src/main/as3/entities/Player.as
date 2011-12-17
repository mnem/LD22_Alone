package entities
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;

	import flash.geom.Point;

	/**
	 * @author mnem
	 */
	public class Player extends Entity
	{
		private static const MAX_MOUSE_DISTANCE:Number = 300;
		private static const MAX_VELOCITY:Number = 5;
		protected var playerImage:Image;
		protected var screenCentreX:int;
		protected var screenCentreY:int;
		protected var _scratchPoint:Point = new Point();
		public var velocity:Point = new Point();

		public function Player(x:Number = 0, y:Number = 0)
		{
			screenCentreX = FP.bounds.width / 2;
			screenCentreY = FP.bounds.height / 2;

			playerImage = new Image(PNGAsset.Player);

			playerImage.originX = playerImage.width / 2;
			playerImage.originY = playerImage.height / 2;

			super(x, y, playerImage);
		}

		override public function update():void
		{
			if (Input.mouseDown)
			{
				// Find the angle and distance from the centre point
				playerImage.angle = FP.angle(screenCentreX, screenCentreY, Input.mouseFlashX, Input.mouseFlashY);

				_scratchPoint.x = FP.clamp(screenCentreX - Input.mouseFlashX, -MAX_MOUSE_DISTANCE, MAX_MOUSE_DISTANCE);
				_scratchPoint.y = FP.clamp(screenCentreY - Input.mouseFlashY, -MAX_MOUSE_DISTANCE, MAX_MOUSE_DISTANCE);

				velocity.x = _scratchPoint.x / MAX_MOUSE_DISTANCE * MAX_VELOCITY;
				velocity.y = _scratchPoint.y / MAX_MOUSE_DISTANCE * MAX_VELOCITY;
			}

			x -= velocity.x;
			y -= velocity.y;

			velocity.x *= 0.9;
			velocity.y *= 0.9;
		}
	}
}
