package com.apexSoft.apexSounder
{
    import flash.events.*;
    import flash.media.*;
    import flash.utils.*;

    public class ApexSound extends Object
    {
        private static var _channel:SoundChannel;
		private static var _sound:*
		private static var _realSound:Sound;
		private static var _SoundLevel:SoundTransform;
		

        public function ApexSound()
        {
            return;
        }// end function
		
		/**
		 * 播放声音
		 * @param	$e 声音文件的类名
		 * @param	$f 播放几遍
		 * @param	$g 声音大小，默认1
		 */
        public static function playSound($e:String, $f:int = 0, $g:Number = 1) : void
        {
			//判定传进来的是否是个声音实例
            _sound = getDefinitionByName($e) as Class;
            if (getDefinitionByName($e) as Class == null)
            {
                return;
            }
            _realSound = new _sound as Sound;
            _SoundLevel = new SoundTransform($g);
			//播放声音
            _channel = _realSound.play(0, $f);
			//声音大小
            _channel.soundTransform = _SoundLevel;
            return;
        }// end function
		
		/**
		 * 静音
		 */
		public static  function muteSound():void {
			_channel.soundTransform = new SoundTransform(0);
		}
		
		/**
		 * 继续
		 */
		public static  function continueSound():void {
			_channel.soundTransform = _SoundLevel;
		}
		
		/**
		 * 停止所有声音
		 */
		public static function stopAllSound():void {
			SoundMixer.stopAll();
		}
    }
}
