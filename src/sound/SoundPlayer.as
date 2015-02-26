package sound
{
	import adobe.utils.CustomActions;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.sound.SfxFader;
	/**
	 * ...
	 * @author Maxime Preaux
	 */
	public class SoundPlayer
	{
		private static var tracks:Vector.<Sfx> = new Vector.<Sfx>(3);
		private static var ambient_queued:Sfx;
		private static var ambient_queued_loop:Boolean;
		private static var fader:Vector.<SfxFader> = new Vector.<SfxFader>(3);
		
		/**
		 * Play a sound effect.
		 * @param	sound	The sound to play
		 * @param	volume	Volume (from 0 to 1)
		 * @param	pan		Panning (from -1 to 1)
		 */
		public static function playSound(sound:Class, volume:Number = 1.0, pan:Number = 0):void
		{
			tracks[0] = new Sfx(sound);
			tracks[0].play(volume * Global.volume, pan);
		}
		/**
		 * Play a piece of music.
		 * @param	sound	The sound to play
		 * @param	loop	Set to true to loop the music forever
		 * @param	volume	Volume (from 0 to 1)
		 */
		public static function playMusic(music:Class, loop:Boolean = false, volume:Number = 1.0):void
		{
			tracks[1] = new Sfx(music);
			if (loop) tracks[1].loop(volume * Global.volume);
			else tracks[1].play(volume * Global.volume);
			
			if (fader[1] != null && fader[1].active)
				FP.world.removeTween(fader[1]);
		}
		/**
		 * Play an ambient track.
		 * @param	sound	The sound to play
		 * @param	loop	Set to true to loop the music forever
		 * @param	volume	Volume (from 0 to 1)
		 */
		public static function playAmbient(track:Class, loop:Boolean = false, volume:Number = 0.3):void
		{
			if (tracks[2].playing)
			{
				fader[2] = new SfxFader(tracks[2], playNextAmbient, Tween.ONESHOT);
				fader[2].fadeTo(0.0, 5.0);
				FP.world.addTween(fader[2]);
				
				ambient_queued = new Sfx(track);
				ambient_queued.volume = volume * Global.volume;
				ambient_queued_loop = loop;
			}
			else
			{
				tracks[2] = new Sfx(track);
				if (loop) tracks[2].loop(volume * Global.volume);
				else tracks[2].play(volume * Global.volume);
			}
		}
		public static function fadeMusicOut():void
		{
			if (tracks[1] != null)
			{
				fader[1] = new SfxFader(tracks[1])
				fader[1].fadeTo(0.0, 0.5);
				FP.world.addTween(fader[1], true);
			}
		}
		public static function get musicPlaying():Boolean
		{
			if (tracks[1] == null)
				return false;
			else
				return tracks[1].playing;
		}
		private static function playNextAmbient():void
		{
			if (ambient_queued_loop)
				ambient_queued.loop(ambient_queued.volume * Global.volume);
			else
				ambient_queued.play(ambient_queued.volume * Global.volume);
			
			fader[2] = null;
		}
	}
	
}