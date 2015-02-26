package ui
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledImage;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class SugarDisplay extends Entity
	{
		private const _SIZE:int = 50;
		private const _MAX_AMOUNT:int = 8;
		private var _amount:int = 0;
		
		public function SugarDisplay(x:int, y:int)
		{
			super(x, y);
			
			layer = Config.LAYER_UI;
			
			// don't create the image if we don't need to
			if (_amount > 0)
				graphic = Image.createRect(_amount * _SIZE, 6, 0x0);
		}
		
		public function increaseLevel():void
		{
			_amount ++;
			if (graphic != null)
				graphic.visible = true;
			graphic = Image.createRect(_SIZE / _MAX_AMOUNT * _amount, 6, 0x0);
			
			if (_amount >= _MAX_AMOUNT)
			{
				Global.game.startSugarRush();
				reset();
			}
		}
		
		public function reset():void
		{
			_amount = 0;
			graphic.visible = false;
		}
		
		public function get amount():Number { return _amount; }
	}
}