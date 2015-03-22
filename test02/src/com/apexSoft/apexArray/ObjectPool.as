package com.apexSoft.apexArray
{
	import flash.utils.Dictionary;
	
	/**
	 * @version 20100315
	 * @author BrightLi
	 */
	public class ObjectPool
	{
		
		private static var _pool:Dictionary = new Dictionary(true);
		
		private var _template:Class;
		
		private var _list:Array;
		
		public function ObjectPool($value:Class)
		{
			_template = $value;
			_list = new Array();
		}
		
		//从对象池中借出
		public function borrowObject():Object
		{
			if (_list.length > 0)
			{
				return _list.shift();
			}
			return new _template();
		}
		
		//用完返回对象池
		public function returnObject($value:Object):void
		{
			_list.push($value);
		}
		
		public static function getPool($value:Class):ObjectPool
		{
			if (!_pool[$value])
			{
				_pool[$value] = new ObjectPool($value);
			}
			return _pool[$value];
		}
	}
}