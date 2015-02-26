package ui
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class HUD extends Entity
	{
		private var _ui:Image;
		
		public function HUD()
		{
			super();
			
			_ui = new Image(Assets.UI_BOTTOM);
			_ui.x = 0;
			_ui.y = Config.HEIGHT - _ui.height;
			
			layer = Config.LAYER_UI;
			graphic = _ui;
			
			width = 32;
			height = 192;
			setHitboxTo(_ui);
			type = "frame";
		}
		
		override public function added():void
		{
			Global.score_display = new ScoreDisplay(Config.WIDTH - 72, Config.HEIGHT - 30);
			Global.fat_display = new FatDisplay(Config.WIDTH - 124, Config.HEIGHT - 27);
			Global.sugar_display = new SugarDisplay(23, Config.HEIGHT - 23);
			
			world.add(Global.score_display);
			world.add(Global.fat_display);
			world.add(Global.sugar_display);
		}
		
		override public function removed():void 
		{
			world.remove(Global.score_display);
			world.remove(Global.fat_display);
			world.remove(Global.sugar_display);
		}
	}
}