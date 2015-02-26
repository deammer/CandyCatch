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
	public class FatDisplay extends Entity
	{
		public function FatDisplay(x:int, y:int)
		{
			super(x, y);
			
			layer = Config.LAYER_UI;
		}
		
		public function setLevel(level:int):void
		{
			level = FP.clamp(level, 0, 3);
			graphic = new Image(Assets.FAT_BARS, new Rectangle(0, 0, level * 10, 13));
		}
	}
}