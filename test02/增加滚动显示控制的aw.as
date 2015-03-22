package
{
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.longtailvideo.jwplayer.player.*;
	import com.apexSoft.apexDebug.ApexTrace;
	import flash.external.ExternalInterface;
	
	//import nl.demonsters.debugger.MonsterDebugger;	
	
	public class aw extends Player
	{
		
		public var _userNameText:TextField;
		//刷新速度，默认40是毫秒
		private var logoTimer:Timer = new Timer(40);
		//获取用户名的timer
		private var getUserNameTimer:Timer = new Timer(1000);
		//滚动距离，默认每次滚动1像素
		private var _moveSpeed:int = 1;
		
		public function aw()
		{
			//Apex调试工具初始化
			ApexTrace.init(stage, this, "", "");
			//随机到任何y轴位置
			this.randomPosAnywhere();
			
			//默认用户名
			this._userNameText.text = "GUEST";
			this._userNameText.x = 0;
			this.logoTimer.addEventListener(TimerEvent.TIMER, logoxy_fc);
			this.logoTimer.start();
			
			//通过JS获取用户名
			//this.getUserName();
			this.getUserNameTimer.addEventListener(TimerEvent.TIMER, getUserName);
			this.getUserNameTimer.start();
		}
		
		private function logoxy_fc(e:TimerEvent):void
		{
			this._userNameText.x += this._moveSpeed;
			if (this._userNameText.x > stage.stageWidth)
			{
				//循环滚动
				this._userNameText.x = -this._userNameText.width;
				//随机到任何y轴位置
				this.randomPosAnywhere();
			}
		}
		
		private function randomPosAnywhere():void {
			this._userNameText.y = (this.stage.stageHeight - 50) * Math.random();
		}
		
		private function getUserName(e:TimerEvent):void
		{
			if (ExternalInterface.available)
			{
				var __userName:String = ExternalInterface.call("userName").toString();
				ApexTrace.trace("\---通过JS获取的当前用户名为:" + __userName);
				if (__userName == null || __userName == "undefined") {
					ApexTrace.trace("\---当前用户名称格式有误");
				}else {
					//更新正确用户名
					this._userNameText.text = __userName;
				}
			}
			else
			{
				ApexTrace.trace("\---请部署到服务器环境下测试");
			}
		}
	}
}