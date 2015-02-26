package
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import ui.Frame;
	import ui.MainMenu;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class Main extends Engine
	{
		public static const MAIN_MENU:String = "main menu";
		public static const GAME:String = "game";
		public static const LEVEL_SELECT:String = "level select";
		
		private static var _context_menu:ContextMenu;
		
		private var _save_data:SharedObject;
		
		public function Main()
		{
			super(Config.WIDTH, Config.HEIGHT);
			FP.screen.color = 0x0;
			FP.screen.scale = Config.SCALE;
			Config.init();
			if (Config.DEBUG) FP.console.enable();
			
			// set custom context menu
			_context_menu = new ContextMenu();
			_context_menu.hideBuiltInItems();
			_context_menu.builtInItems.quality = true;
			
			var name_button:ContextMenuItem = new ContextMenuItem("Maxime Preaux (Deammer)", true, true);
			name_button.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, openSite);
			_context_menu.customItems.push(name_button);
			_context_menu.customItems.push(new ContextMenuItem("Copyright 2014", false, false));
			contextMenu = _context_menu;
			
			// pull high score data, if any
			_save_data = SharedObject.getLocal("candy_catch_data");
			if (_save_data.data.highscore == undefined)
				_save_data.data.highscore = 0;
			else
				Global.highscore = _save_data.data.highscore;
			_save_data.close();
		}
		
		override public function init():void 
		{
			Global.frame = new Frame();
			
			switchScreen(MAIN_MENU);
			
			addEventListener(Event.DEACTIVATE, onFocusLost);
		}
		
		private function onFocusLost(e:Event):void 
		{
			if (FP.world is Game)
			{
				if (!(FP.world as Game).isPaused)
					(FP.world as Game).pause();
			}
		}
		
		public static function switchScreen(screen:String):void
		{
			Input.clear();
			FP.world.removeAll();
			
			if (screen == MAIN_MENU)
				FP.world = new MainMenu();
		}
		
		public static function playGame():void
		{
			Input.clear();
			FP.world.removeAll();
			
			FP.world = new Game();
		}
		
		private function openSite(e:ContextMenuEvent):void 
		{
			navigateToURL(new URLRequest("http://deammer.com"));
		}
		
		
	}
}