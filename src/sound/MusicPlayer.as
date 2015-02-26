package sound
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class MusicPlayer 
	{
		private static var _timer:Timer;
		private static var _channel:SoundChannel;
		private static var _transform:SoundTransform;
		private static var _last_pos:Number;
		private static var _sound:Sound;
		
		public static function playMusic(_music:Class):void
		{
			_sound = new _music();
			_timer = new Timer(_sound.length - 83); // remove the silent gap because mp3
			_transform = new SoundTransform(Global.volume);
			_timer.addEventListener(TimerEvent.TIMER, function (e:Event):void { _channel = _sound.play(0, 0, _transform); } );
			_timer.start();
			_channel = _sound.play(0, 0, _transform);
		}
		
		public static function stopMusic():void
		{
			if (_timer != null)
			{
				_timer.stop();
				_channel.stop();
			}
		}
		
		public static function fadeOut():void
		{
			if (_channel == null)	return;
			
			var tween:VarTween = new VarTween(stopMusic);
			tween.tween(_channel.soundTransform, "volume", 0.0, 2.0);
			FP.world.addTween(tween, true);
		}
		
		public static function setVolume(volume:Number):void
		{
			if (_transform != null)
			{
				_transform.volume = volume;
				_channel.soundTransform = _transform;
			}
		}
		
		static public function pause():void 
		{
			if (_channel != null)
			{
				_last_pos = _channel.position;
				_channel.stop();
				_timer.stop();
			}
		}
		
		static public function resume():void
		{
			if (_channel != null)
			{
				_channel = _sound.play(_last_pos, 0, _transform);
				_timer = new Timer(_sound.length - 83 - _last_pos);
				_timer.addEventListener(TimerEvent.TIMER, function (e:Event):void { _timer.delay = _sound.length - 83; _channel = _sound.play(0, 0, _transform); } );
				_timer.start();
			}
		}
	}
}