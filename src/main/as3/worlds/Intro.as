package worlds
{
	import entities.IntroText;

	import net.flashpunk.World;

	/**
	 * @author mnem
	 */
	public class Intro extends World
	{
		public function Intro()
		{
			add(new IntroText());
		}
	}
}
