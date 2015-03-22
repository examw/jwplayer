package com.apexSoft.apexJson
{
	/**
	 * ...
	 * @author ApexWang
	 */
	
	import com.adobe.serialization.json.JSON;
	import flash.errors.IOError;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.apexSoft.apexEvent.ApexEvent;
	import com.apexSoft.apexDebug.ApexTrace;
	
	public class GetJson
	{
		private static var _urlLoader:URLLoader = new URLLoader();
		private static var _resultObj:Object = new Object();
		private static var _jsonReceived:ApexEvent = new ApexEvent("json_received");
		private static var _obj:Object = new Object();
		private static var _varRandomNum:String;
		private static var _url:String;
		
		public function GetJson()
		{
			return;
		}
		
		/**
		 *
		 * @param	$d 派发ApexEvent.JSON_RECEIVED事件的对象
		 * @param	$e 请求的地址
		 * @param	$f 是否需要添加随机参数，默认true，添加，可通过GlobalData._URLvarSwitch进行全局调控
		 */
		public static function handle($d:Object, $e:String = "json.php", $f:Boolean = true):void
		{
			_obj = $d as Object;
			
			$f ? _varRandomNum = "&var=" + int(Math.random() * 10000) : _varRandomNum = "";
			ApexTrace.trace("url随机数：" + _varRandomNum);
			
			//加随机数，防止请求数据时读取本地缓存
			_url = $e + _varRandomNum;
			ApexTrace.trace("本次URL请求：" + _url);
			_urlLoader.load(new URLRequest(_url));
			_urlLoader.addEventListener(Event.COMPLETE, handler_decodeJSON);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handler_IOError);
		}
		
		private static function handler_decodeJSON($e:Event):void
		{
			_resultObj = com.adobe.serialization.json.JSON.decode($e.target.data as String) as Object;
			
			//因为这是个静态类，所以_jsonReceived会被多次调用，所以在ApexEvent.as里面必须重写event的clone()方法
			//否则这样也行：
			//_jsonReceived = new ApexEvent("json_received");
			//但是这样是否会增加开销？和clone有啥区别？仅仅是为了便于阅读不用四处调用？
			
			_jsonReceived.JsonArr = _resultObj;
			
			_obj.dispatchEvent(_jsonReceived);
		}
		
		private static function handler_IOError($e:IOErrorEvent):void
		{
			//输出读取时错误信息
			ApexTrace.trace($e.text);
		}
	}

}