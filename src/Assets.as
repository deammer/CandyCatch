package  
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class Assets 
	{
		// actors
		[Embed(source = "../assets/player.png")] public static const PLAYER:Class;
		[Embed(source = "../assets/candy.png")] public static const CANDIES:Class;
		
		// environment
		[Embed(source = "../assets/background.png")] public static const BACKGROUND:Class;
		[Embed(source = "../assets/midground.png")] public static const MIDGROUND:Class;
		[Embed(source = "../assets/foreground.png")] public static const FOREGROUND:Class;
		
		// ui
		[Embed(source = "../assets/frame.png")] public static const UI_FRAME:Class;
		[Embed(source = "../assets/hud.png")] public static const UI_BOTTOM:Class;
		[Embed(source = "../assets/fat_bg.png")] public static const FAT_BARS:Class;
		[Embed(source = "../assets/game_over.png")] public static const UI_GAME_OVER:Class;
		[Embed(source = "../assets/title_screen.png")] public static const UI_TITLE:Class;
		[Embed(source = "../assets/speaker.png")] public static const UI_SPEAKER:Class;
		
		// sugar rush
		[Embed(source = "../assets/sugar_rush_bg.png")] public static const RUSH_BG:Class;
		[Embed(source = "../assets/sugar_rush_grass.png")] public static const RUSH_GRASS:Class;
		[Embed(source = "../assets/sugar_rush_sun.png")] public static const RUSH_SUN:Class;
		
		// sfx
		[Embed(source = "../assets/sfx_mp3/Fail.mp3")] public static const SFX_FAIL:Class;
		[Embed(source = "../assets/sfx_mp3/Jump.mp3")] public static const SFX_JUMP_0:Class;
		[Embed(source = "../assets/sfx_mp3/Jump2.mp3")] public static const SFX_JUMP_1:Class;
		[Embed(source = "../assets/sfx_mp3/Jump3.mp3")] public static const SFX_JUMP_2:Class;
		[Embed(source = "../assets/sfx_mp3/Move.mp3")] public static const SFX_MOVE:Class;
		[Embed(source = "../assets/sfx_mp3/Pickup1.mp3")] public static const SFX_PICKUP_1:Class;
		[Embed(source = "../assets/sfx_mp3/Pickup2.mp3")] public static const SFX_PICKUP_2:Class;
		[Embed(source = "../assets/sfx_mp3/Pickup3.mp3")] public static const SFX_PICKUP_3:Class;
		[Embed(source = "../assets/sfx_mp3/Pickup4.mp3")] public static const SFX_PICKUP_4:Class;
		[Embed(source = "../assets/sfx_mp3/Death.mp3")] public static const SFX_DEATH:Class;
		[Embed(source = "../assets/sfx_mp3/Lose.mp3")] public static const SFX_LOSE:Class;
		
		// music
		[Embed(source = "../assets/music/airducts_long.mp3")] public static const MSC_LONG:Class;
		[Embed(source = "../assets/music/airducts_medium.mp3")] public static const MSC_MED:Class;
		[Embed(source = "../assets/music/airducts_short.mp3")] public static const MSC_SHORT:Class;
		
		// font
		[Embed(source = "../assets/BitmapCandy.ttf", embedAsCFF="false", fontFamily = 'CandyFont')]
		public static var FONT_CANDY:Class;
	}
}