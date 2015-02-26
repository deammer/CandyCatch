package ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class Frame extends Entity 
	{
		private var _frame:Tilemap;
		private var _grid:Grid;
		
		public function Frame() 
		{
			super();
			type = "frame";
			
			buildFrame();
			graphic = _frame;
			mask = _grid;
			layer = Config.LAYER_UI;
		}
		
		private function buildFrame():void 
		{
			// do this dynamically, in case the size changes in the future
			_frame = new Tilemap(Assets.UI_FRAME, Config.WIDTH, Config.HEIGHT, 16, 16);
			
			// set the corner
			_frame.setTile(0, 0, 0);
			_frame.setTile(_frame.columns - 1, 0, 2);
			_frame.setTile(0, _frame.rows - 1, 6);
			_frame.setTile(_frame.columns - 1, _frame.rows- 1, 8);
			
			// set the sides
			_frame.setRect(0, 1, 1, _frame.rows - 2, 3);
			_frame.setRect(1, 0, _frame.columns - 2, 1, 1);
			_frame.setRect(1, _frame.rows - 1, _frame.columns - 2, 1, 7);
			_frame.setRect(_frame.columns - 1, 1, 1, _frame.rows - 2, 5);
			
			_grid = new Grid(Config.WIDTH, Config.HEIGHT, 16, 16);
			_grid.setRect(0, 0, _grid.columns, _grid.rows);
			_grid.setRect(1, 1, _grid.columns - 2, _grid.rows - 4, false);
		}
	}
}