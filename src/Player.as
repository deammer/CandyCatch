package  
{
	import items.Candy;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import sound.MusicPlayer;
	import sound.SoundPlayer;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class Player extends Entity 
	{
		// animation
		private var _spritemap:Spritemap;
		private var _anim_rate:int = 6;
		
		// movement
		private var _dx:int = 0;
		private var _step:int = Config.SIZE * 2;
		
		// eating
		private const FATS:Array = new Array("slim", "chubby", "fat");
		private var _fat_level:int = 0;				// dies if == 3
		private var _last_color:int = -1;
		private var _eating:Boolean = false;
		
		// jumping
		private const JUMP_HEIGHTS:Array = new Array(3 * Config.SIZE, 2 * Config.SIZE, Config.SIZE * 0.5);
		private const FLOOR_Y:int = Config.HEIGHT - Config.SIZE * 3;
		private const JUMP_TIME:Number = 0.6; // time spent in the air when jumping
		private var _jump_timer:Number = NaN;
		private var _in_air:Boolean = false;
		
		private var _dying:Boolean = false;
		
		public function Player(x:int = 0, y:int = 0)
		{
			super(x, y);
			
			_spritemap = new Spritemap(Assets.PLAYER, 48, 80, animDone);
			_spritemap.add("idle_" + FATS[0], [2], 0, false).play();
			_spritemap.add("idle_" + FATS[1], [10]);
			_spritemap.add("idle_" + FATS[2], [18]);
			_spritemap.add("walk_" + FATS[0], [3], _anim_rate);
			_spritemap.add("walk_" + FATS[1], [11], _anim_rate);
			_spritemap.add("walk_" + FATS[2], [19], _anim_rate);
			_spritemap.add("jump_" + FATS[0], [4], 0, false);
			_spritemap.add("jump_" + FATS[1], [12], 0, false);
			_spritemap.add("jump_" + FATS[2], [20], 0, false);
			_spritemap.add("land_" + FATS[0], [5], 0, false);
			_spritemap.add("land_" + FATS[1], [13], 0, false);
			_spritemap.add("land_" + FATS[2], [21], 0, false);
			_spritemap.add("eat_ground_" + FATS[0], [0, 1], _anim_rate, false);
			_spritemap.add("eat_ground_" + FATS[1], [8, 9], _anim_rate, false);
			_spritemap.add("eat_ground_" + FATS[2], [16, 17], _anim_rate, false);
			_spritemap.add("eat_air_" + FATS[0], [6, 7], _anim_rate, false);
			_spritemap.add("eat_air_" + FATS[1], [14, 15], _anim_rate, false);
			_spritemap.add("eat_air_" + FATS[2], [22, 23], _anim_rate, false);
			_spritemap.add("die", [24, 25, 24, 25, 24, 25, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], 6, false);
			graphic = _spritemap;
			
			setHitbox(32, 40, -8, -40);
			layer = Config.LAYER_ITEMS;
		}
		
		private function animDone():void 
		{
			switch (_spritemap.currentAnim.split("_")[0])
			{
				case "walk": // go from walk to idle
					_spritemap.play("idle_" + FATS[_fat_level], true);
					break;
				case "eat" : // go from eating to idle
					_spritemap.play("idle_" + FATS[_fat_level], true);
					_eating = false;
					_in_air = false;
					y = FLOOR_Y - 80;
					setHitbox(32, 40, -8, -40);
					break;
				case "die":
					Global.game.gameOver();
					break;
				default:
					trace("state = " + _spritemap.currentAnim.split("_")[0]);
			}
		}
		
		override public function update():void 
		{
			if (!_dying)
			{
				if (!_eating)
				{
					handleJumping();
					//if (!_in_air)
						handleHorizontalMovement();
				}
				
				handleEating();
			}
		}
		
		/** Called when the sugar meter is full */
		public function sugarRush():void 
		{
			if (_fat_level > 0)
				_fat_level --;
			
			Global.spawner.startSugarRush();
		}
		
		private function handleJumping():void
		{
			if (!_in_air && Input.pressed("JUMP"))
			{
				_in_air = true;
				y = FLOOR_Y - 80 - JUMP_HEIGHTS[_fat_level];
				_spritemap.play("jump_" + FATS[_fat_level], true);
				_jump_timer = JUMP_TIME;
				setHitbox(32, 80, -8);
				playJumpSound();
			}
			else if (_in_air)
			{
				if (!isNaN(_jump_timer))
				{
					_jump_timer -= FP.elapsed;
					
					// 1/3rd of the timer
					if (_spritemap.currentAnim == "jump_" + FATS[_fat_level] && _jump_timer <= JUMP_TIME * 2 / 3)
						_spritemap.play("land_" + FATS[_fat_level]); // land anim
					else if (y == FLOOR_Y - 80 - JUMP_HEIGHTS[_fat_level] && _jump_timer <= JUMP_TIME / 3)
						y += Config.SIZE * 2; // move down a bit
					else if (_spritemap.currentAnim == "land_" + FATS[_fat_level] && _jump_timer <= 0.0)
					{
						y = FLOOR_Y - 80;
						_in_air = false;
						_spritemap.play("idle_" + FATS[_fat_level]);
						_jump_timer = NaN;
						setHitbox(32, 40, -8, -40);
					}
				}
			}
		}
		
		private function handleEating():void 
		{
			var candy:Candy = collide("candy", x, y) as Candy;
			if (candy)
			{
				// update score
				Global.score ++;
				Global.score_display.setScore(Global.score);
				
				_eating = true;
				
				if (_in_air)
					_spritemap.play("eat_air_" + FATS[_fat_level], true);
				else
					_spritemap.play("eat_ground_" + FATS[_fat_level], true);
				
				// if same candy as last one, get fatter
				if (candy.color == _last_color)
				{
					SoundPlayer.playSound(Assets.SFX_FAIL, 0.9);
					getFatter();
				}
				else
				{
					playPickupSound(candy.color);
					Global.sugar_display.increaseLevel();
				}
				
				_last_color = candy.color;
				
				Global.spawner.remove(candy);
			}
		}
		
		private function playJumpSound():void
		{
			switch (_fat_level)
			{
				case 0:
					SoundPlayer.playSound(Assets.SFX_JUMP_0, 0.5);
					break;
				case 1:
					SoundPlayer.playSound(Assets.SFX_JUMP_1, 0.5);
					break;
				case 2:
					SoundPlayer.playSound(Assets.SFX_JUMP_2, 0.5);
					break;
			}
		}
		
		private function playPickupSound(color:int):void 
		{
			switch (color)
			{
				case Candy.BAR:
					SoundPlayer.playSound(Assets.SFX_PICKUP_1, 0.8);
					break;
				case Candy.CANE:
					SoundPlayer.playSound(Assets.SFX_PICKUP_2, 0.8);
					break;
				case Candy.HARD:
					SoundPlayer.playSound(Assets.SFX_PICKUP_3, 0.8);
					break;
				case Candy.LOLLIPOP:
					SoundPlayer.playSound(Assets.SFX_PICKUP_4, 0.8);
					break;
			}
		}
		
		private function getFatter():void
		{
			Global.sugar_display.reset();
			if (_fat_level >= FATS.length - 1)
			{
				die();
				Global.fat_display.setLevel(3);
			}
			else
			{
				_fat_level ++;
				Global.fat_display.setLevel(_fat_level);
			}
		}
		
		private function die():void 
		{
			SoundPlayer.playSound(Assets.SFX_DEATH);
			y = FLOOR_Y - 80;
			_dying = true;
			_spritemap.play("die");
			
			// fade out the music
			MusicPlayer.fadeOut();
		}
		
		private function getSlimmer():void
		{
			_fat_level = FP.clamp(_fat_level - 1, 0, 3);
		}
		
		private function handleHorizontalMovement():void
		{
			_dx = 0;
			
			// check input && stay within the screen
			if (Input.pressed("RIGHT") && x < Config.WIDTH - _step * 2)
				_dx ++;
			if (Input.pressed("LEFT") && x > _step)
				_dx --;
			
			if (_dx != 0)
				SoundPlayer.playSound(Assets.SFX_MOVE, 0.3);
			
			x += _dx * _step;
			if (Math.abs(_dx) != 0.0 && !_in_air)
				_spritemap.play("walk_" + FATS[_fat_level]);
			
			// flipping the spritemap
			if (_dx > 0) _spritemap.flipped = false;
			if (_dx < 0) _spritemap.flipped = true;
		}
		
		public function get isDead():Boolean { return _dying; }
	}
}