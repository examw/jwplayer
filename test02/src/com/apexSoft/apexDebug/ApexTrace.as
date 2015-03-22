package com.apexSoft.apexDebug
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.display.Stage;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	public class ApexTrace extends MovieClip
	{
		static private var _txt:TextField = new TextField();
		//状态分析器
		static private var _stats:Stats = new Stats();
		
		static private var stage:Stage;
		static private var _MainDoc:Object;
		static private var _i:int;
		static private var _txtTis:TextField = new TextField();
		
		public function ApexTrace()
		{
			//this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		/**
		 * Apex的Debug类
		 * @param	$e 传入stage
		 * @param	$r 主文档类
		 * @param	$f 右键显示文字
		 * @param	$g 右键显示文字链接
		 */
		
		static public function init($e:Stage, $r:Object, $f:String = "蓝枫工作室", $g:String = "www.apexwang.com"):void
		{
			stage = $e;
			
			creatTxt();
			
			//注意，只有stage.scaleMode属性为"noScale"时候，Event.RESIZE事件才有效，其它三种模式统统无效
			stage.scaleMode = "noScale";
			trace("缩放模式设置为：" + stage.scaleMode);
			//stage.align这个很关键啊！
			stage.align = "LT";
			trace("场景对齐方式设置为：" + stage.align);
			//是否为debug版本
			trace("Flash播放器是否为Debug版本：" + Capabilities.isDebugger);
			
			//自定义右键
			stage.showDefaultContextMenu = false;
			rightClick($r, $f, $g);
			
			//快捷键开关侦听
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyUpHandler);
			function keyUpHandler(event:KeyboardEvent):void
			{
				if (event.keyCode == 65 && event.ctrlKey && event.shiftKey && event.altKey)
				{
					//trace("您按下了Ctrl+Shift+Alt+A键");
					_txt.visible ? _txt.visible = false : _txt.visible = true;
					_stats.visible ? _stats.visible = false : _stats.visible = true;
				}
				//trace(event.keyCode);
				if (event.keyCode == 90 && event.ctrlKey && event.shiftKey && event.altKey)
				{
					//trace("您按下了Ctrl+Shift+Alt+Z键");
					_stats.visible ? _stats.visible = false : _stats.visible = true;
				}
				//重新布局状态指示器的位置
				statsPos();
			}
			
			//更改FLASH显示尺寸时的侦听
			stage.addEventListener(Event.RESIZE, handler_onResize);
			function handler_onResize($e:Event):void
			{
				_i++;
				txtShowArea(stage.stageWidth, stage.stageHeight, _i);
				statsPos();
			}
			
			//状态指示器靠右对齐
			function statsPos():void {
				_stats.x = stage.stageWidth - _stats.width;
				_stats.y = 5;
			}
		}
		
		static private function creatTxt():void
		{
			_txt.name = "ApexTraceShowLayer";
			_txt.alpha = .9;
			
			_txt.border = true;
			_txt.borderColor = 0xffffff;
			
			_txt.background = true;
			_txt.backgroundColor = 0x000000;
			
			_txt.textColor = 0x00ff00;
			_txt.text = "以下是ApexDebuger显示出的内容:\n";
			
			txtShowArea(stage.stageWidth, stage.stageHeight, _i);
			
			_txt.visible = false;
			
			_stats.visible = false;
			
			stage.addChild(_txt);
			//添加状态分析器
			stage.addChild(_stats);
		}
		
		/**
		 * 
		 * @param	$e 想要输出显示到ApexDebug中的信息
		 */
		static public function trace($e:*):void
		{
			$e == null ? $e = "null" : null;
			_txt.appendText($e.toString() + "\n");
		}
		
		static private function txtShowArea($e:Number, $f:Number, $g:int):void
		{
			_txt.width = $e - 1;
			_txt.height = $f - 1;
			
			$g > 0 ? _txtTis.text = "本swf现在显示的尺寸是：" : _txtTis.text = "本swf场景默认的尺寸是：";
			
			trace(_txtTis.text + $e + "×" + $f);
		}
		
		static private function rightClick($r:Object, $e:String, $f:String):void
		{
			_MainDoc = $r;
			//定义了一个ContextMenu类型的对象，这个对象将用来对菜单的操作
			var myContextMenu:ContextMenu = new ContextMenu();
			//声明菜单新项，显示名为“XX网”
			var item:ContextMenuItem = new ContextMenuItem($e);
			
			//添加到菜单显示项目数组(定义这个菜单项的响应事件)
			myContextMenu.customItems.push(item);
			//替代系统的默认菜单
			_MainDoc.contextMenu = myContextMenu;
			
			//添加菜单事件侦听
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, apex);
			function apex(event:ContextMenuEvent):void
			{
				var URLadd:URLRequest = new URLRequest("http://" + $f);
				navigateToURL(URLadd, "_blank");
			}
		}
	
	}
}