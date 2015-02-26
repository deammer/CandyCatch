package levels 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class ParallaxBackground extends Entity 
	{
		public function ParallaxBackground(x:int, y:int, graphic:Image, parallax:Number)
		{
			super(x, y, graphic);
			this.graphic.scrollX = parallax;
			layer = Config.LAYER_BACKGROUND;
		}
	}
}