package items
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class Candy extends Entity
	{
		public static const COLORS:Vector.<int> = new <int>[BAR, LOLLIPOP, HARD, CANE];
		public static const BAR:int = 0;
		public static const LOLLIPOP:int = 1;
		public static const HARD:int = 2;
		public static const CANE:int = 3;
		
		private var _color:uint = BAR;
		
		private var _speed:Number = 10.0;
		private var _on_floor:Boolean = false;
		private var _flash:int;
		private var _delete_me:Boolean; // whether this thould be deleted
		
		public function Candy()
		{
			super(0, 0);
			
			layer = Config.LAYER_ITEMS;
			width = height = 32;
			type = "candy";
		}
		
		public function create(x:int, color:int = BAR):void
		{
			this.x = x;
			this.y = -Config.SIZE;
			
			// reset flags
			_delete_me = false;
			_flash = 8;
			_color = color;
			_on_floor = false;
			
			graphic = new Image(Assets.CANDIES, new Rectangle(color * 32, 0, 32, 32));
			graphic.visible = true;
		}
		
		public function moveDown():void
		{
			if (!_on_floor)
			{
				y += Config.SIZE * 0.5;
				if (y >= Config.HEIGHT - Config.SIZE * 4)
				{
					y = Config.HEIGHT - Config.SIZE * 5;
					_on_floor = true;
					graphic = new Image(Assets.CANDIES, new Rectangle(_color * 32, 32, 32, 32));
					Global.spawner.candyReachedFloor(this);
				}
			}
			else
			{
				graphic.visible = !graphic.visible;
				_flash --;
				if (_flash <= 0)
				{
					_delete_me = true;
					y = -Config.SIZE;
				}
			}
		}
		
		public function get markedForDeletion():Boolean { return _delete_me; }
		public function get color():int { return _color; }
		public function get onFloor():Boolean { return _on_floor; }
	}
}