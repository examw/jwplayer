package com.longtailvideo.jwplayer.view {

	import com.longtailvideo.jwplayer.events.GlobalEventDispatcher;
	import com.longtailvideo.jwplayer.events.ViewEvent;
	import com.longtailvideo.jwplayer.player.IPlayer;
	import com.longtailvideo.jwplayer.utils.Configger;
	import com.longtailvideo.jwplayer.utils.Logger;
	import com.longtailvideo.jwplayer.utils.Stretcher;
	
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * Implement a rightclick menu with "fullscreen", "stretching" and "about" options.
	 **/
	public class RightclickMenu extends GlobalEventDispatcher {

		/** Player API. **/
		protected var _player:IPlayer;
		/** Context menu **/
		protected var context:ContextMenu;

		/** About JW Player menu item **/
		protected var about:ContextMenuItem;
		/** Debug menu item **/
		protected var debug:ContextMenuItem;
		/** Fullscreen menu item **/
		protected var fullscreen:ContextMenuItem;
		/** Stretching menu item **/
		protected var stretching:ContextMenuItem;
	
		/** Constructor. **/
		public function RightclickMenu(player:IPlayer, clip:MovieClip) {
			_player = player;
			context = new ContextMenu();
			context.hideBuiltInItems();
			clip.contextMenu = context;
			initializeMenu();
		}

		/** Add an item to the contextmenu. **/
		protected function addItem(itm:ContextMenuItem, fcn:Function):void {
			itm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fcn);
			itm.separatorBefore = true;
			context.customItems.push(itm);
		}

		/** Initialize the rightclick menu. **/
		public function initializeMenu():void {
			setAboutText();
			addItem(about, aboutHandler);
			//addItem(new ContextMenuItem('这里可以增加任何描述例如客服QQ'), qqHandler)
			try {
				fullscreen = new ContextMenuItem('全屏切换');
				addItem(fullscreen, fullscreenHandler);
			} catch (err:Error) {
			}
			stretching = new ContextMenuItem('视频模式切换（双倍大小）...');
			//stretching = new ContextMenuItem('Stretching is ' + _player.config.stretching + '...');
			addItem(stretching, stretchHandler);
			if (Capabilities.isDebugger == true || _player.config.debug != Logger.NONE) {
				debug = new ContextMenuItem('Logging to ' + _player.config.debug + '...');
				//addItem(debug, debugHandler);//此行注释可屏蔽debug模式
			}
		}
		
		protected function setAboutText():void {
			//修改版权描述
			//about = new ContextMenuItem('xx教育网');
			about = new ContextMenuItem('Player for EXAMW ' + _player.version + '...');
		}

		/** jump to the about page. **/
		protected function aboutHandler(evt:ContextMenuEvent):void {
			//修改版权链接
			navigateToURL(new URLRequest('http://www.examw.com'), '_blank');
			//navigateToURL(new URLRequest('http://item.taobao.com/item.htm?id=8123943203'), '_blank');
		}
		
		/** qq支持 **/
		protected function qqHandler(evt:ContextMenuEvent):void {
			return;
		}

		/** change the debug system. **/
		protected function debugHandler(evt:ContextMenuEvent):void {
			var arr:Array = new Array(Logger.NONE, Logger.ARTHROPOD, Logger.CONSOLE, Logger.TRACE);
			var idx:Number = arr.indexOf(_player.config.debug);
			idx = (idx == arr.length - 1) ? 0 : idx + 1;
			debug.caption = 'Logging to ' + arr[idx] + '...';
			setCookie('debug', arr[idx]);
			_player.config.debug = arr[idx];
		}

		/** Toggle the fullscreen mode. **/
		public function fullscreenHandler(evt:ContextMenuEvent = null):void {
			trace(this);
			dispatchEvent(new ViewEvent(ViewEvent.JWPLAYER_VIEW_FULLSCREEN, !_player.config.fullscreen));
		}

		/** Change the stretchmode. **/
		protected function stretchHandler(evt:ContextMenuEvent):void {
			var arr:Array = new Array(Stretcher.UNIFORM, Stretcher.FILL, Stretcher.EXACTFIT, Stretcher.NONE);
			var arrChina:Array = new Array("双倍大小","适应屏幕","原始尺寸","等比缩放");
			var idx:Number = arr.indexOf(_player.config.stretching);
			idx == arr.length - 1 ? idx = 0 : idx++;
			_player.config.stretching = arr[idx];
			stretching.caption = '视频模式切换（' + arrChina[idx] + '）...';//apex改
			//stretching.caption = 'Stretching is ' + arr[idx] + '...';
			dispatchEvent(new ViewEvent(ViewEvent.JWPLAYER_VIEW_REDRAW));
		}
		
		protected function setCookie(name:String, value:*):void {
			Configger.saveCookie(name, value);			
		}

	}

}