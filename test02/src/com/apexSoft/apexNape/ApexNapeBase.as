package com.apexSoft.apexNape
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.util.ShapeDebug;
	
	public class ApexNapeBase extends Sprite
	{
		
		//设定空间重力向量，0代表x轴，横向是否有引力，500是y轴，垂直是否有引力
		protected var _gravity:Vec2 = new Vec2(0, 500);
		//声明一个Nape空间
		protected var _space:Space = new Space(_gravity);
		/*声明一个Nape模拟调试试图，空间和刚体创建好后，舞台上仍然是什么都看不见的，
		 * 因为刚体并不是可视对象。这时候我们需要创建一个ShapeDebug对象，
		 * 这个ShapeDebug对象会遍历所有的刚体，并通过Flash绘图API把它们绘制到一个DisplayObject上，
		 * 然后通过ShapeDebug.display获取这个DisplayObject，并添加到舞台上，即可看见所有的刚体对象。
		 * ShapeDebug的构造函数中有三个参数，前两个表示DisplayObject的宽和高，第三个是刚体绘制的颜色，可以保存默认不变。*/
		protected var _debug:ShapeDebug = new ShapeDebug(0, 0);
		
		protected var _isCtrlDown:Boolean;
		protected var _isShiftDown:Boolean;
		
		protected var mouseJoint:PivotJoint;
		
		public function ApexNapeBase()
		{
			//1.将_debug添加到显示列表
			this.addChild(this._debug.display);
			//2.添加事件
			this.setEvents();
		}
		
		//添加事件侦听
		protected function setEvents():void
		{
			//侦听帧更新事件
			stage.addEventListener(Event.ENTER_FRAME, showNape);
			//add listener to MouseEvent,like mouseDown or MouseUp
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHanlder);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseEventHanlder);
			//侦听键盘事件
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyBoardEventHanlder);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyBoardEventHanlder);
		}
		
		protected function keyBoardEventHanlder(event:KeyboardEvent):void
		{
			//键盘事件处理函数
			//在键盘按下时，记录Ctrl和Shift键的状态
			this._isCtrlDown = event.ctrlKey;
			this._isShiftDown = event.shiftKey;
		}
		
		protected function mouseEventHanlder(event:MouseEvent):void
		{
			//鼠标事件处理函数
		}
		
		protected function showNape(event:Event):void
		{
			//更新Nape世界
			//空间模拟频率，每秒模拟60次，即60帧
			this._space.step(1 / 60);
			
			//清除视图
			this._debug.clear();
			//绘制空间，相当于加入将空间加入显示列表
			this._debug.draw(this._space);
			//优化显示视图
			this._debug.flush();
			
			//实时更新贴图
			//1.通过Nape世界的space.liveBodies获取存储所有的活动刚体一个BodyList对象。只获取活动刚体的引用，这样可以减少耗损
			for (var i:int = 0; i < this._space.liveBodies.length; i++)
			{
				//2.通过liveBodies.at(index)方法获取每个活动刚体的引用
				var body:Body = this._space.liveBodies.at(i);
				//如果没有贴图，就不用更新刚体的贴图属性了
				if (body.userData.graphic != null)
				{
					var graphic:Sprite = body.userData.graphic;
					//3.用刚体的坐标和角度更新贴图的属性，实时更新贴图
					graphic.x = body.position.x;
					graphic.y = body.position.y;
					graphic.rotation = (body.rotation * 180 / Math.PI) % 360;
				}
			}
		}
		
		/**
		 * 创建矩形刚体
		 * @param	posX
		 * @param	posY
		 * @param	w
		 * @param	h
		 * @param	type
		 * @param	$texture 贴图内容，可以是任意可视对象因为继承自Object
		 */
		protected function createBox(posX:Number, posY:Number, w:Number, h:Number, type:BodyType, $texture:Object = null):Body
		{
			var box:Body = new Body(type, new Vec2(posX, posY));
			var boxShape:Polygon = new Polygon(Polygon.box(w, h), Material.glass());
			box.shapes.push(boxShape);
			box.space = this._space;
			//给矩形刚体贴图
			box.userData.graphic = $texture;
			trace("贴图:" + $texture);
			
			return box;
		}
		
		//创建指定边数的规则多边形刚体
		protected function createRegular(posX:Number, posY:Number, r:Number, rotation:Number, edgeCount:int, type:BodyType):void
		{
			var regular:Body = new Body(type, new Vec2(posX, posY));
			//通过Polygon预定义的regular方法绘制规则的边数位edgeCount的多边形刚体
			var regularShape:Polygon = new Polygon(Polygon.regular(r * 2, r * 2, edgeCount), Material.glass());
			regularShape.rotate(rotation);
			regular.shapes.push(regularShape);
			regular.space = this._space;
		}
		
		//创建圆形刚体
		protected function createCircle(posX:Number, posY:Number, radius:int, type:BodyType):void
		{
			var circle:Body = new Body(type, new Vec2(posX, posY));
			var shape:Circle = new Circle(radius, null, Material.glass());
			circle.shapes.push(shape);
			circle.space = this._space;
		}
		
		//绘制场景周围包裹的静态刚体
		protected function createWall():void
		{
			createBox(stage.stageWidth / 2, 0, stage.stageWidth, 10, BodyType.STATIC);
			createBox(stage.stageWidth / 2, stage.stageHeight, stage.stageWidth, 10, BodyType.STATIC);
			createBox(0, stage.stageHeight / 2, 10, stage.stageHeight, BodyType.STATIC);
			createBox(stage.stageWidth, stage.stageHeight / 2, 10, stage.stageWidth, BodyType.STATIC);
		}
	
	}
}