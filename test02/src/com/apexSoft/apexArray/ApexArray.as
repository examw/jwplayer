package com.apexSoft.apexArray
{
	import flash.events.*;
	import flash.media.*;
	import flash.utils.*;
	
	public class ApexArray extends Object
	{
		
		public function ApexArray()
		{
			return;
		} // end function
		
		//取一个删除一个,就不重复了。$lengt：想要的不重复数字个数。$start：截取区间起始值。$end：截取区间结束值
		public static function UnRepeatArray($length:int, $start:int = 0, $end:int = 100):Array
		{
			var a:Array = new Array();
			var b:Array = new Array();
			
			for (var i:int = $start; i <= $end; i++)
			{
				a.push(i);
			}
			//trace("a:" + a);
			
			for (var j:int = 0; j < $length; j++)
			{
				//必须a.length - 1，例如a={0, 1},a.length为2，不 - 1，有可能随到2，a[2]是几？
				var index:int = Math.round(Math.random() * (a.length - 1));
				//b里面添加随机出来的数字
				b.push(a[index]);
				//删除刚才随机出来的数字，这样就不会重复了
				a.splice(index, 1);
			}
			//trace("b:" + b);
			//trace("a剩下的:" + a);
			return b;
		} // end function
		
		//as3 数组随机排序，打乱数组原来顺序
		public static function randomArray(targetArray:Array):Array
		{
			var arrayLength:Number = targetArray.length;
			//先创建一个正常顺序的数组
			var tempA:Array = [];
			for (var i = 0; i < arrayLength; i++)
			{
				tempA[i] = i;
			}
			//再根据上一个数组创建一个随机乱序的数组
			var tempB:Array = [];
			for (var s = 0; s < arrayLength; s++)
			{
				//从正常顺序数组中随机抽出元素
				tempB[s] = tempA.splice(Math.floor(Math.random() * tempA.length), 1);
			}
			//最后创建一个临时数组存储 根据上一个乱序的数组从targetArray中取得数据
			var tempC:Array = [];
			for (var m = 0; m < arrayLength; m++)
			{
				tempC[m] = targetArray[tempB[m]];
			}
			//返回最后得出的数组
			return tempC;
		}
	}
}
