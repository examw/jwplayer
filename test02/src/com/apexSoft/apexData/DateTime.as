package com.apexSoft.apexData
{
	
	public class DateTime
	{
		
		static private var _date:Date;
		static private var _year:String;
		static private var _month:String;
		static private var _day:String;
		//当前时间
		static private var _curTime:int;
		//限定的时间
		static private var _limitTimer:int;
		
		public function DateTime()
		{
			return;
		}
		
		/**
		 * 输入一个精确到天的日期，例如20130918，判定当前本地时间是否超期。
		 * @param	$e 想对比的时间，精确到天的日期，例如20130918,返回值为布尔值，本地时间大于等于输入时间为true，否则为false
		 * @return  返回值为布尔值，大于本地时间等于为true，否则为false
		 */
		static public function check_localTime($e:int):Boolean
		{
			_limitTimer = $e;
			
			_date = new Date();
			
			_year = _date.fullYear.toString();
			//月日补零处理
			_month = (int(_date.month) + 1).toString();
			_month.toString().length == 1 ? _month = "0" + _month.toString() : _month = _month.toString();
			_date.date.toString().length == 1 ? _day = "0" + _date.date.toString() : _day = _date.date.toString();
			
			_curTime = int(_year + _month + _day);
			
			//是否过期判定
			return handler_useLimit(_curTime);
		}
		
		//是否过期判定
		static private function handler_useLimit($e:int):Boolean
		{
			var __result:Boolean;
			if ($e >= _limitTimer)
			{
				__result = true;
				
			}
			else if ($e < _limitTimer)
			{
				__result = false;
			}
			
			return __result;
		}
	}
}
