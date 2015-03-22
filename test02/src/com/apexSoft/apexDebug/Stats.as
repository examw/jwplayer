/**
 * stats.as cpu version 
 * 
 * cpu版本的"概要分析器"，手机不好使，具体原因看pdf概要分析一章
 * https://github.com/mrdoob/Hi-ReS-Stats
 *
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * //Gpu渲染的Starling版本"概要分析器"
 * http://forum.starling-framework.org/topic/starling-port-of-mrdoobs-stats-class
 *
 * How to use:
 *
 *	addChild( new Stats() );
 *
 * 
 * 当前帧频/预期帧频
 * 一帧运行所需时间（毫秒）
 * 当前内存占用
 * 历史最高内存占用
 **/

package com.apexSoft.apexDebug
{
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.system.Capabilities;
	
	public class Stats extends Sprite
	{
		
		protected const WIDTH:uint = 70;
		protected const HEIGHT:uint = 100;
		
		protected var xml:XML;
		
		//文字指示器
		protected var text:TextField;
		protected var style:StyleSheet;
		
		protected var ver:Sprite;
		protected var format:TextFormat;
		protected var verText:TextField;
		
		protected var timer:uint;
		protected var fps:uint;
		protected var ms:uint;
		protected var ms_prev:uint;
		protected var mem:Number;
		protected var mem_max:Number;
		
		//图形指示器
		protected var graph:BitmapData;
		protected var rectangle:Rectangle;
		
		protected var fps_graph:uint;
		protected var mem_graph:uint;
		protected var mem_max_graph:uint;
		
		protected var bg_color:uint = 0x006666;
		protected var fps_color:uint = 0xffff00;
		protected var ms_color:uint = 0x00ff00;
		protected var mem_color:uint = 0xffffff;
		protected var memmax_color:uint = 0x00ffff;
		
		/**
		 * <b>Stats</b> FPS, MS and MEM, all in one.
		 */
		public function Stats():void
		{
			
			mem_max = 0;
			
			xml =    <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>;
			
			style = new StyleSheet();
			style.setStyle('xml', {fontSize: '10px', fontFamily: '_sans', leading: '-2px'});
			style.setStyle('fps', {color: hex2css(fps_color)});
			style.setStyle('ms', {color: hex2css(ms_color)});
			style.setStyle('mem', {color: hex2css(mem_color)});
			style.setStyle('memMax', {color: hex2css(memmax_color)});
			
			text = new TextField();
			text.width = WIDTH;
			text.height = 50;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;
			
			//检测版本
			ver = new Sprite();
			ver.graphics.beginFill(bg_color);
			ver.graphics.drawRect(0, 0, 65, 30);
			ver.graphics.endFill();
			ver.width = WIDTH;
			ver.y = HEIGHT;
			ver.visible = false;
			
			format = new TextFormat("Tahoma", 10);
			verText = new TextField();
			verText.defaultTextFormat = format;
			verText.width = WIDTH;
			verText.selectable = false;
			
			verText.textColor = 0xFFFFFF;
			verText.text = Capabilities.version.split(" ")[0] + "\n" + Capabilities.version.split(" ")[1];
			ver.addChild(verText);
			
			rectangle = new Rectangle(WIDTH - 1, 0, 1, HEIGHT - 50);
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.buttonMode = true;
			
			this.name = "ApexMonitor";
		}
		
		private function init(e:Event):void
		{
			//整体背景
			graphics.beginFill(bg_color);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
			
			//文字指示器
			//text.x = stage.stageWidth - WIDTH;
			addChild(text);
			//添加版本指示器
			//ver.x = stage.stageWidth - WIDTH;
			addChild(ver);
			
			graph = new BitmapData(WIDTH, HEIGHT - 50, false, bg_color);
			graphics.beginBitmapFill(graph, new Matrix(1, 0, 0, 1, 0, 50));
			//图形指示器位置
			graphics.drawRect(0, 50, WIDTH, HEIGHT - 50);
			
			//鼠标点击增加或者减少帧上限
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, update);
			//鼠标查看版本
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function destroy(e:Event):void
		{
			
			graphics.clear();
			
			while (numChildren > 0)
				removeChildAt(0);
			
			graph.dispose();
			
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(Event.ENTER_FRAME, update);
		
		}
		
		private function update(e:Event):void
		{
			
			timer = getTimer();
			
			if (timer - 1000 > ms_prev)
			{
				
				ms_prev = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				mem_max = mem_max > mem ? mem_max : mem;
				
				fps_graph = Math.min(graph.height, (fps / stage.frameRate) * graph.height);
				mem_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
				mem_max_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem_max * 5000))) - 2;
				
				graph.scroll(-1, 0);
				
				graph.fillRect(rectangle, bg_color);
				graph.setPixel(graph.width - 1, graph.height - fps_graph, fps_color);
				graph.setPixel(graph.width - 1, graph.height - ((timer - ms) >> 1), ms_color);
				graph.setPixel(graph.width - 1, graph.height - mem_graph, mem_color);
				graph.setPixel(graph.width - 1, graph.height - mem_max_graph, memmax_color);
				
				xml.fps = "FPS: " + fps + " / " + stage.frameRate;
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + mem_max;
				
				fps = 0;
				
			}
			
			fps++;
			
			xml.ms = "MS: " + (timer - ms);
			ms = timer;
			
			text.htmlText = xml;
		}
		
		private function onClick(e:MouseEvent):void
		{
			//trace(e.localX);
			//点击左半部加速，点击右半部减速
			(WIDTH - e.localX) / WIDTH > .5 ? stage.frameRate-- : stage.frameRate++;
			xml.fps = "FPS: " + fps + " / " + stage.frameRate;
			text.htmlText = xml;
		
		}
		
		// .. Utils
		
		private function hex2css(color:int):String
		{
			
			return "#" + color.toString(16);
		
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			ver.visible = true;
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			ver.visible = false;
		}
	
	}

}