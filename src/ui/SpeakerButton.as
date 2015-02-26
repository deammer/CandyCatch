package ui
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class SpeakerButton extends Entity
	{
		private var _spritemap:Spritemap;
		
		public function SpeakerButton()
		{
			_spritemap = new Spritemap(Assets.UI_SPEAKER, 14, 11);
			_spritemap.add("full", [2], 0, false).play();
			_spritemap.add("half", [1], 0, false);
			_spritemap.add("off", [0], 0, false);
			_spritemap.color = 0xaaaaaa;
			graphic = _spritemap;
			setHitboxTo(graphic);
		}
		
		override public function added():void 
		{
			if (Global.volume == 0.0)
				_spritemap.play("off");
			else if (Global.volume < 1.0)
				_spritemap.play("half");
		}
		
		override public function update():void 
		{
			if (collidePoint(x, y, Input.mouseX, Input.mouseY) && Input.mousePressed)
			{
				if (_spritemap.currentAnim == "full")
				{
					_spritemap.play("half");
					Global.volume = 0.5;
				}
				else if (_spritemap.currentAnim == "half")
				{
					_spritemap.play("off");
					Global.volume = 0.0;
				}
				else
				{
					_spritemap.play("full");
					Global.volume = 1.0;
				}
			}
		}
	}
}