package 
{
	import levels.SpawnManager;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import sound.MusicPlayer;
	import sound.SoundPlayer;
	import ui.FlashingText;
	import ui.HUD;
	import ui.MainMenu;
	import ui.SpeakerButton;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class Game extends World
	{
		// level stuff
		private var hud:HUD;
		
		private var main_menu:MainMenu;
		
		private var pause_graphic:Image;
		
		// sugar rush graphics
		private var _sg_bg:Image;
		private var _sg_sun:Image;
		private var _sg_grass:Image;
		
		// world
		private var _bg:Entity;
		private var _mg:Entity;
		private var _fg:Entity;
		
		// tweens
		private var _sugar_rush_alarm:Alarm;
		private var _sugar_rush_blink:Alarm;
		
		// game over
		private var _game_over_graphic:Image;
		private var _game_over:Boolean;
		private var _game_over_score:Text;
		private var _game_over_text:FlashingText;
		
		// pause stuff
		private var _paused:Boolean;
		private var _pause_text:Text;
		private var _resume_text:FlashingText;
		private var _speaker:SpeakerButton;
		
		public function Game()
		{
			Global.game = this;
			Global.score = 0;
			Global.spawner = new SpawnManager();
			Global.difficulty = 0;
			
			_game_over = false;
			_paused = false;
			
			MusicPlayer.playMusic(Assets.MSC_SHORT);
		}
		
		override public function begin():void 
		{
			add(Global.frame);
			
			Global.player = new Player((Config.WIDTH - Config.SIZE)* 0.5, Config.HEIGHT - Config.SIZE * 3);
			Global.player.x -= Global.player.width;
			Global.player.y -= 80;
			add(Global.player);
			
			_bg = new Entity(0, 0, new Image(Assets.BACKGROUND));
			_bg.layer = Config.LAYER_BACKGROUND;
			add(_bg);
			
			_mg = new Entity(0, 0, new Image(Assets.MIDGROUND));
			_mg.layer = Config.LAYER_MIDGROUND;
			add(_mg);
			
			_fg = new Entity(0, 0, new Image(Assets.FOREGROUND));
			_fg.layer = Config.LAYER_FOREGROUND;
			add(_fg);
			
			hud = new HUD();
			add(hud);
			
			_pause_text = new Text("PAUSE", Config.WIDTH * 0.5, Config.HEIGHT * 0.5);
			_pause_text.color = 0xffffff;
			_pause_text.font = "CandyFont";
			_pause_text.x -= _pause_text.width * 0.5;
			_pause_text.visible = false;
			addGraphic(_pause_text, Config.LAYER_UI);
			
			_resume_text = new FlashingText("P to resume", Config.WIDTH * 0.5, Config.HEIGHT * 0.56);
			_resume_text.size = 8;
			//_resume_text.color = 0x0;
			add(_resume_text);
			_resume_text.visible = _resume_text.active = false;
			
			_speaker = new SpeakerButton();
			_speaker.x = Config.WIDTH * 0.5 - _speaker.halfWidth;
			_speaker.y = Config.HEIGHT * 0.42;
			_speaker.active = false;
			_speaker.visible = false;
			add(_speaker);
			
			Global.spawner.begin();
		}
		
		public function startSugarRush():void
		{
			// visuals
			if (_sg_bg == null)
			{
				_sg_bg = new Image(Assets.RUSH_BG);
				_sg_grass = new Image(Assets.RUSH_GRASS);
				_sg_sun = new Image(Assets.RUSH_SUN);
				
				addGraphic(_sg_bg, Config.LAYER_BACKGROUND);
				addGraphic(_sg_grass, Config.LAYER_FOREGROUND);
				addGraphic(_sg_sun, Config.LAYER_FOREGROUND);
				
				_sg_grass.visible = false;
				_sg_sun.visible = false;
			}
			_sg_bg.visible = true;
			
			// setup callback
			if (_sugar_rush_alarm != null)
				removeTween(_sugar_rush_alarm);
			_sugar_rush_alarm = new Alarm(3.0, endSugarRush);
			addTween(_sugar_rush_alarm, true);
			
			// setup psychedelic shit
			if (_sugar_rush_blink == null)
			{
				_sugar_rush_blink = new Alarm(0.2, blinkVisuals, Tween.LOOPING);
				addTween(_sugar_rush_blink, true);
			}
			
			// player
			Global.player.sugarRush();
			
			// increase speed of spawn manager
			Global.spawner.startSugarRush();
			
			// increase difficulty!
			Global.difficulty ++;
		}
		
		/** MY EYES OMFG */
		private function blinkVisuals():void
		{
			if (_sg_bg.visible)
			{
				_sg_bg.visible = false;
				_sg_grass.visible = true;
				_sg_sun.visible = false;
			}
			else if (_sg_grass.visible)
			{
				_sg_bg.visible = false;
				_sg_grass.visible = false;
				_sg_sun.visible = true;
			}
			else
			{
				_sg_bg.visible = true;
				_sg_grass.visible = false;
				_sg_sun.visible = false;
			}
		}
		
		public function endSugarRush():void
		{
			// reset visuals
			_sg_bg.visible = false;
			_sg_grass.visible =	false;
			_sg_sun.visible = false;
			
			// remove the timers
			removeTween(_sugar_rush_blink);
			removeTween(_sugar_rush_alarm);
			_sugar_rush_blink = null;
			_sugar_rush_alarm = null;
			
			// reset spawner
			Global.spawner.endSugarRush();	
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed("PAUSE"))
				pause();			
			
			if (_game_over)
			{
				if (Input.check("JUMP") || Input.check("RESTART"))
					Main.playGame();
			}
			else if (!_paused && !Global.player.isDead)
				Global.spawner.update();
		}
		
		public function pause():void
		{
			// get all the entities
			var entities:Array = new Array();
			getAll(entities);
			
			for each (var e:Entity in entities)
			{
				e.active = _paused;
				if (e.graphic != null)
					e.graphic.active = _paused;
			}
			
			// show/hide pause graphic (it should always be active
			_pause_text.active = true;
			_pause_text.visible = !_paused;
			(_bg.graphic as Image).color = _paused ? 0xffffff : 0x666666;
			
			// resume text
			_resume_text.visible = _resume_text.active = !_paused;
			
			// show/hide speaker button
			_speaker.active = !_paused;
			_speaker.visible = !_paused;
			
			if (!_paused)
				MusicPlayer.pause();
			else
				MusicPlayer.resume();
			
			_paused = !_paused;
		}
		
		public function gameOver():void
		{
			// tween the game-over graphic
			_game_over_graphic = new Image(Assets.UI_GAME_OVER);
			_game_over_graphic.y = -_game_over_graphic.height;
			addGraphic(_game_over_graphic);
			
			var tween:VarTween = new VarTween(function():void { _game_over = true; } );
			tween.tween(_game_over_graphic, "y", 0, 1.0, Ease.cubeOut);
			addTween(tween, true);
			
			// play sound
			SoundPlayer.playSound(Assets.SFX_LOSE, 0.9);
			
			remove(hud);
			
			// score stuff
			var s:String;
			// if new high score
			if (Global.highscore < Global.score)
			{
				s = "New Highscore!\n" + Global.score;
				Global.saveHighScore();
			}
			else
				s = "Score = " + Global.score + "\nHighscore = " + Global.highscore;
			
			_game_over_score = new Text(s);
			_game_over_score.color = 0x0;
			_game_over_score.align = "center";
			_game_over_score.font = "CandyFont";
			_game_over_score.x = (Config.WIDTH - _game_over_score.textWidth) * 0.5;
			_game_over_score.y = Config.HEIGHT - Config.SIZE * 2.8;
			addGraphic(_game_over_score);
			
			_game_over_text = new FlashingText("R to restart", Config.WIDTH >> 1, Config.HEIGHT * 0.66);
			_game_over_text.color = 0x0;
			_game_over_text.size = 8;
			add(_game_over_text);
		}
		
		public function get isPaused():Boolean { return _paused; }
	}
}