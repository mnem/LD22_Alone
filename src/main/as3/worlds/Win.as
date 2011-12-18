package worlds
{
	import entities.WinText;

	import net.flashpunk.World;

	/**
	 * @author mnem
	 */
	public class Win extends World
	{
		public function Win()
		{
			add(new WinText());
		}
	}
}
