/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.diagram.editor
{
	/*******************************************
	 **** huangjixin,2013-4-2,下午2:06:27 作者：黄记新**
	 **** Diagram编辑器  **
	 *******************************************/
	import com.hjx.diagram.Diagram;
	import com.hjx.diagram.editor.skin.DiagramEditorSkin;
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.Node;
	import com.hjx.graphic.Renderer;
	import com.hjx.graphic.SubGraph;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.events.SandboxMouseEvent;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	import ws.tink.spark.graphics.SolidColorDash;
	import ws.tink.spark.primatives.Rect;
	
	[DefaultProperty("diagram")]
	public class DiagramEditor extends SkinnableComponent
	{
		//--------------------------------------------------------
		// private 类私有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：private static const EXAMPLE:String = "example";
		//--------------------------------------------------------
		
		//--------------------------------------------------------
		// public 类公有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：public static const EXAMPLE:String = "example";
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//--------------------------------------------------------
		public var allowMoving:Boolean=true;
		
		private var defaultCSSStyles:Object = {
			skinClass:DiagramEditorSkin
		};
		
		private var _diagram:Diagram;
		private var _diagramChanged:Boolean = false;
		private var _graph:Graph;
		
		private var _inAdornerInteraction:Boolean;
		/**
		 * 内部边饰器字典。 
		 */
		internal var adorners:Dictionary;
		/**
		 * 选择对象集。 
		 */
		internal var selectedObjects:Vector.<Renderer>;
		
		/**
		 * 框选矩形框。 
		 */
		private var marquee:Rect;
		
		//--------------------------------------------------------
		// public 公有变量声明处
		//--------------------------------------------------------
		[SkinPart(required="true")]
		public var adornersGroup:Group;
		[SkinPart(required="true")]
		public var diagramParent:Group;
		[SkinPart(required="false")]
		public var grid:Grid;
		
		//--------------------------------------------------------
		// 构造函数，初始化相关工作可以放在里面
		//--------------------------------------------------------
		private var startX:Number;
		private var startY:Number;
		
		private var lastX:Number;
		private var lastY:Number;
		
		internal var mouseDown:Boolean;
		internal var isDragging:Boolean;
		
		
		public function DiagramEditor()
		{
			super();
			
			this.selectedObjects = new Vector.<Renderer>();
			this.adorners = new Dictionary();
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
		}//构造函数结束
		
		
		//--------------------------------------------------------
		// getter和setter函数
		//--------------------------------------------------------

		public function get inAdornerInteraction():Boolean
		{
			return _inAdornerInteraction;
		}

		public function set inAdornerInteraction(value:Boolean):void
		{
			_inAdornerInteraction = value;
		}

		public function get graph():Graph
		{
			return _graph;
		}

		public function set graph(value:Graph):void
		{
			_graph = value;
		}

		[Bindable]
		public function get diagram():Diagram
		{
			return _diagram;
		}
		
		public function set diagram(value:Diagram):void
		{
			_diagram = value;
			_diagramChanged = true;
			invalidateProperties();
		}
		
		public static function getRenderer(object:Object):Renderer
		{
			while (object is flash.display.DisplayObject) 
			{
				if (object is Renderer) 
				{
					return Renderer(object);
				}
				if (object is Adorner) 
				{
					return Adorner(object).adornedObject;
				}
				object = object.parent;
			}
			return null;
		}
		
		//--------------------------------------------------------
		// 相关事件响应函数和逻辑函数存放处
		//--------------------------------------------------------
		/**
		 * 找到顶层编辑器。 
		 * @param displayObject
		 * @return 
		 * 
		 */
		public static function getEditor(displayObject:DisplayObject):DiagramEditor
		{
			var displayObjectContainer:DisplayObjectContainer = displayObject.parent;
			while (displayObjectContainer != null) 
			{
				if (displayObjectContainer is DiagramEditor) 
				{
					return DiagramEditor(displayObjectContainer);
				}
				displayObjectContainer = displayObjectContainer.parent;
			}
			return null;
		}
		/**
		 * 鼠标响应函数，判断该拖拽还是框选。 
		 * @param event
		 * 
		 */
		internal function mouseDownHandler(event:MouseEvent):void
		{
			var graphRect:Rectangle = this.graph.getBounds(this.adornersGroup);
			if (!graphRect.contains(this._graph.mouseX, this._graph.mouseY)) 
			{
				return;
			}
			
			var renderer:Renderer=getRenderer(event.target);
			this._graph.setFocus();
			if (event.ctrlKey) 
			{
				if (renderer != null) 
				{
					this.setSelected(renderer, !this.isSelected(renderer));
				}
			}
			else if (renderer == null || !this.isSelected(renderer)) 
			{
				this.selectOnly(renderer);
			}

			if (event.ctrlKey || event.shiftKey) 
			{
				return;
			}
			
			this.mouseDown = true;
			
			this.startX = this.adornersGroup.mouseX;  
			this.startY = this.adornersGroup.mouseY;
			
			var displayObject:DisplayObject = systemManager.getSandboxRoot();  
			displayObject.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);  
			displayObject.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);  
			displayObject.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);  
			displayObject.addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);  
			systemManager.deployMouseShields(true);  

			return;
		}
		
		internal function mouseMoveHandler(event:MouseEvent):void
		{

		}
		
		internal function mouseOverHandler(arg1:flash.events.MouseEvent):void
		{
			
		}
		
		internal function mouseDragHandler(event:MouseEvent):void
		{
			var startPoint:Point; //拖拽开始点。
			if (this.mouseDown && !this.inAdornerInteraction) 
			{
				var currentX:Number = this.adornersGroup.mouseX;  
				var currentY:Number = this.adornersGroup.mouseY; 
				
				var renderer:Renderer = getRenderer(event.target);
				if (!this.isDragging) 
				{
					//此处我们认为移动的距离超过两个像素便认定在拖拽。
					if (Math.abs(currentX - this.startX) > 2 || Math.abs(currentY - this.startY) > 2) 
					{
						this.isDragging = true;
						startPoint = new Point(this.startX, this.startY);
						//变换为graph对象的坐标。
						startPoint = this.snapPoint(startPoint, this._graph);
						this.lastX = startPoint.x;
						this.lastY = startPoint.y;
					}
				}
				
				if (!this.inAdornerInteraction) 
				{
					if (this.marquee == null) 
					{
						this.marquee = new Rect();
						this.marquee.maxWidth = Number.MAX_VALUE;
						this.marquee.maxHeight = Number.MAX_VALUE;
						var solidColorDash:SolidColorDash = new SolidColorDash(2,2,0x2A9DFF,1,1);
						var solidColor:SolidColor = new SolidColor(0x0576DC,0.2);
						this.marquee.stroke = solidColorDash;
						this.marquee.fill = solidColor;
						this.adornersGroup.addElement(this.marquee);
					}
					
					var start:Point = this.adornersGroup.globalToLocal(this.adornersGroup.localToGlobal(new flash.geom.Point(this.startX, this.startY)));  
					var end:Point = this.adornersGroup.globalToLocal(this.adornersGroup.localToGlobal(new flash.geom.Point(currentX, currentY)));  
					this.marquee.left = Math.min(start.x, end.x);  
					this.marquee.top = Math.min(start.y, end.y);  
					this.marquee.width = Math.abs(start.x - end.x);  
					this.marquee.height = Math.abs(start.y - end.y);
				}
			}
		}
		
		internal function mouseUpHandler(event:Event):void
		{
			var rectangle:Rectangle = null;
			var length:int; 
			var renderer:Renderer = null;
			if (this.marquee != null) 
			{
				rectangle = new flash.geom.Rectangle(Number(this.marquee.left), Number(this.marquee.top), this.marquee.width, this.marquee.height);
				this.adornersGroup.removeElement(this.marquee);
				this.marquee = null;
				this.deselectAllExcept();
				length = 0;
				while (length < this._graph.numElements) 
				{
					renderer = this._graph.getElementAt(length) as Renderer;
					if (renderer && rectangle.intersects(renderer.getBounds(this.adornersGroup))) 
					{
						this.setSelected(renderer, true);
					}
					++length;
				}
			}	
			
			this.mouseDown = false;
			this.isDragging = false;
			
			var displayObject:DisplayObject = systemManager.getSandboxRoot();
			displayObject.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);
			displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);
			systemManager.deployMouseShields(false);
			return;
		}
		
		public function setSelected(renderer:Renderer, isSelected:Boolean):void
		{
			if (this.isSelected(renderer) != isSelected) 
			{
				if (isSelected) 
				{
					this.selectedObjects.push(renderer);
				}
				else 
				{
					this.selectedObjects.splice(this.selectedObjects.indexOf(renderer), 1);
				}
				this.updateAdorner(renderer);
			}
			return;
		}
		
		public function deselectAll():void
		{
			this.deselectAllExcept();
			return;
		}
		
		/**
		 * 坐标转换。 
		 * @param point
		 * @param displayObjectContainer
		 * @return 
		 * 
		 */
		function snapPoint(point:Point, displayObjectContainer:DisplayObjectContainer):flash.geom.Point
		{
			if (displayObjectContainer != this._graph) 
			{
				point = this._graph.globalToLocal(displayObjectContainer.localToGlobal(point));
			}

			if (displayObjectContainer != this._graph) 
			{
				point = displayObjectContainer.globalToLocal(this._graph.localToGlobal(point));
			}
			
			return point;
		}
		
		function deselectAllExcept(arg1:Renderer=null):void
		{
			var loc1:*=null;
			var loc2:*=0;
			var loc3:*=this.selectedObjects.concat();
			for each (loc1 in loc3) 
			{
				if (loc1 == arg1) 
				{
					continue;
				}
				this.setSelected(loc1, false);
			}
			return;
		}
		
		internal function selectOnly(renderer:Renderer=null):void
		{
			this.deselectAllExcept(renderer);
			if (renderer != null) 
			{
				this.setSelected(renderer, true);
			}
			return;
		}
		
		/**
		 * 判断一个渲染器是否被选中。 
		 * @param renderer
		 * @return 
		 * 
		 */
		public function isSelected(renderer:Renderer):Boolean
		{
			return this.selectedObjects.indexOf(renderer) >= 0;
		}
		
		/**
		 * 获取选中对象。 
		 * @return 
		 * 
		 */
		public function getSelectedObjects():Vector.<Renderer>
		{
			return this.selectedObjects.concat();
		}
		/**
		 * 安装Diagram。 
		 * 
		 */
		private function installDiagram():void
		{
			if (diagramParent)
			{
				diagramParent.removeAllElements();
				this._diagram.percentWidth = 100;
				this._diagram.percentHeight = 100;
				diagramParent.addElementAt(this._diagram, 0);
				this.graph = this._diagram.graph;
			}
		}
		
		//--------------------------------------------------------
		// 相关事件响应函数和逻辑函数存放处
		//--------------------------------------------------------
		/**
		 * 更新边饰器。 
		 * @param renderer
		 * 
		 */
		internal function updateAdorner(renderer:Renderer):void
		{
			var adorner:Adorner=this.getAdorner(renderer);
			if (this.isSelected(renderer as Renderer)) 
			{
				if (adorner == null) 
				{
					adorner = this.createAdorner(renderer);
					this.adorners[renderer] = adorner;
					this.adornersGroup.addElement(adorner);
				}
			}
			else if (adorner != null) 
			{
				this.adornersGroup.removeElement(adorner);
				this.adorners[renderer] = null;
			}
			return;
		}
		
		internal function createAdorner(renderer:Renderer):Adorner
		{
			var adorner:* = renderer.getStyle("adornerClass");
			if(adorner){
				return new adorner(renderer);
			}
			if (renderer is SubGraph) 
			{
				return new ResizableNodeAdorner(renderer);
			}else if (renderer is Node) 
			{
				return new NodeAdorner(renderer);
			}
			throw new ArgumentError("参数有误");
		}
		
		public function getAdorner(renderer:Renderer):Adorner
		{
			return Adorner(this.adorners[renderer]);
		} 
		
		//--------------------------------------------------------
		// override 覆盖函数
		//--------------------------------------------------------
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			if(instance == adornersGroup){
				/**/
			}
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
			if(_diagramChanged){
				_diagramChanged = false;
				installDiagram();
			}
		}
		
		override public function stylesInitialized():void{
			super.stylesInitialized();
			/*for (var i:String in defaultCSSStyles) {
				if (getStyle (i) == undefined) {
					setStyle (i, defaultCSSStyles [i]);
				}
			}*/
		}
	}//类结束
}//包结束