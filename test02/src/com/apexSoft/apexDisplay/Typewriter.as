package com.apexSoft.apexDisplay
{
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public final class Typewriter
	{
		/* 声明静态变量和方法 */
		
		private static var chars:Array; //字符串中的字符
		private static var tf:TextField; //写入字符串的文本
		private static var timer:Timer; //写入每个字符之间的停顿
		private static var i:int; //起始写入位置
		/**
		 * 打字机效果类 
		 * @param txt 想要输出的文字
		 * @param txtField 输出到的目的文本域
		 * @param time 每个字的输出间隔
		 * @param $clear 是否清空目的文本域
		 * 
		 */	
		public static function write(txt:String, txtField:TextField, time:Number, $clear:Boolean = true):void
		{
			chars = txt.split(""); //将字符串拆分成一个字符数组
			tf = txtField; //将函数中传递进的txtField值赋值给tf
			i = 0; //从第一个字符开始输入
			//是否清空
			$clear == true ? stop() : null;
			
			timer = new Timer(time); //根据参数设置时间
			timer.addEventListener(TimerEvent.TIMER, writeChar);
			timer.start(); //开始 writing 函数
		}
		
		private static function stop():void
		{
			tf.text = "";
			
			if (timer !== null)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, writeChar); //清空timer
				timer = null;
			}
		}
		
		private static function writeChar(e:TimerEvent):void
		{
			if (i < chars.length)
			{
				tf.appendText(chars[i]); //每次该函数调用写入一个字符
				i++; //下一字符
			}
			if (i >= chars.length) //检查字符串是否完成
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, writeChar); //清空timer
				timer = null;
			}
		}
	}
}