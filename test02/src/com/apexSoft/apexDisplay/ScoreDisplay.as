package com.apexSoft.apexDisplay
{
	import fl.transitions.Tween;
	import fl.transitions.easing.*;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.*;

	public class ScoreDisplay extends Sprite
	{
		//显示分数的时长，秒
		private static const TRANSITION_LENGTH:uint = 3;

		//the score which is being shown, whilst it is increasing
		public var currentScore:uint;

		public var startScore:uint;

		//the player's score
		private var endScore:uint;

		//the text field which will show currentScore
		private var currentScoreField:TextField;

		//this will tween the current score's value
		private var currentScoreTween:Tween;

		public function ScoreDisplay()
		{
			addEventListener(Event.ENTER_FRAME, showScore, false, 0, true);
			createScoreField();
		}

		//if the developer won't link this class to a symbol, this method must be called
		public function createScoreField():void
		{
			currentScoreField = new TextField();
			//启用高级消除锯齿功能
			currentScoreField.antiAliasType = AntiAliasType.ADVANCED;
			
			var format:TextFormat = new TextFormat();
			format.font = "Impact";
			format.size = 32;
			format.color = 0xFF0000;
			currentScoreField.defaultTextFormat = format;

			addChild(currentScoreField);
		}

		public function setScore(_value:uint):void
		{
			endScore = _value;

			tweenCurrentScore();
		}

		public function changeScore(_change:uint):void
		{
			endScore = _change;

			tweenCurrentScore();
		}

		private function showScore(event:Event):void
		{
			//不停的刷新,计算是否应该加逗号
			currentScoreField.text = addCommas(currentScore);
		}

		private function tweenCurrentScore():void
		{
			//缓动当前的currentScore属性，在3秒之内让currentScore属性的值从……例如0添加到2000，这样3秒钟之内showScore方法会不停的现实当前currentScore是否应该添加逗号
			currentScoreTween = new Tween(this,"currentScore",None.easeNone,startScore,endScore,TRANSITION_LENGTH,true);
		}

		private function addCommas(_score:uint):String
		{
			//a string, which will have the score with commas
			var scoreString:String = new String();

			//the amount of characters our score (without commas) has
			var scoreLength:uint = _score.toString().length;
			scoreString = "";

			//add the commas to the string
			for (var i:uint=0; i<scoreLength; i++)
			{
				if ((scoreLength-i)%3 == 0 && i != 0)
				{
					scoreString +=  ",";
				}
				scoreString +=  _score.toString().charAt(i);
			}

			return scoreString;
		}
	}
}