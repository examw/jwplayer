package com.apexSoft.apexEvent
{
	import flash.events.Event;
	import com.apexSoft.apexDebug.ApexTrace;
	
	/**
	 * ...
	 * @author Apex
	 *自定义事件可以传参，这是系统事件不具备的
	 */
	public class ApexEvent extends Event
	{
		public static const JSON_RECEIVED:String = "json_received";
		public static const OPEN_LOTTERY:String = "open_lottery";
		public static const LOTTERY_RECEIVED:String = "lottery_received";
		public static const CALC:String = "clac";
		public static const AVATAR_CLICK:String = "avatar_click";
		public static const PLAY_START:String = "play_start";
		public static const PLAY_AGAIN:String = "play_again";
		public static const GAME_OVER:String = "game_over";
		public static const SHOW_ICON:String = "show_icon";
		public static const COMPLETE:String = "complete";
		
		private var _JsonArr:Object = new Object();
		
		private var _curAvatarObj:Object;
		
		public function ApexEvent($type:String):void
		{
			super($type);
		}
		
		/*返回一个新的 Event 对象，它是 Event 对象的原始实例的副本。
		   通常您不需要调用 clone()；当您重新调度事件，即调用 dispatchEvent(event)（从正在处理 event 的处理函数）时，EventDispatcher 类会自动调用它。
		   新的 Event 对象包括原始对象的所有属性。
		
		   当您创建自己的自定义 Event 类时，必须覆盖继承的 Event.clone() 方法，
		   以复制自定义类的属性。
		   如果您未设置在事件子类中添加的所有属性，
		 则当侦听器处理重新调度的事件时，这些属性将不会有正确的值。*/
		//apex测试必须这么做，多次派发同一自定义事件，系统默认会调用clone()方法，如果不重写，第二次调用自定义事件时，就是Event了。会报错，见资料“自定义事件”
		override public function clone():Event
		{
			var _JSON_RECEIVED:ApexEvent = new ApexEvent(JSON_RECEIVED);
			//还必须附带上当前新_JsonArr属性，这不就是new一个了？难道就是为了便于阅读管理？
			_JSON_RECEIVED._JsonArr = _JsonArr;
			return _JSON_RECEIVED;
		}
		
		//重写新属性
		//另外2个比较重要的方法就是formatToString和toString方法，这2个方法都和我们的事件参数息息相关，没有它们我们就无法读取我们像事件中添加的参数。
		override public function toString():String
		{
			return formatToString("ApexEvent", "type", "bubbles", "cancelable", "eventPhase", "JsonArr");
		}
		
		//设置jsonArr
		public function set JsonArr($e:Object):void
		{
			_JsonArr = $e;
		}
		
		public function get JsonArr():Object
		{
			return _JsonArr;
		}
		
		//设置被点击当前头像对象
		public function set curAvatarObj($e:Object):void
		{
			_curAvatarObj = $e;
		}
		
		public function get curAvatarObj():Object
		{
			return _curAvatarObj;
		}
	}
}