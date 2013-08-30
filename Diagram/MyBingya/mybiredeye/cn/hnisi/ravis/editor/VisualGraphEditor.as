package cn.hnisi.ravis.editor
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.effects.Glow;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.DragEvent;
	import mx.events.SandboxMouseEvent;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.managers.DragManager;
	import mx.utils.ObjectUtil;
	
	import org.un.cava.birdeye.ravis.components.renderers.BaseRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.data.IGraph;
	import org.un.cava.birdeye.ravis.graphLayout.data.Node;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.VisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.edgeRenderers.BaseEdgeRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent;
	
	import spark.components.Group;
	import spark.filters.GlowFilter;
	
	import ws.tink.spark.graphics.SolidColorDash;
	import ws.tink.spark.primatives.Rect;
	
	[Event(name="rendererDoubleClick", type="flash.events.MouseEvent")]
	[Event(name="edgeDoubleClick", type="cn.hnisi.ravis.editor.VisualGraphEditorEvent")]
	public class VisualGraphEditor extends VisualGraph
	{
		internal static var rendererProperties:Array=null;
		
		private var _selection:Vector.<BaseRenderer>;
		private var adorners:Dictionary;
		
		public var grid:Grid;
		public var adornersGroup:Group;
		
		private var marquee:Rect;
		private var startX:Number;
		private var startY:Number;
		
		internal var lastX:Number;
		internal var lastY:Number;
		
		private var _rendererAdded:Boolean;
		private var rect:Rectangle;
		private var currentRenderer:UIComponent;
		
		private var seleEdge:BaseEdgeRenderer;
		
		public function VisualGraphEditor()
		{
			super();
			
			_selection = new Vector.<BaseRenderer>();
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			newNodesDefaultVisible = true;
			
			adorners = new Dictionary();
	
			this.addEventListener(DragEvent.DRAG_ENTER, this.dragEnterHandler);
			this.addEventListener(DragEvent.DRAG_OVER, this.dragOverHandler);
			this.addEventListener(DragEvent.DRAG_DROP, this.dragDropHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onAdornerGroupMouseDown);
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onAdornerGroupDoubleClick);
//			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			var renderer:BaseRenderer = GetRenderer(event.target);
			updateToolTipRenderer(renderer);
		}
		
		private function updateToolTipRenderer(renderer:BaseRenderer):void
		{
			/*if(renderer){
				if(!toolTipRenderer){
					toolTipRenderer = new ToolTipRenderer();
				}
				toolTipRenderer.adornerObject = renderer;
				this.adornersGroup.addElement(toolTipRenderer);
				toolTipRenderer.visible = true;
			}else{
				if(toolTipRenderer){
//					this.adornersGroup.removeElement(toolTipRenderer);
					toolTipRenderer.visible = false;
				}
//				toolTipRenderer = null;
			}*/
			return;
		}
		
		override public function set graph(g:IGraph):void{
			clearAllAdorners();
			super.graph = g;
		}
		
		internal function dragEnterHandler(event:DragEvent):void
		{
			if (event.dragSource.hasFormat(Palette.DATA_FORMAT)) 
			{
				DragManager.acceptDragDrop(this);
			}
		}
		
		internal function dragOverHandler(event:DragEvent):void
		{
			/*if (this.allowDropping) 
			{
				this.trackCurrentSubgraph(arg1);
			}
			return;*/
		}
		
		internal function dragDropHandler(event:DragEvent):void
		{
			if (event.dragSource.hasFormat(Palette.DATA_FORMAT)) 
			{
				var object:Object=event.dragSource.dataForFormat(Palette.DATA_FORMAT);
				var hDistance:Number=object.hDistance;
				var vDistance:Number=object.vDistance;
				
				var dragInitiator:BaseRenderer=event.dragInitiator as BaseRenderer;
				var data:Object = dragInitiator.data.data;
				var clonedData:Object = ObjectUtil.clone(data);
				var id:String = ""
//					+Math.floor(10000*Math.random());
//				if(data is XML){
//					var dataXml:XML = data as XML;
//					if(dataXml.@id != undefined){
//						dataXml.@id = id;
//					}
//				}
				var ivisualNode:IVisualNode = addRenderer(id,clonedData);
				XML(ivisualNode.data).@id = ""+ivisualNode.id;
				var baseRenderer:UIComponent = ivisualNode.view;
				baseRenderer.parent.setChildIndex(baseRenderer,0);
				ivisualNode.viewX = this.mouseX - hDistance;
				ivisualNode.viewY = this.mouseY - vDistance;
				ivisualNode.refresh();
				var filter:flash.filters.GlowFilter = new flash.filters.GlowFilter(0xE9AB96,1,10,10);
				ivisualNode.view.filters = [filter];
				
			}
		}
		
		protected function onChildRemove(event:ChildExistenceChangedEvent):void
		{
			updateAdorner(event.relatedObject as UIComponent);
		}
		
		
		protected function onChildAdd(event:ChildExistenceChangedEvent):void
		{
			clearAllAdorners();
			setSelected(event.relatedObject as BaseRenderer,true);
			updateAdorner(event.relatedObject as UIComponent);
		}
		
		/**
		 * 清空选择项。 
		 * 
		 */
		public function clearSelection(renderer:BaseRenderer):void{
			var index:int = this._selection.indexOf(renderer);
			if( index != -1){
				this._selection.splice(index,1);
			}
		}
		
		/**
		 * 清空选择项。 
		 * 
		 */
		public function clearAll():void{
			this._selection.splice(0,this._selection.length);
		}
		
		/**
		 * 清空选择项。 
		 * 
		 */
		public function clearAllAdorners():void{
			var length:int = this._selection.length;
			while(length>=0){
				var baseRender:BaseRenderer = this._selection.pop();
				updateAdorner(baseRender);
				length--;
			}
		}
		
		/**
		 * 选中全部。 
		 * 
		 */
		public function selectAll():void{
			clearAll();
			var length:int = nodeLayer.numChildren;
			for(var i:int = length-1; i>= 0; i--){
				var renderer:UIComponent = nodeLayer.getChildAt(i) as UIComponent;
				if(renderer is BaseRenderer){
					setSelected(renderer as BaseRenderer,true);
				}
			}
		}
		
		/**
		 * 获得选中的节点。 
		 * @return 
		 * 
		 */
		public function getSelection():Vector.<BaseRenderer>{
			return this._selection;
		}
		
		/**
		 * 获得选中的节点。 
		 * @return 
		 * 
		 */
		public function setSelected(renderer:BaseRenderer,selected:Boolean = true):void{
			if(selected){
				if(this._selection.indexOf(renderer) == -1){
					this._selection.push(renderer);
				}
			}else{
				var index:int = this._selection.indexOf(renderer);
				if( index != -1){
					this._selection.splice(index,1);
				}
			}
		}
		
		/**
		 * 获得选中的节点。 
		 * @return 
		 * 
		 */
		public function isSelected(renderer:BaseRenderer):Boolean{
			var index:int = this._selection.indexOf(renderer);
			if( index != -1){
				return true;
			}else{
				return false;
			}
		}
		
		/**
		 * 映射到节点。 
		 * @param ui
		 * @return 
		 * 
		 */
		public function renderToNode(ui:UIComponent):IVisualNode{
			return lookupNode(ui);
		}
		
		/**
		 * 映射到连线。 
		 * @param ui
		 * @return 
		 * 
		 */
		public function renderToEdge(ui:UIComponent):IVisualEdge{
			return lookupEdge(ui);
		}
		
		/**
		 * 删除渲染器。 
		 * @param renderer
		 * 
		 */
		public function deleteRenderer(renderer:UIComponent):void
		{
			var ivisualNode:IVisualNode = lookupNode(renderer);
			if(ivisualNode && ivisualNode.view is BaseRenderer){
				setSelected(ivisualNode.view as BaseRenderer,false);
			}
			
			if(ivisualNode){
				removeNode(ivisualNode);
			}
		}
		
		public function deleteEdge(renderer:UIComponent):void{
			var iVisualEdge:IVisualEdge = lookupEdge(renderer);
			
			if(iVisualEdge){
				removeVEdge(iVisualEdge);
			}
		}

		/**
		 * 添加渲染器。 
		 * @param sid
		 * @param o
		 * 
		 */
		public function addRenderer(sid:String = "",o:Object = null):IVisualNode
		{
			var currentRoot:IVisualNode = this.currentRootVNode;
			var ivisualNode:IVisualNode = createNode(sid,o);
			this.currentRootVNode = currentRoot;
			return ivisualNode;
		}
		
		/**
		 * 获取最上面的渲染器。 
		 * @param object
		 * @return 
		 * 
		 */
		public function getBaseRender(object:Object):BaseRenderer
		{
			while (object is DisplayObject) 
			{
				if (object is BaseRenderer) 
				{
					return BaseRenderer(object);
				}
				object = object.parent;
			}
			return null;	
		}
		
		public function getRenderders():Array{
			var array:Array = [];
			for(var i:int = nodeLayer.numChildren-1;i>=0;i--){
				array.push(nodeLayer.getChildAt(i));
			}
			
			for(var j:int = edgeLayer.numChildren-1;j>=0;j--){
				array.push(edgeLayer.getChildAt(j));
			}
			
			/*for(i = 0;i<edgeLabelLayer.numChildren;i++){
				array.push(edgeLabelLayer.getChildAt(i));
			}*/
			
			return array;
		}
		
		internal function updateAdorner(renderer:UIComponent):void
		{
			var adorner:Adorner=this.getAdorner(renderer);
			if (this.isSelected(renderer as BaseRenderer)) 
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
		
		internal function createAdorner(renderer:UIComponent):Adorner
		{
			if (renderer is BaseRenderer) 
			{
				return new BaseRendererAdorner(renderer);
			}
			throw new ArgumentError("参数有误");
		}
		
		public function getAdorner(renderer:UIComponent):Adorner
		{
			return Adorner(this.adorners[renderer]);
		}
		
		override protected function dragBegin(event:MouseEvent):void{
			super.dragBegin(event);
			/*this.startX = this.adornersGroup.mouseX;
			this.startY = this.adornersGroup.mouseY;*/
		}
		
		override protected function dragEnd(event:MouseEvent):void {
			super.dragEnd(event);
			if(!event.ctrlKey){
				return;
			}
			if(this.getSelection().length ==1){
				return;
			}
			/*var hitRenderer:BaseRenderer = event.currentTarget as BaseRenderer;
			var snapPoint:Point;
			var mousePoint:Point;
			var startPoint:Point = new Point (this.startX,this.startY);
			startPoint = this.snapPoint(startPoint, this);
			this.lastX = startPoint.x;
			this.lastY = startPoint.y;
			
			var mX:Number = this.mouseX;
			var mY:Number = this.mouseY;
			mousePoint = new Point(mX,mY);
			
			var i:int=0;
			while (i < this.getSelection().length) 
			{
				var renderer:BaseRenderer = getSelection()[i] as BaseRenderer;
				if(renderer != hitRenderer){
					this.translate(renderer, new flash.geom.Point(mousePoint.x - this.lastX, mousePoint.y - this.lastY));
				}
				
				i++;
			}*/
		}
		
		override protected function handleDrag(event:MouseEvent):void{
			super.handleDrag(event);
			/*var hitRenderer:BaseRenderer = event.currentTarget as BaseRenderer;
			var snapPoint:Point;
			var mousePoint:Point;
			var startPoint:Point = new Point (this.startX,this.startY);
			startPoint = this.snapPoint(startPoint, this);
			this.lastX = startPoint.x;
			this.lastY = startPoint.y;
			
			var mX:Number = this.mouseX;
			var mY:Number = this.mouseY;
			mousePoint = new Point(mX,mY);
			
			var length:int=0;
			while (length < this.getSelection().length) 
			{
				var renderer:BaseRenderer = getSelection()[length] as BaseRenderer;
				if(renderer != hitRenderer){
					this.translate(renderer, new flash.geom.Point(mousePoint.x - this.lastX, mousePoint.y - this.lastY));
				}
				
				length++;
			}*/
		}
		
		private  function getBaseEdgeRenderer(object:Object):BaseEdgeRenderer
		{
			while(object){
				if (object is BaseEdgeRenderer) 
				{
					return object as BaseEdgeRenderer;
				}
				object = object.parent;
			}
			return null;
		}

		
		/**
		 * 双击 
		 * @param event
		 * 
		 */
		protected function onAdornerGroupDoubleClick(event:MouseEvent):void
		{
			var baseEdgeRenderer:BaseEdgeRenderer = getBaseEdgeRenderer(event.target);
			if(baseEdgeRenderer){
				dispatchEvent(new VisualGraphEditorEvent(VisualGraphEditorEvent.EDGE_DOUBLE_CLICK,baseEdgeRenderer));
			}
		}
		
		
		/**
		 * 单击。 
		 * @param event
		 * 
		 */
		protected function onAdornerGroupMouseDown(event:MouseEvent):void
		{
			this.setFocus();
			
			var baseEdgeRenderer:BaseEdgeRenderer = getBaseEdgeRenderer(event.target);
			if(baseEdgeRenderer){
				seleEdge = baseEdgeRenderer;
				return;
			}
			
			if(!event.ctrlKey){
				return;
			}
			
			this.startX = this.adornersGroup.mouseX;
			this.startY = this.adornersGroup.mouseY;
			var displayObject:DisplayObject = systemManager.getSandboxRoot();
			displayObject.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);
			displayObject.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);
			displayObject.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);
			displayObject.addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);
			systemManager.deployMouseShields(true);
		}
		
		protected function mouseDragHandler(event:Event):void
		{
			var lastX:Number = this.adornersGroup.mouseX;
			var lastY:Number = this.adornersGroup.mouseY;
			
			if (this.marquee == null) 
			{
				this.marquee = new Rect();
				this.marquee.maxWidth = Number.MAX_VALUE;
				this.marquee.maxHeight = Number.MAX_VALUE;
				this.marquee.stroke = new SolidColorDash(5,5,0,1,1);
//				this.marquee.fill = new SolidColor(0x0478DF,0.4);
				this.adornersGroup.addElement(this.marquee);
			}
			
			var start:Point = this.adornersGroup.globalToLocal(this.adornersGroup.localToGlobal(new flash.geom.Point(this.startX, this.startY)));
			var end:Point = this.adornersGroup.globalToLocal(this.adornersGroup.localToGlobal(new flash.geom.Point(lastX, lastY)));
			this.marquee.left = Math.min(start.x, end.x);
			this.marquee.top = Math.min(start.y, end.y);
			this.marquee.width = Math.abs(start.x - end.x);
			this.marquee.height = Math.abs(start.y - end.y);
		}
		
		protected function mouseUpHandler(event:Event):void
		{
			var rectangle:Rectangle=null;
			var length:int;
			var renderer:UIComponent;
			if (this.marquee != null) 
			{
				rectangle = new Rectangle(Number(this.marquee.left), Number(this.marquee.top), this.marquee.width, this.marquee.height);
				this.adornersGroup.removeElement(this.marquee);
				this.marquee = null;
				
				length = 0;
				while (length < this.nodeLayer.numChildren) 
				{
					renderer = this.nodeLayer.getChildAt(length) as UIComponent;
					if (renderer) 
					{
						var renderRect:Rectangle = renderer.getBounds(this.adornersGroup);
						if(rectangle.intersects(renderRect)){
							this.setSelected(renderer as BaseRenderer, true);
							updateAdorner(renderer);
						}else{
							this.setSelected(renderer as BaseRenderer, false);
							updateAdorner(renderer);
						}
					}
					++length;
				}
			}
			
			var displayObject:DisplayObject=systemManager.getSandboxRoot();
			displayObject.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);
			displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);
			systemManager.deployMouseShields(false);
		}
		
		public static function GetRenderer(object:Object):BaseRenderer
		{
			while (object is DisplayObject) 
			{
				if (object is BaseRenderer) 
				{
					return BaseRenderer(object);
				}
				object = object.parent;
			}
			return null;
		}
		
		override protected function backgroundDragBegin(event:MouseEvent):void{
			if(event.ctrlKey){
				
			}else{
				super.backgroundDragBegin(event);
				clearAllAdorners();
				clearAll();
			}
		}
		
		override protected function createVNodeComponent(vn:IVisualNode):UIComponent {
			var mycomponent:UIComponent = super.createVNodeComponent(vn);
//			mycomponent.doubleClickEnabled = false;
//			mycomponent.removeEventListener(MouseEvent.DOUBLE_CLICK, nodeDoubleClick,false);
			return mycomponent;
		}
		
		override protected function nodeDoubleClick(e:MouseEvent):void {
			var baseRender:BaseRenderer = e.currentTarget as BaseRenderer;
			var visualNodeEvent:VisualNodeEvent = new VisualNodeEvent(VisualNodeEvent.DOUBLE_CLICK);
			visualNodeEvent.baseRenderer = baseRender;
			dispatchEvent(visualNodeEvent);
		}
		
		override  protected function nodeMouseDown(e:MouseEvent):void {
			super.nodeMouseDown(e);
			var renderer:BaseRenderer;
			if(e.currentTarget is BaseRenderer){
				renderer = e.currentTarget as BaseRenderer;
			}
			
			if(!renderer){
				return;
			}
			renderer.useHandCursor = false;
			if(e.ctrlKey){
				if(isSelected(renderer)){
					setSelected(renderer,false);
				}else{
					setSelected(renderer,true);
				}	
			}else{
				if(isSelected(renderer)){
					
				}else{
					clearAllAdorners();
					setSelected(renderer,true);
				}
			}
			
			updateAdorner(renderer);
			this.setFocus();
			
			this.startX = this.mouseX;
			this.startY = this.mouseY;
			
			if (e.ctrlKey || e.shiftKey) 
			{
				return;
			}
		}
		
		function snapPoint(point:Point, displayObjectContainer:DisplayObjectContainer):Point
		{
			if(displayObjectContainer!= this){
				point = this.globalToLocal(displayObjectContainer.localToGlobal(point));
			}
			
			if(displayObjectContainer!= this){
				point = displayObjectContainer.globalToLocal(this.localToGlobal(point));
			}
			return point;
		}
		
		internal function translate(baseRenderer:BaseRenderer, point:Point):void
		{
			setX(baseRenderer, getX(baseRenderer) + point.x);
			setY(baseRenderer, getY(baseRenderer) + point.y);
			return;
		}
		
		
		protected override function createChildren():void
		{
			grid = new Grid();
			grid.percentWidth = 100;
			grid.percentHeight = 100;
			addChild(grid);
			
			super.createChildren();
			super.nodeLayer.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,onChildRemove);
			super.nodeLayer.addEventListener(ChildExistenceChangedEvent.CHILD_ADD,onChildAdd);
			
			adornersGroup = new Group();
			adornersGroup.id = "adornersGroup";
			adornersGroup.percentWidth = 100;
			adornersGroup.percentHeight = 100;
			addChild(adornersGroup);
		}
				
		public function getRendererByIndex(index:int):UIComponent{
			return super.nodeLayer.getChildAt(index) as UIComponent;
		}
		
		public static function getVisualGraphEditor(object:Object):VisualGraphEditor
		{
			if (object == null || (object is VisualGraphEditor) )
			{
				return object as VisualGraphEditor;
			}
			return getVisualGraphEditor(object.parent);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			var length:int;
			switch(event.keyCode)
			{
				case Keyboard.DELETE:
				{
					if(this.seleEdge){
						deleteEdge(seleEdge);
					}
					
					if(getSelection().length == 0){
						return;
					}
					length = getSelection().length;
					var renderer:BaseRenderer;
					
					while(length > 0){
						renderer = getSelection()[length -1];
						if(renderer){
							setSelected(renderer,false);
							deleteRenderer(renderer);
						}
						length --;
					}
					break;
				}
					
				case Keyboard.J:
				{
					if(event.ctrlKey && !event.shiftKey){
						if(getSelection().length < 2){
							return;
						}
						 length = 0;
						while(length +1 < getSelection().length){
							var baseRender0:BaseRenderer = getSelection()[length];
							var baseRender1:BaseRenderer = getSelection()[length+1];
							var ivNode0:IVisualNode = renderToNode(baseRender0);
							var ivNode1:IVisualNode = renderToNode(baseRender1);
							if(!ivNode1 || !ivNode0){
								return;
							}
							linkNodes(ivNode0,ivNode1);
							length++;
						}
					}else if(event.ctrlKey && event.shiftKey){
						if(getSelection().length < 2){
							return;
						}
						
						length = 0;
						while(length +1 < getSelection().length){
							var baseRender0:BaseRenderer = getSelection()[length];
							var baseRender1:BaseRenderer = getSelection()[length+1];
							var ivNode0:IVisualNode = renderToNode(baseRender0);
							var ivNode1:IVisualNode = renderToNode(baseRender1);
							if(!ivNode1 || !ivNode0){
								return;
							}
							unlinkNodes(ivNode0,ivNode1);
							length++;
						}
					}
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		static function cloneInternal(arg1:BaseRenderer, arg2:BaseRenderer):BaseRenderer
		{
			var loc1:BaseRenderer=cloneRendererStatic(arg1);
			arg2.addElement(loc1);
			cloneChildrenStatic(arg1, loc1, null);
			setX(loc1, 0);
			setY(loc1, 0);
			return loc1;
		}
		
		internal static function cloneChildrenStatic(arg1:BaseRenderer, arg2:BaseRenderer, arg3:Function):void
		{
			/*var loc2:*=0;
			var loc3:*=null;
			var loc4:*=null;
			var loc1:*;
			if ((loc1 = arg1 as com.ibm.ilog.elixir.diagram.Subgraph) != null) 
			{
			loc2 = 0;
			while (loc2 < loc1.graph.numElements) 
			{
			if ((loc3 = loc1.graph.getElementAt(loc2) as com.ibm.ilog.elixir.diagram.Renderer) != null) 
			{
			loc4 = cloneRendererStatic(loc3, arg3);
			com.ibm.ilog.elixir.diagram.Subgraph(arg2).graph.addElement(loc4);
			cloneChildrenStatic(loc3, loc4, arg3);
			}
			++loc2;
			}
			}*/
			return;
		}
		
		public static function cloneRendererStatic(arg1:BaseRenderer, arg2:Function=null, arg3:flash.utils.Dictionary=null, arg4:__AS3__.vec.Vector=null):BaseRenderer
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			try 
			{
				if ((loc1 = flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName(arg1)) as Class) != null) 
				{
					loc2 = BaseRenderer(new loc1());
					cloneProperties(arg1, loc2, arg2);
					if (arg2 != null) 
					{
						arg2(arg1, loc2, !(arg3 == null));
					}
					if (arg3 != null) 
					{
						arg3[arg1] = loc2;
					}
					/*if (arg1 is com.ibm.ilog.elixir.diagram.Link) 
					{
					loc3 = com.ibm.ilog.elixir.diagram.Link(arg1);
					if (arg4 != null) 
					{
					arg4.push(loc3);
					}
					loc4 = com.ibm.ilog.elixir.diagram.Link(loc2);
					if (loc3.fallbackStartPoint) 
					{
					loc4.fallbackStartPoint = new flash.geom.Point(loc3.fallbackStartPoint.x, loc3.fallbackStartPoint.y);
					}
					if (loc3.fallbackEndPoint) 
					{
					loc4.fallbackEndPoint = new flash.geom.Point(loc3.fallbackEndPoint.x, loc3.fallbackEndPoint.y);
					}
					}*/
					return loc2;
				}
			}
			catch (err:Error)
			{
			};
			return null;
		}
		
		internal static function cloneProperties(renderer:BaseRenderer, cloneRenderer:BaseRenderer, arg3:Function):void
		{
			var propertyName:*=null;
			var loc5:*=null;
			var loc6:*=null;
			var loc7:*=null;
			if (!(renderer == null) && !(cloneRenderer == null)) 
			{
				setX(cloneRenderer, getX(renderer));
				setY(cloneRenderer, getY(renderer));
				
				cloneRenderer.explicitWidth = renderer.explicitWidth;
				cloneRenderer.explicitHeight = renderer.explicitHeight;
				cloneRenderer.percentWidth = renderer.percentWidth;
				cloneRenderer.percentHeight = renderer.percentHeight;
				cloneRenderer.explicitMinWidth = renderer.explicitMinWidth;
				cloneRenderer.explicitMinHeight = renderer.explicitMinHeight;
				cloneRenderer.explicitMaxWidth = renderer.explicitMaxWidth;
				cloneRenderer.explicitMaxHeight = renderer.explicitMaxHeight;
			}
			if (rendererProperties == null) 
			{
				rendererProperties = new Array();
				var propertyLength:int=0;
				var classInfo:Object = ObjectUtil.getClassInfo(new BaseRenderer())["properties"];
				for each (loc5 in classInfo) 
				{
					rendererProperties.push(loc5.localName);
				}
			}
			var includeReadOnly:Boolean;
			(includeReadOnly = new Object())["includeReadOnly"] = false;
			var loc2:*;
			var loc3:*=(loc2 = mx.utils.ObjectUtil.getClassInfo(renderer, rendererProperties, includeReadOnly))["properties"];
			propertyLength = 0;
			classInfo = loc3;
			for each (propertyName in classInfo) 
			{
			};
			return;
		}
		
		static function getX(baseRenderer:BaseRenderer):Number
		{
			var loc1:Number=NaN;
			if (baseRenderer.left is Number) 
			{
				loc1 = Number(baseRenderer.left);
				if (!isNaN(loc1)) 
				{
					return loc1;
				}
			}
			return baseRenderer.x;
		}
		
		static function setX(baseRenderer:BaseRenderer, positionX:Number):void
		{
			if (baseRenderer.left is Number && !isNaN(Number(baseRenderer.left))) 
			{
				baseRenderer.left = positionX;
			}
			else 
			{
				baseRenderer.x = positionX;
			}
			return;
		}
		
		static function getY(baseRenderer:BaseRenderer):Number
		{
			var loc1:Number=NaN;
			if (baseRenderer.top is Number) 
			{
				loc1 = Number(baseRenderer.top);
				if (!isNaN(loc1)) 
				{
					return loc1;
				}
			}
			return baseRenderer.y;
		}
		
		static function setY(baseRenderer:BaseRenderer, positionY:Number):void
		{
			if (baseRenderer.top is Number && !isNaN(Number(baseRenderer.top))) 
			{
				baseRenderer.top = positionY;
			}
			else 
			{
				baseRenderer.y = positionY;
			}
			return;
		}
	}
}