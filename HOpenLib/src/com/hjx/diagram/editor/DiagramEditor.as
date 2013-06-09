/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.diagram.editor
{
	/*******************************************
	 **** huangjixin,2013-4-2,下午2:06:27 作者：黄记新**
	 **** Diagram编辑器  **635152644@qq.com bb2wb4cM6qU2 https://code.google.com/p/flex-visiual
	 * https://flex-visiual.googlecode.com/svn/trunk
	 *******************************************/
	import com.hjx.bpmn.graphic.HorizontalPool;
	import com.hjx.diagram.Diagram;
	import com.hjx.diagram.editor.skin.DiagramEditorSkin;
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.Link;
	import com.hjx.graphic.Node;
	import com.hjx.graphic.Renderer;
	import com.hjx.graphic.SubGraph;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.SandboxMouseEvent;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.managers.DragManager;
	
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
		
		public var allowReparenting:Boolean=true;
		
		public var allowDropping:Boolean =true;
		
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
		
		internal var _currentSubgraph:SubGraph=null;
		private var currentSubgraphFlashing:Boolean;
		
		public var linkPrototype:Link;
		
		public var cloneFunction:Function;
		public var autoAlign:Boolean = true;
		
		public function DiagramEditor()
		{
			super();
			
			this.selectedObjects = new Vector.<Renderer>();
			this.adorners = new Dictionary();
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, this.editorKeyDownHandler);
			
			this.addEventListener(DragEvent.DRAG_ENTER, this.dragEnterHandler);
			this.addEventListener(DragEvent.DRAG_OVER, this.dragOverHandler);
			this.addEventListener(DragEvent.DRAG_DROP, this.dragDropHandler);
		}//构造函数结束
		
		
		//--------------------------------------------------------
		// getter和setter函数
		//--------------------------------------------------------
		internal function get currentSubgraph():SubGraph
		{
			return this._currentSubgraph;
		}
		
		internal function set currentSubgraph(subGraph:SubGraph):void
		{
			if (subGraph != this._currentSubgraph) 
			{
				this._currentSubgraph = subGraph;
			}
			this.currentSubgraphFlashing = false;
			return;
		}
		
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
		
		/**
		 * 鼠标拖拽。 
		 * @param event
		 * 
		 */
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
				
				if (this.isDragging) 
				{
					var translated:Boolean = false;
					if (this.allowMoving) 
					{
						for each (var selectedRenderer:Renderer in getSelectedObjects()) 
						{
							var adorner:Adorner = this.getAdorner(selectedRenderer);
							if (!adorner) 
							{
								continue;
							}
							if (selectedRenderer is Link) 
							{
								var moveLink:Link;
								var startNode:Node = Link(selectedRenderer).startNode;
								var endNode:Node = Link(selectedRenderer).endNode;
								if (startNode && endNode && this.isSelected(startNode) && this.isSelected(endNode)) 
								{
									continue;
								}
							}
							/*if (!moveLink) 
							{
								continue;
							}*/
							var currentPoint:Point = new Point(currentX, currentY);
							this.translate(selectedRenderer, new Point(currentPoint.x - this.lastX, currentPoint.y - this.lastY));
							translated = true;
							selectedRenderer.invalidateProperties();
							adorner.invalidateProperties();
							if(selectedRenderer is Node){
								Node(selectedRenderer).invalidateLinkShape();
							}
						}
					}
					if(translated){
						validateNow();
						if (this.allowReparenting) 
						{
							this.trackCurrentSubgraph(event);
							playDraggingMoveAdorner(this.currentSubgraph,event);
							var graph:Graph = this.currentSubgraph == null ? this._graph : this.currentSubgraph.graph;
							if (this.reparent(this.selectedObjects, graph)) 
							{
								this.flashCurrentSubgraph();
							}
						}
					}else if (!this.inAdornerInteraction) 
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
				this.lastX = currentX;
				this.lastY = currentY;
			}
		}
		
		internal function mouseUpHandler(event:Event):void
		{
			var rectangle:Rectangle = null;
			var length:int; 
			var renderer:Renderer = null;
			if (this.marquee != null) 
			{
				rectangle = new Rectangle(Number(this.marquee.left), Number(this.marquee.top), this.marquee.width, this.marquee.height);
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
			
			renderer = getRenderer(event.target);
			if(renderer){
				if(autoAlign){
					autoAlignRenderer(renderer,renderer.parent as IVisualElementContainer);
				}
			}
			
			this.mouseDown = false;
			this.isDragging = false;
			this.resetCurrentSubgraph();
			this.playDraggingMoveAdorner(null);
			
			var displayObject:DisplayObject = systemManager.getSandboxRoot();
			displayObject.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);
			displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);
			systemManager.deployMouseShields(false);
			return;
		}
		
		internal function translate(renderer:Renderer, point:Point):void
		{
			/*var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_MOVE, arg1)) 
			{
				return;
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.Link) 
			{
				loc1 = com.ibm.ilog.elixir.diagram.Link(arg1);
				loc1.fallbackStartPoint = loc1.fallbackStartPoint.add(arg2);
				if (loc1.intermediatePoints != null) 
				{
					loc2 = new Vector.<flash.geom.Point>();
					var loc4:*=0;
					var loc5:*=loc1.intermediatePoints;
					for each (loc3 in loc5) 
					{
						loc2.push(loc3.add(arg2));
					}
					loc1.intermediatePoints = loc2;
				}
				loc1.fallbackEndPoint = loc1.fallbackEndPoint.add(arg2);
			}
			else 
			{
				setX(arg1, getX(arg1) + arg2.x);
				setY(arg1, getY(arg1) + arg2.y);
				this.layoutPorts(com.ibm.ilog.elixir.diagram.Node(arg1));
			}*/
			if(renderer is Link){
				var link:Link = Link(renderer);
				link.fallbackStartPoint = link.fallbackStartPoint.add(point);
				link.fallbackEndPoint = link.fallbackEndPoint.add(point);
			}else{
				renderer.setX(renderer, renderer.getX(renderer) + point.x);
				renderer.setY(renderer, renderer.getY(renderer) + point.y);
			}
		}
		
		internal function trackCurrentSubgraph(event:MouseEvent):void
		{
			var subGraph:SubGraph=null;
			var flag:Boolean =false;
			var objectsUnderPoint:Array = this._graph.stage.getObjectsUnderPoint(new Point(event.stageX, event.stageY));
			var length:int = (objectsUnderPoint.length - 1);
			while (length >= 0) 
			{
				subGraph = getRenderer(objectsUnderPoint[length]) as SubGraph;
				
				if (subGraph && !subGraph.collapsed && DiagramEditor.getEditor(subGraph)) 
				{
					flag = false;
					if (!DragManager.isDragging) 
					{
						var displayObje:DisplayObject = subGraph;
						while (displayObje != null) 
						{
							if (displayObje is Renderer && this.isSelected(Renderer(displayObje))) 
							{
								flag = true;
							}
							displayObje = displayObje.parent;
						}
					}
					if (!flag) 
					{
						this.currentSubgraph = subGraph;
						return;
					}
				}
				--length;
			}
			this.currentSubgraph = null;
			return;
		}
		
		internal function flashCurrentSubgraph():void
		{
			/*var loc1:*=null;
			if (this.currentSubgraph != null) 
			{
				loc1 = this.getAdorner(this.currentSubgraph) as com.ibm.ilog.elixir.diagram.editor.SubgraphAdorner;
				if (loc1 != null) 
				{
					loc1.flash = true;
					this.currentSubgraphFlashing = true;
				}
			}
			return;*/
		}
		
		internal function resetCurrentSubgraph():void
		{
			if (this.currentSubgraphFlashing) 
			{
				setTimeout(this.clearCurrentSubgraph, 200);
			}
			else 
			{
				this.currentSubgraph = null;
			}
			return;
		}
		
		internal function clearCurrentSubgraph():void
		{
			this.currentSubgraph = null;
			return;
		}
		
		/**
		 * 重新定义父亲。 
		 * @param seleObjs
		 * @param graph
		 * @return 
		 * 
		 */
		public function reparent(seleObjs:Vector.<Renderer>, graph:Graph):Boolean
		{
			var reparentd:Boolean;
			
			for each (var renderer:Renderer in seleObjs) 
			{
				if (renderer.parent == graph) 
				{
					continue;
				}
				if (!Graph(graph).allowReparenting) 
				{
					continue;
				}
				
				var point:Point = new Point(renderer.getX(renderer), renderer.getY(renderer));
				point = renderer.parent.localToGlobal(point);
				point = graph.globalToLocal(point);
				
				var link:Link = renderer as Link;
				if(link){
					link.fallbackStartPoint = graph.globalToLocal(link.parent.localToGlobal(link.fallbackStartPoint));
					link.fallbackEndPoint = graph.globalToLocal(link.parent.localToGlobal(link.fallbackEndPoint));
				}
				
				Graph(renderer.parent).removeElement(renderer);
				if (!(renderer is Link)) 
				{
					renderer.setX(renderer, point.x);
					renderer.setY(renderer, point.y);
				}
				graph.addElement(renderer);
				var node:Node = renderer as Node;
				var sub:SubGraph = renderer as SubGraph;
				if (node) 
				{
					var length:int=0;
					var links:Vector.<Link> = node.getLinks();
					for each (link in links) 
					{
						reparentLink(link);
					}
					/*if (loc6) 
					{
					reparentIntergraphLinks(loc6);
					}*/
				}
				reparentd = true;
			}
			return reparentd;
		}
		
		
		static function reparentLink(link:Link):void
		{
			var graph:Graph=link.parent as Graph;
			if (!graph) 
			{
				return;
			}
			var startNode:Renderer=link.startNode;
			var endNode:Renderer=link.endNode;
			
			if (startNode == null) 
			{
				startNode = link;
			}
			if (endNode == null) 
			{
				endNode = link;
			}
			if (startNode && endNode) 
			{
				var lowestCommonGraph:Graph = getLowestCommonGraph(startNode, endNode);
				if (lowestCommonGraph == null) 
				{
					return;
				}
				var editor:DiagramEditor = DiagramEditor.getEditor(link);
				if (lowestCommonGraph == graph) 
				{
					if (!(startNode == null) && !(startNode.parent == null) && !(startNode.parent == graph) || 
						!(endNode == null) && !(endNode.parent == null) && !(endNode.parent == graph)) 
					{
						var index:int = -1;
						if (startNode != null) 
						{
							var renderer:Renderer = startNode;
							var nodeGrpah:Graph;
							while (!(renderer == null) && !(renderer.parent == graph)) 
							{
								nodeGrpah = renderer.parent as Graph;
								if (nodeGrpah.owningSubGraph) 
								{
									renderer = nodeGrpah.owningSubGraph;
									continue;
								}
								break;
							}
							if (renderer != null) 
							{
								index = graph.getElementIndex(renderer);
							}
						}
						if (endNode != null) 
						{
							renderer = endNode;
							while (!(renderer == null) && !(renderer.parent == graph)) 
							{
								nodeGrpah = renderer.parent as Graph;
								if (nodeGrpah.owningSubGraph) 
								{
									renderer = nodeGrpah.owningSubGraph;
									continue;
								}
								break;
							}
							if (renderer != null) 
							{
								index = Math.max(index, graph.getElementIndex(renderer));
							}
						}
						if (index > graph.getElementIndex(link)) 
						{
							/*if (loc5) 
							{
								if (!loc5.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_CHANGE_ZORDER, arg1)) 
								{
									return;
								}
							}*/
							graph.setElementIndex(link, index);
						}
					}
				}
				else 
				{
					/*if (loc5) 
					{
						if (!loc5.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_REPARENT, arg1)) 
						{
							return;
						}
					}*/
					graph.removeElement(link);
					/*if ((loc6 = link.intermediatePoints).length != 0) 
					{
						loc7 = 0;
						while (loc7 < loc6.length) 
						{
							loc6[loc7] = loc2.globalToLocal(loc1.localToGlobal(loc6[loc7]));
							++loc7;
						}
						arg1.intermediatePoints = loc6;
					}*/
					link.fallbackStartPoint = lowestCommonGraph.globalToLocal(graph.localToGlobal(link.fallbackStartPoint));
					link.fallbackEndPoint = lowestCommonGraph.globalToLocal(graph.localToGlobal(link.fallbackEndPoint));
					lowestCommonGraph.addElement(link);
				}
			}
			return;
		}
		
		
		public static function getLowestCommonGraph(renderer1:Renderer, renderer2:Renderer):Graph
		{
			if (renderer1 == null || renderer2 == null) 
			{
				throw new ArgumentError("参数不得为null");
			}
			var graph1:Graph=renderer1.parent as Graph;
			var graph2:Graph=renderer2.parent as Graph;
			if (graph1 == null || graph2 == null) 
			{
				return null;
			}
			if (graph1 == graph2) 
			{
				return graph1;
			}
			if (isGraphAncestorOf(graph1, graph2)) 
			{
				return graph1;
			}
			if (isGraphAncestorOf(graph2, graph1)) 
			{
				return graph2;
			}
			if (graph1.owningSubGraph == null) 
			{
				return graph1;
			}
			return getLowestCommonGraph(graph1.owningSubGraph, renderer2);
		}
		
		internal static function isGraphAncestorOf(graph1:Graph, graph2:Graph):Boolean
		{
			var graph:Graph;
			if (graph2.owningSubGraph == null) 
			{
				graph = graph2.parent as Graph;
			}
			else 
			{
				graph = graph2.owningSubGraph.parent as  Graph;
			}
			while (graph != null) 
			{
				if (graph == graph1) 
				{
					return true;
				}
				if (graph.owningSubGraph != null) 
				{
					graph = graph.owningSubGraph.parent as  Graph;
					continue;
				}
				graph = graph.parent as Graph;
			}
			return false;
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
		 * 清理。 
		 * 
		 */
		public function clear():void
		{
//			this.finishTextEditing(true);
			this.deselectAll();
//			this.unhighlightAll();
			this._graph.removeAllElements();
			this.selectedObjects = new Vector.<Renderer>();
			this.adorners = new Dictionary();
			this._currentSubgraph = null;
//			this.textEditingAdorner = null;
//			this.textPart = null;
			if (this.adornersGroup != null) 
			{
				this.adornersGroup.removeAllElements();
			}
			return;
		}
		
		private function autoAlignRenderer(renderer:Renderer, parent:IVisualElementContainer):void
		{
			var ele:IVisualElement;
			var length:int = 0;
			while(length < parent.numElements){
				ele = parent.getElementAt(length);
				if(ele != renderer){
					if(Math.abs(ele.x-renderer.x)<3){
						renderer.x = ele.x;
					}
					if(Math.abs(ele.y-renderer.y)<3){
						renderer.y = ele.y;
					}
					if(Math.abs(ele.x+ele.width-renderer.x)<3){
						renderer.x = ele.x+ele.width;
					}
					if(Math.abs(ele.y+ele.height-renderer.y)<3){
						renderer.y = ele.y+ele.height;
					}
					
					if(Math.abs(ele.x+ele.width-renderer.x-renderer.width)<3){
						renderer.x = ele.x+ele.width-renderer.width;
					}
					if(Math.abs(ele.y+ele.height-renderer.y-renderer.height)<3){
						renderer.y = ele.y+ele.height-renderer.height;
					}
				}
				length++;
			}
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
				this._diagram.top = 0;
				this._diagram.bottom = 0;
				this._diagram.left = 0;
				this._diagram.right = 0;
				diagramParent.addElementAt(this._diagram, 0);
				this.graph = this._diagram.graph;
			}
		}
		
		public function createLink():Link
		{
			var link:Link=null;
			if (this.linkPrototype == null) 
			{
				link = new Link();
			}
			else 
			{
				link = Link(this.linkPrototype.clone());
			}
			return link;
		}
		
		/**
		 * 链接节点。 
		 * 
		 */
		public function connectNodes():void
		{
			var selObjs:Vector.<Renderer> = getSelectedObjects();
			if (selObjs.length == 2) {
				if ((selObjs[0] is Node) && (selObjs[1] is Node)) {
					var link:Link = createLink();
					if (link) {
						link.startNode = Node(selObjs[0]);
						link.endNode = Node(selObjs[1]);
						var linkParent:Graph = DiagramEditor.getLowestCommonGraph(link.startNode, link.endNode);
						linkParent.addElement(link);
					}            
				}
			}        
		}
		
		internal function editorKeyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.DELETE:
				{
					deleteSelection();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		public function deleteSelection():void
		{
			if(getSelectedObjects().length>0){
			
			}
			this.reallyDeleteSelection(this.selectedObjects);
			return;
		}
		
		/**
		 * 真正实现删除节点的方法。 
		 * @param selectedObjs
		 * 
		 */
		internal function reallyDeleteSelection(selectedObjs:Vector.<Renderer>):void
		{
			var objects:Vector.<Renderer> = selectedObjs.concat();
			for each (var renderer:Renderer in objects) 
			{
				if (renderer is Node) 
				{
					var links:Vector.<Link>=Node(renderer).getLinks();
					for each (var link:Link in links) 
					{
						
						this.deleteRenderer(link);
					}
				}
				this.deleteRenderer(renderer);
			}
			return;
		}
		
		internal function deleteRenderer(renderer:Renderer):void
		{
			var link:Link= renderer as Link;
			if (link != null) 
			{
				/*this.disconnectLink(loc1, true);
				this.disconnectLink(loc1, false);*/
			}
			/*if (!(this.textEditingAdorner == null) && this.textEditingAdorner.adornedObject == arg1) 
			{
				this.finishTextEditing(true);
			}
			this.setHighlighted(arg1, false);*/
			this.setSelected(renderer, false);
			if (renderer.parent != null) 
			{
				Graph(renderer.parent).removeElement(renderer);
			}
			return;
		}
		/**
		 * 拖拽enter的时候 
		 * @param arg1
		 * 
		 */
		internal function dragEnterHandler(event:DragEvent):void
		{
			if (this.allowDropping && event.dragSource.hasFormat(DiagramPalette.DRAG_DROP_FORMAT))
			{
				var renderer:Renderer = Renderer(event.dragInitiator);
				var diagramPalette:DiagramPalette = renderer.parent as DiagramPalette;
				if (diagramPalette != null) 
				{
					var cloneRenderer:Renderer = renderer.clone();
					if(cloneFunction!=null){
						cloneFunction.call(this,renderer,cloneRenderer);
					}
					diagramPalette.dragImage.removeAllElements();
					diagramPalette.dragImage.addElement(cloneRenderer);
//					this.cloneChildren(loc1, loc3);
					cloneRenderer.setX(cloneRenderer, 0);
					cloneRenderer.setY(cloneRenderer, 0);
					
				}
				DragManager.acceptDragDrop(this);
			}
		}
		
		internal function dragOverHandler(event:DragEvent):void
		{
			if (this.allowDropping) 
			{
				this.trackCurrentSubgraph(event);
				playDraggingMoveAdorner(this.currentSubgraph);
			}
			return;
		}
		
		internal function dragDropHandler(event:DragEvent):void
		{
			if (this.allowDropping && event.dragSource.hasFormat(DiagramPalette.DRAG_DROP_FORMAT)) 
			{
				var renderer:Renderer = Renderer(event.dragInitiator);
				var diagramPalette:DiagramPalette = renderer.parent as DiagramPalette;
				var offsetX:Number = diagramPalette == null ? 0 : diagramPalette.offsetX;
				var offsetY:Number = diagramPalette == null ? 0 : diagramPalette.offsetY;
				var dropGraph:Graph;
				if (this.currentSubgraph == null) 
				{
					dropGraph = this._graph;
				}
				else 
				{
					dropGraph = this.currentSubgraph.graph;
				}
				if(!dropGraph.allowReparenting){
					return;
				}
				var graphMousePoint:Point = new Point(this._graph.mouseX, this._graph.mouseY);
				graphMousePoint.x = graphMousePoint.x - offsetX;
				graphMousePoint.y = graphMousePoint.y - offsetY;
				graphMousePoint = this._graph.localToGlobal(graphMousePoint);
				graphMousePoint = dropGraph.globalToLocal(graphMousePoint);
				graphMousePoint = this.snapPoint(graphMousePoint, dropGraph);
				
				var cloneRenderer:Renderer = renderer.clone();
				if(cloneFunction!=null){
					cloneFunction.call(this,renderer,cloneRenderer);
				}
				
				var link:Link;
				if (cloneRenderer is Link) 
				{
					link = Link(renderer);
					var cloneLink:Link = Link(cloneRenderer);
					cloneLink.fallbackStartPoint = graphMousePoint;
					cloneLink.fallbackEndPoint = new Point(graphMousePoint.x + (link.fallbackEndPoint.x - link.fallbackStartPoint.x), graphMousePoint.y + (link.fallbackEndPoint.y - link.fallbackStartPoint.y));
				}
				else 
				{
					cloneRenderer.setX(cloneRenderer, graphMousePoint.x);
					cloneRenderer.setY(cloneRenderer, graphMousePoint.y);
				}
				
				dropGraph.addElement(cloneRenderer);
//				this.cloneChildren(loc1, loc7);
				this.selectOnly(cloneRenderer);
				this._graph.setFocus();
				/*if (this.allowEditingText && this.allowEditingTextOnCreate) 
				{
					this.startEditingText(loc7);
				}*/
				this.flashCurrentSubgraph();
			}
			
			this.resetCurrentSubgraph();
			playDraggingMoveAdorner(this.currentSubgraph);
			return;
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
				if (!adorner) 
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
		
		internal function playDraggingMoveAdorner(displayObj:DisplayObject,event:MouseEvent=null):void
		{
			this.adornersGroup.graphics.clear();
			this.adornersGroup.graphics.lineStyle(2,0xff0000);
			if(event){
				var renderer:Renderer = getRenderer(event.target);
				if(renderer){
					var ele:Renderer;
					var length:int = 0;
					var rendererRect:Rectangle = renderer.getBounds(this.adornersGroup);
					var eleRect:Rectangle;
					var parentGraph:Graph = Graph(renderer.parent);
					if(parentGraph){
						while(length < parentGraph.numElements){
							ele = parentGraph.getElementAt(length) as Renderer;
							eleRect = ele.getBounds(this.adornersGroup);
							if(ele != renderer){
								if(Math.abs(ele.x-renderer.x)<3){
									this.adornersGroup.graphics.moveTo(eleRect.left,eleRect.top);
									this.adornersGroup.graphics.lineTo(eleRect.left,rendererRect.top+rendererRect.height);
								}else if(Math.abs(ele.y-renderer.y)<3){
									this.adornersGroup.graphics.moveTo(eleRect.left,eleRect.top);
									this.adornersGroup.graphics.lineTo(rendererRect.left+rendererRect.width,eleRect.top);
								}else if(Math.abs(ele.x+ele.width-renderer.x)<3){
									this.adornersGroup.graphics.moveTo(eleRect.left+eleRect.width,eleRect.top);
									this.adornersGroup.graphics.lineTo(eleRect.left+eleRect.width,rendererRect.top+rendererRect.height);
								}else if(Math.abs(ele.y+ele.height-renderer.y)<3){
									this.adornersGroup.graphics.moveTo(eleRect.left,eleRect.top+eleRect.height);
									this.adornersGroup.graphics.lineTo(rendererRect.left+rendererRect.width,eleRect.top+eleRect.height);
								}else if(Math.abs(ele.x+ele.width-renderer.x-renderer.width)<3){
								}else if(Math.abs(ele.y+ele.height-renderer.y-renderer.height)<3){
								}
							}
							length++;
						}
					}
				}
			}
			
			if(displayObj){
				var rect:Rectangle = displayObj.getBounds(this.adornersGroup);
				this.adornersGroup.graphics.drawRect(rect.left,rect.top,rect.width,rect.height);
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