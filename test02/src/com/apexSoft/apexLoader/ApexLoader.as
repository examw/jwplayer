package com.apexSoft.apexLoader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author ApexWang
	 */
	public class ApexLoader
	{
		//加载时候显示百分比的文本域实例名
		static private var _loadNumTxtTips:Object;
		static private var _stage:Stage;
		static private var _root:Object;
		//加载完毕后执行的主文档类方法
		static private var _loadEnd:Function;
		static private var _bytesLoaded:Number;
		static private var _percentNum:Number
		/**
		 * 
		 * @param	$f 主文档类引用
		 * @param	$g 加载时候显示百分比的文本域实例名
		 * @param	$h 加载完毕后执行的主文档类方法
		 */
		static public function Load($f:Object, $g:Object, $h:Function)
		{
			//_stage = $e as Stage;
			_root = $f as Object;
			_loadNumTxtTips = $g as Object;
			_loadEnd = $h as Function;
			//停止在第一帧，显示加载动画
			_root.gotoAndStop(1);
			
			_root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, handler_loading);
			_root.loaderInfo.addEventListener(Event.COMPLETE, handler_complete);
		}
		
		static private function handler_loading($e:ProgressEvent):void
		{
			_percentNum = $e.bytesLoaded / $e.bytesTotal;
			//加载百分比显示
			_loadNumTxtTips.text = Math.round(_percentNum * 100).toString();
		}
		
		static private function handler_complete($e:Event):void
		{
			_root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, handler_loading);
			//加载完毕进入正式游戏场景
			_root.gotoAndStop(2);
			//主文档类游戏真正开始初始化的方法
			_loadEnd();
		}
	}

}