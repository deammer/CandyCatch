package  
{
	import flash.net.SharedObject;
	import levels.SpawnManager;
	import sound.MusicPlayer;
	import ui.FatDisplay;
	import ui.Frame;
	import ui.ScoreDisplay;
	import ui.SugarDisplay;
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class Global 
	{
		public static var spawner:SpawnManager;
		public static var score_display:ScoreDisplay;
		public static var fat_display:FatDisplay;
		public static var sugar_display:SugarDisplay;
		public static var player:Player;
		public static var frame:Frame;
		public static var game:Game;
		public static var score:int;
		public static var highscore:int;
		public static var difficulty:int;
		
		static public function saveHighScore():void 
		{
			highscore = score;
			
			// pull high score data, if any
			var data:SharedObject = SharedObject.getLocal("candy_catch_data");
			if (data.data.highscore == undefined || data.data.highscore < highscore)
				data.data.highscore = highscore;
			data.close();
		}
		
		static public function get volume():Number { return _volume; }
		static public function set volume(level:Number)
		{
			_volume = level;
			MusicPlayer.setVolume(level);
		}
		
		private static var _volume:Number = 1.0;
		
	}
}