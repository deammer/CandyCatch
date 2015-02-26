package  
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class Config 
	{
		public static var DEBUG:Boolean = false;
		
		public static var WIDTH:int = 224;
		public static var HEIGHT:int = 240;
		public static var SCALE:int = 2;
		
		/** Tile size. */
		public static const SIZE:int = 16;
		
		public static const LAYER_BACKGROUND:int = 2;
		public static const LAYER_MIDGROUND:int = 1;
		public static const LAYER_FOREGROUND:int = 0;
		public static const LAYER_ITEMS:int = -1;
		public static const LAYER_UI:int = -HEIGHT;
		
		public static function init():void
		{
			Input.define("LEFT", Key.LEFT, Key.A);
			Input.define("RIGHT", Key.RIGHT, Key.D);
			Input.define("JUMP", Key.W, Key.UP, Key.SPACE, Key.SHIFT, Key.ENTER, Key.Z, Key.X, Key.C);
			Input.define("RESTART", Key.R, Key.ENTER, Key.NUMPAD_ENTER);
			Input.define("PAUSE", Key.P, Key.ESCAPE);
		}
	}
}