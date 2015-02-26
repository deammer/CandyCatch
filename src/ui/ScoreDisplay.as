package ui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class ScoreDisplay extends Entity 
	{
		private var _timer:Number;
		private var _digits:int = 4;
		private var _y:int; // original y coord
		private var _text:Text;
		
		public function ScoreDisplay(x:int, y:int)
		{
			this.x = x;
			this.y = y;
			_y = y;
			
			layer = Config.LAYER_UI;
			_text = new Text("0000");
			_text.font = "CandyFont";
			_text.color = 0x0;
			graphic = _text;
			_timer = NaN;
		}
		
		override public function update():void 
		{
			if (!isNaN(_timer))
			{
				_timer -= FP.elapsed;
				if (_timer <= 0)
					_timer = NaN;
			}
			
			if (y > _y)
				y --;
		}
		
		public function setScore(score:int):void
		{
			_timer = 0.2;
			y = _y + 5;
			
			_text.text = "" + score;
			while (_text.text.length < _digits)
				_text.text = "0" + _text.text;
		}
	}
}