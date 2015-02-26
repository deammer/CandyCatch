package levels
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import items.Candy;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class SpawnManager
	{
		private const MAX_CANDY:int = 12;
		private var _candies:Vector.<Candy>;
		
		private var _period:Number = 1.0;
		private var _timer:Number;
		
		// spawning logic
		private var _last_color:uint = Candy.CANE;
		private var _columns:Vector.<int>; // holds the amount of candy in each column
		private var _can_spawn:Vector.<Boolean>; // holds the columns where candy can spawn
		
		// moving logic
		private var MOVE_STEP:int = 4; // in frames per second
		private var _move_timer:Number;
		
		// debug
		private var _debug_columns:Vector.<Image>;
		
		public function SpawnManager()
		{
			Global.spawner = this;
			
			_timer = _period;
			
			_move_timer = 1.0 / MOVE_STEP;
			_candies = new Vector.<Candy>();
			
			// init the 6 columns
			_columns = new Vector.<int>();
			_can_spawn = new Vector.<Boolean>();
			for (var i:int = 0; i < 6; i++)
			{
				_columns[i] = 0;
				_can_spawn[i] = true;
			}
			
			if (Config.DEBUG)
			{
				_debug_columns = new Vector.<Image>();
				
				for (i = 0; i < Config.WIDTH / Config.SIZE / 2 - 1; i++)
				{
					var column:Image = Image.createRect(Config.SIZE * 2 - 2, Config.HEIGHT, 0xffffff, 0.5);
					column.x = (i + .5) * Config.SIZE * 2 + 1;
					_debug_columns.push(column);
				}
			}
		}
		
		public function begin():void
		{
			if (Config.DEBUG)
			{
				for each (var i:Image in _debug_columns)
					FP.world.addGraphic(i);
			}
		}
		
		public function update():void
		{
			_move_timer -= FP.elapsed;
			moveCandies();
			
			if (_candies.length >= MAX_CANDY) return;
			
			_timer -= FP.elapsed;
			if (_timer <= 0)
			{
				var column_index:int = getRandomColumnIndex();
				// if all columns have 2 candies, cancel
				if (column_index == -1)
					return;
				
				var random_color:int = getRandomCandyColor();
				
				var candy:Candy = FP.world.create(Candy) as Candy;
				candy.create(FP.rand((Config.WIDTH - Config.SIZE * 2) / Config.SIZE) * Config.SIZE,
														random_color); // set color
				
				_columns[column_index] ++; // increment the number of candies in this column
				_can_spawn[column_index] = false;
				
				if (Config.DEBUG)
					_debug_columns[column_index].color = 0xff0000; // can't spawn there
				
				candy.x = column_index * Config.SIZE * 2 + Config.SIZE;
				_candies.push(candy);
				_last_color = random_color;
				_timer = _period;
			}
		}
		
		public function startSugarRush():void
		{
			_period *= 0.5;
			if (_timer > _period)
				_timer = _period;
		}
		
		public function endSugarRush():void 
		{
			_period = FP.clamp(2.0 - Global.difficulty * 0.18, 0.3, 2.0);
		}
		
		/**
		 * @return the index of an empty or 1-candy column, or -1
		 */
		private function getRandomColumnIndex():int
		{
			var available:Array = new Array();
			
			// look for empty columns first
			for (var i:int = 0; i < _columns.length; i++)
				if (_can_spawn[i] && _columns[i] == 0)
					available.push(i);
			
			// if we've found empty columns, return a random one
			if (available.length > 0)
				return available[Math.floor(Math.random() * available.length)];
			
			// look for columns with only one candy in them
			for (i = 0; i < _columns.length; i++)
				if (_can_spawn[i] && _columns[i] == 1)
					available.push(i);
				
			// if we haven't found any, return -1
			if (available.length == 0)
				return -1;
			
			// otherwise, return a random one
			return available[Math.floor(Math.random() * available.length)];
		}
		
		private function getRandomCandyColor():int
		{
			// create an array with all the available colors, aka excluding the last one spawned
			var available_colors:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < Candy.COLORS.length; i++)
			{
				if (Candy.COLORS[i] != _last_color)
					available_colors.push(Candy.COLORS[i]);
			}
			
			return available_colors[Math.floor(Math.random() * available_colors.length)];
		}
		
		private function moveCandies():void 
		{
			if (_move_timer > 0.0)
				return;
			
			_move_timer = 1.0 / (MOVE_STEP + Global.difficulty);
			
			for (var i:int = 0; i < _candies.length; i++)
				_candies[i].moveDown();
			
			// remove the candies marked for deletion
			for (i = _candies.length - 1; i >= 0; i--)
				if (_candies[i].markedForDeletion)
					remove(_candies[i]);
		}
		
		public function remove(candy:Candy):void
		{
			var column:int = (candy.x - Config.SIZE) / (Config.SIZE * 2);
			_columns[column]--;
			
			// if the column's empty, allow spawning again
			if (_columns[column] == 0)
				_can_spawn[column] = true;
			
			if (Config.DEBUG)
			{
				if (_columns[column] == 1)
					_debug_columns[column].color = 0xff0000; // can't spawn there, candy in the air!
				else if (_columns[column] == 0)
					_debug_columns[column].color = 0xffffff; // can spawn
			}
			
			// remove the candy
			_candies.splice(_candies.indexOf(candy), 1);
			FP.world.recycle(candy);
		}
		
		public function candyReachedFloor(candy:Candy):void 
		{
			var column:int = (candy.x - Config.SIZE) / (Config.SIZE * 2);
			_can_spawn[column] = true;
			
			if (Config.DEBUG)
				_debug_columns[column].color = 0xffff00; // can spawn
		}
	}
}