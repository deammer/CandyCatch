package effects 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class ScorePopup extends Entity
	{
		private var _image:Image;
		private var _source:BitmapData;
		
		private var _timer:Number;
		
		public function ScorePopup()
		{
			_source = FP.getBitmap(Assets.UI_FONT);
		}
		
		public function create(x:int, y:int, score:int):ScorePopup
		{	
			setGraphic(score);
			
			this.x = x - _image.width * 0.5;
			this.y = y - _image.height * 0.5;
			
			_timer = 1.5;
			return this;
		}
		
		override public function update():void 
		{
			y -= 10 * FP.elapsed;
			_timer -= FP.elapsed;
			if (_timer <= 0)
				world.recycle(this);
		}
		
		private function setGraphic(score:int):void
		{
			var s:String = String(score);
			trace("s = " + s);
			var bmd:BitmapData = new BitmapData(8 * s.length, 8, true, 0x0);
			var rect:Rectangle = new Rectangle(0, 0, 8, 8);
			var destination:Point = new Point();
			
			for (var i:int = 0; i < s.length; i++)
			{
				rect.x = int(s.charAt(i)) * 8;
				destination.x = i * 8;
				bmd.copyPixels(_source, rect, destination);
			}
			
			_image = new Image(bmd);
			graphic = _image;
		}
	}
}