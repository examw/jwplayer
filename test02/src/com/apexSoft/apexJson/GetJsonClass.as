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
	
	public class GetJsonClass
	{
		private var _urlLoader:URLLoader = new URLLoader();
		private var _resultObj:Object = new Object();
		private var _jsonReceived:ApexEvent = new ApexEvent("json_received");
		private var _obj:Object = new Object();
		private var _varRandomNum:String;
		private var _url:String;
		
		public function GetJsonClass()
		{
			return;
		}
		
		/**
		 *
		 * @param	$d 派发ApexEvent.JSON_RECEIVED事件的对象
		 * @param	$e 请求的地址
		 * @param	$f 是否需要添加随机参数，默认false，不添加，可通过GlobalData._URLvarSwitch进行全局调控
		 */
		public function handle($d:Object, $e:String = "json.php", $f:Boolean = false):void
		{
			_obj = $d as Object;
			
			$f ? _varRandomNum = "&var=" + int(Math.random() * 10000) : _varRandomNum = "";
			ApexTrace.trace("\n/--------url随机数：" + _varRandomNum);
			
			//加随机数，防止请求数据时读取本地缓存
			_url = $e + _varRandomNum;
			ApexTrace.trace("本次URL请求：" + _url);
			_urlLoader.load(new URLRequest(_url));
			_urlLoader.addEventListener(Event.COMPLETE, handler_decodeJSON);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handler_IOError);
		}
		
		private function handler_decodeJSON($e:Event):void
		{
			ApexTrace.trace("本次JSON请求已经从服务端返回：" + $e.target.data);
			//因为返回的$e.target.data都是string类型，但不是[或者{包裹的字符串JSON类无法解析
			//ApexTrace.trace(com.adobe.serialization.json.JSON.decode($e.target.data.toString()));
			if ($e.target.data.charAt(0) == "[" || $e.target.data.charAt(0) == "{") {
				//只有返回数据是数组或者对象格式的时候才做JSON解析
				_resultObj = com.adobe.serialization.json.JSON.decode($e.target.data.toString()) as Object;
			}else {
				_resultObj = $e.target.data as Object;
			}
			
			ApexTrace.trace("本次JSON值已解码：" + _resultObj);
			
			//因为这是个静态类，所以_jsonReceived会被多次调用，所以在ApexEvent.as里面必须重写event的clone()方法
			//否则这样也行：
			//_jsonReceived = new ApexEvent("json_received");
			//但是这样是否会增加开销？和clone有啥区别？仅仅是为了便于阅读不用四处调用？
			
			_jsonReceived.JsonArr = _resultObj;
			
			_obj.dispatchEvent(_jsonReceived);
		}
		
		private function handler_IOError($e:IOErrorEvent):void
		{
			//输出读取时错误信息
			ApexTrace.trace($e.text);
		}
	}

}