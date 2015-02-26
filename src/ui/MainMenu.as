package ui
{
	import flash.text.AntiAliasType;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class MainMenu extends World
	{
		private var _start_text:Text;
		private var _timer:Number = 0.5;
		
		// 
		private var _credits_text:Text;
		private var _btn_art:TextURL;
		private var _btn_code:TextURL;
		private var _btn_sound:TextURL;
		
		private var _speaker:SpeakerButton;
		
		public function MainMenu()
		{
			super();
			
			_start_text = new Text("Press any key to start", Math.floor(Config.WIDTH * 0.5), Config.HEIGHT * 0.78);
			_start_text.font = "CandyFont";
			_start_text.size = 8;
			_start_text.setTextProperty("antiAliasType", AntiAliasType.ADVANCED);
			_start_text.setTextProperty("sharpness", 800);
			_start_text.x -= 65;
			_start_text.y -= _start_text.height * 0.5;
			
			_credits_text = new Text("Art\nCode\\Design\nMusic", 0, Config.HEIGHT - 36);
			_credits_text.size = 8;
			_credits_text.align = "right";
			_credits_text.color = 0x555555;
			_credits_text.font = "CandyFont";
			
			_btn_art = new TextURL("Amy Saunders", Config.SIZE * 6.75, Config.HEIGHT - 36);
			_btn_art.url = "http://amysaundersonline.com";
			
			_btn_code = new TextURL("Maxime Preaux", Config.SIZE * 6.75, Config.HEIGHT - 28);
			_btn_code.url = "http://twitter.com/deammercraft";
			
			_btn_sound = new TextURL("PlayOnLoop", Config.SIZE * 6.75, Config.HEIGHT - 20);
			_btn_sound.url = "http://www.playonloop.com/";
			
			_speaker = new SpeakerButton();
			_speaker.x = Config.WIDTH - 1.5 * Config.SIZE;
			_speaker.y = 12;
		}
		
		override public function begin():void 
		{
			add(Global.frame);
			
			addGraphic(new Image(Assets.UI_TITLE));
			
			addGraphic(_start_text);
			addGraphic(_credits_text);
			
			addList(_btn_art, _btn_code, _btn_sound);
			add(_speaker);
		}
		
		override public function update():void 
		{
			super.update();
			
			_timer -= FP.elapsed;
			if (_timer <= 0)
			{
				_start_text.visible = !_start_text.visible;
				_timer = 0.5;
			}
			
			if (Input.pressed(Key.ANY))
				Main.playGame();
		}
	}
}