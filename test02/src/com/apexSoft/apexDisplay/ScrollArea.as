package com.apexSoft.apexDisplay
{
	import flash.events.*;
	import flash.utils.Timer;
	import flash.geom.Rectangle;

	public class ScrollArea
	{
		private var r:Object;
		private var s:Object;
		public function ScrollArea(_r,_s)
		{
			trace(_r);
			trace(_s);

			//maskArea.visible = false;
		}
		public static function init(_r,_s)
		{
			/*var r:Object = new Object();
			var s:Object  = new Object();
			trace(r = _r);
			trace(s = _s);*/
			//_r.maskArea.visible = false;

			//拉杆位置根据_r.questionArea位置自动判定；
			/*_r.drag_btn.addEventListener(Event.ENTER_FRAME,posCheck);
			function posCheck(e:Event):void{
			_r.drag_btn.y = (_r.drag_stick.y+_r.upBtn.height)-(_r.drag_stick.height-_r.drag_btn.height-_r.downBtn.height-_r.upBtn.height)/(_r.questionArea.height - _r.maskArea.height)*(_r.questionArea.y-_r.maskArea.y);
			}*/
			_r.drag_btn.y =_r.drag_stick.y + _r.upBtn.height;
			_r.drag_btn.buttonMode = true;
			//拉杆拖拽判定-----------------------------------------------
			_r.drag_btn.addEventListener(MouseEvent.MOUSE_DOWN,drag_fc);


			var moveTimer:Timer = new Timer(40);
			moveTimer.addEventListener(TimerEvent.TIMER,tween_fc);


			//滚轮判定------------------------------------------------------;
			_r.questionArea.addEventListener(MouseEvent.MOUSE_WHEEL,wheel_fc);


			//上下小箭头判定---------------------------------------;
			_r.upBtn.addEventListener(MouseEvent.MOUSE_UP,up_fc);
			_r.downBtn.addEventListener(MouseEvent.MOUSE_UP,down_fc);

			function drag_fc(e:MouseEvent):void
			{
				moveTimer.start();
				e.target.startDrag(false,new Rectangle(_r.drag_btn.x,_r.drag_stick.y+_r.upBtn.height,0,_r.drag_stick.height-_r.drag_btn.height-_r.downBtn.height-_r.upBtn.height));
				e.target.stage.addEventListener(MouseEvent.MOUSE_UP,onRelease_onReleaseOutside);
				trace("onPress");
				trace(_r.drag_btn.x);
			}
			function onRelease_onReleaseOutside(e:MouseEvent)
			{
				e.target.stage.removeEventListener(MouseEvent.MOUSE_UP,onRelease_onReleaseOutside);
				_r.drag_btn.stopDrag();
				e.target == _r.drag_btn?trace("onRelease"+e.target):trace("onReleaseOutside"+e.target);
				moveTimer.stop();
			}
			function tween_fc(e:TimerEvent):void
			{
				_r.questionArea.y = _r.maskArea.y-(_r.drag_btn.y-_r.drag_stick.y-_r.upBtn.height)*(_r.questionArea.height - _r.maskArea.height)/(_r.drag_stick.height-_r.drag_btn.height-_r.downBtn.height-_r.upBtn.height);
				//移动区域.y = 遮罩区域.y - 托杆已拖动区域像素*(移动区域应该剩余显示长度/托杆剩余长度);
			}
			function wheel_fc(e:MouseEvent):void
			{
				//向下滚动
				if (e.delta < 0)
				{
					_r.questionArea.y + _r.questionArea.height > _r.maskArea.y + _r.maskArea.height ? e.currentTarget.y -=  _r.questionArea.height * 0.1:null;//每次向下滚动可视区域的10%长度；
					_r.questionArea.y + _r.questionArea.height < _r.maskArea.y + _r.maskArea.height ? e.currentTarget.y = _r.maskArea.y - (_r.questionArea.height-_r.maskArea.height) : null;//向下滚动超了，就回来；
					_r.drag_btn.y = (_r.drag_stick.y+_r.upBtn.height)-(_r.drag_stick.height-_r.drag_btn.height-_r.downBtn.height-_r.upBtn.height)/(_r.questionArea.height - _r.maskArea.height)*(_r.questionArea.y-_r.maskArea.y);
				}
				//向上滚动
				if (e.delta > 0)
				{
					_r.questionArea.y < _r.maskArea.y ? e.currentTarget.y +=  _r.questionArea.height * 0.1:null;//每次向上滚动可视区域的10%长度；
					_r.questionArea.y > _r.maskArea.y ? e.currentTarget.y = _r.maskArea.y:null;
					_r.drag_btn.y = (_r.drag_stick.y+_r.drag_stick.height)-(_r.downBtn.height+_r.drag_btn.height)-(_r.drag_stick.height-_r.drag_btn.height-_r.downBtn.height-_r.upBtn.height)/(_r.questionArea.height - _r.maskArea.height)*(_r.questionArea.y+_r.questionArea.height-(_r.maskArea.y+_r.maskArea.height));
				}
				//trace("wheel");
			}
			function up_fc(e:MouseEvent):void
			{
				_r.questionArea.y < _r.maskArea.y ? _r.questionArea.y +=  _r.questionArea.height * 0.1:null;//每次向上滚动可视区域的10%长度；
				_r.questionArea.y > _r.maskArea.y ? _r.questionArea.y = _r.maskArea.y:null;
				_r.drag_btn.y = (_r.drag_stick.y+_r.drag_stick.height)-(_r.downBtn.height+_r.drag_btn.height)-(_r.drag_stick.height-_r.drag_btn.height-_r.downBtn.height-_r.upBtn.height)/(_r.questionArea.height - _r.maskArea.height)*(_r.questionArea.y+_r.questionArea.height-(_r.maskArea.y+_r.maskArea.height));
			}
			function down_fc(e:MouseEvent):void
			{
				_r.questionArea.y + _r.questionArea.height > _r.maskArea.y + _r.maskArea.height ? _r.questionArea.y -=  _r.questionArea.height * 0.1:null;//每次向下滚动可视区域的10%长度；
				_r.questionArea.y + _r.questionArea.height < _r.maskArea.y + _r.maskArea.height ? _r.questionArea.y = _r.maskArea.y - (_r.questionArea.height-_r.maskArea.height) : null;//向下滚动超了，就回来；
				_r.drag_btn.y = (_r.drag_stick.y+_r.upBtn.height)-(_r.drag_stick.height-_r.drag_btn.height-_r.downBtn.height-_r.upBtn.height)/(_r.questionArea.height - _r.maskArea.height)*(_r.questionArea.y-_r.maskArea.y);
			}
		}

	}
}