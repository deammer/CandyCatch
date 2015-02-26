package ui
{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class TextURL extends Entity
	{
		private var _text:Text;
		private var _highlighted:Boolean = false;
		private var _url:String;
		
		public function TextURL(text:String, x:int = 0, y:int = 0)
		{
			this.x = x;
			this.y = y;
			
			_text = new Text(text);
			_text.color = 0xaaaaaa;
			_text.font = "CandyFont";
			_text.size = 8;
			graphic = _text;
			
			setHitbox(_text.textWidth, _text.textHeight - 4, 0, -2);
		}
		
		override public function update():void 
		{
			if (!_highlighted && collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				_highlighted = true;
				_text.color = 0xffffff;
			}
			else if (_highlighted)
			{
				if (!collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					_highlighted = false;
					_text.color = 0xaaaaaa;
				}
				else if (Input.mouseReleased && _url != null)
					navigateToURL(new URLRequest(_url));
			}
		}
		
		public function set size(size:int):void
		{
			_text.size = size;
			
			width = _text.textWidth;
			height = _text.textHeight;
		}
		public function set url(value:String):void { _url = value; }
	}
}