package ui
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class FlashingText extends Entity
	{
		private var _text:Text;
		private var _timer:Number;
		private const PERIOD:Number = 0.4;
		
		public function FlashingText(text:String, x:int = 0, y:int = 0)
		{
			_text = new Text(text);
			_text.font = "CandyFont";
			super(x, y, _text);
			
			_timer = PERIOD;
		}
		
		override public function added():void 
		{
			_text.x = -_text.textWidth * 0.5;
		}
		
		override public function update():void 
		{
			_timer -= FP.elapsed;
			if (_timer <= 0.0)
			{
				_timer = PERIOD;
				_text.visible = !_text.visible;
			}
		}
		
		public function set color(c:uint):void { _text.color = c; }
		public function set size(s:int):void { _text.size = s; }
	}	
}