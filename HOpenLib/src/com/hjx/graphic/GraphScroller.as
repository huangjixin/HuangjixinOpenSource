package com.hjx.graphic
{
	/**
	 * @author 黄记新, 下午3:55:27
	 */
	import com.hjx.graphic.skin.GraphScrollerSkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IFactory;
	import mx.core.ScrollPolicy;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Group;
	import spark.components.HScrollBar;
	import spark.components.VScrollBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.NavigationUnit;
	import spark.effects.animation.Animation;

	/*[Style(name="verticalScrollPolicy", inherit="yes", type="String",enumeration="on,off,auto")]
	[Style(name="horizontalScrollPolicy", inherit="yes", type="String",enumeration="on,off,auto")]*/
	[DefaultProperty("graph")]
	public class GraphScroller extends SkinnableComponent
	{
		private var _dragging:Boolean = false;
		private var _panned:Boolean = false;
		private var _last:Point;
		private var _zoomAnimator:Animation;
		private var _translateAnimator:Animation;
		private var _fitAnimator:Animation;
		private var _graph : Graph;
		[SkinPart(required="false")]
		[Bindable]
		public var horizontalScrollBar : HScrollBar;
		
		[SkinPart(required="false")]
		[Bindable]
		public var verticalScrollBar : VScrollBar;
		public var zoomReticle:IFactory;
		private var _zoomFactor:Number = 1.4;
		private var _allowWheelZoom:Boolean = true;
		private var _animatedWheelZoom:Boolean = true;
		private var _allowPan:Boolean = true;
		private var _allowKeyboardScorll:Boolean = true;
		private var _allowKeyboardZoom:Boolean = true;
		private var _maxZoom:Number = 1.79769e+308;
		private var _maxZoomChanged:Boolean = false;
		private var _minZoom:Number = 5.56268e-309;
		private var _minZoomChanged:Boolean = false;
		private var _zoom:Number = 1;
		private var _changedZoom:Boolean = false;
		private var _wheelZoomModifierKey:String = "ctrl";
		private var _panModifierKey:String = "shift";
		private var _orientation:String = "ltr";
		private const SMALL_SCROLL_OFFSET:Number = 10;
		private var _previousVisiableArea:Rectangle;
		private var _horizontalScrollOffset:Number = 0;
		private var _verticalScrollOffset:Number = 0;
		private var mxmlContentChanged:Boolean = false;
		private var _mxmlContent:Array;
		private var _viewport:Group;
		private var _graphChanged:Boolean = false;
		//--------------------------------------------------------
		// 构造函数，初始化相关工作可以放在里面
		//--------------------------------------------------------
		public function GraphScroller()
		{
			super();
			this._last = new Point();
			addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			setStyle("skinClass",GraphScrollerSkin);
		}
		
		//--------------------------------------------------------
		// getter和setter函数
		//--------------------------------------------------------
		[Bindable(event="orientationChange")]
		public function get orientation():String
		{
			return _orientation;
		}

		public function set orientation(value:String):void
		{
			if( _orientation !== value)
			{
				_orientation = value;
				dispatchEvent(new Event("orientationChange"));
			}
		}

		[Bindable(event="panModifierKeyChange")]
		public function get panModifierKey():String
		{
			return _panModifierKey;
		}

		public function set panModifierKey(value:String):void
		{
			if( _panModifierKey !== value)
			{
				_panModifierKey = value;
				dispatchEvent(new Event("panModifierKeyChange"));
			}
		}

		[Bindable(event="wheelZoomModifierKeyChange")]
		public function get wheelZoomModifierKey():String
		{
			return _wheelZoomModifierKey;
		}

		public function set wheelZoomModifierKey(value:String):void
		{
			if( _wheelZoomModifierKey !== value)
			{
				_wheelZoomModifierKey = value;
				dispatchEvent(new Event("wheelZoomModifierKeyChange"));
			}
		}

		[Bindable(event="zoomChange")]
		public function get zoom():Number
		{
			return _zoom;
		}

		public function set zoom(value:Number):void
		{
			if( _zoom !== value)
			{
				_zoom = value;
				this._changedZoom = true;
				invalidateProperties();
				dispatchEvent(new Event("zoomChange"));
			}
		}

		[Bindable(event="minZoomChange")]
		public function get minZoom():Number
		{
			return _minZoom;
		}

		public function set minZoom(value:Number):void
		{
			if( _minZoom !== value)
			{
				_minZoom = value;
				this._minZoomChanged = true;
				invalidateProperties();
				dispatchEvent(new Event("minZoomChange"));
			}
		}

		[Bindable(event="maxZoomChange")]
		public function get maxZoom():Number
		{
			return _maxZoom;
		}

		public function set maxZoom(value:Number):void
		{
			if( _maxZoom !== value)
			{
				_maxZoom = value;
				this._maxZoomChanged = true;
				invalidateProperties();
				dispatchEvent(new Event("maxZoomChange"));
			}
		}

		[Bindable(event="allowKeyboardZoomChange")]
		public function get allowKeyboardZoom():Boolean
		{
			return _allowKeyboardZoom;
		}

		public function set allowKeyboardZoom(value:Boolean):void
		{
			if( _allowKeyboardZoom !== value)
			{
				_allowKeyboardZoom = value;
				dispatchEvent(new Event("allowKeyboardZoomChange"));
			}
		}

		[Bindable(event="allowKeyboardScorllChange")]
		public function get allowKeyboardScorll():Boolean
		{
			return _allowKeyboardScorll;
		}

		public function set allowKeyboardScorll(value:Boolean):void
		{
			if( _allowKeyboardScorll !== value)
			{
				_allowKeyboardScorll = value;
				dispatchEvent(new Event("allowKeyboardScorllChange"));
			}
		}

		[Bindable(event="allowPanChange")]
		public function get allowPan():Boolean
		{
			return _allowPan;
		}

		public function set allowPan(value:Boolean):void
		{
			if( _allowPan !== value)
			{
				_allowPan = value;
				dispatchEvent(new Event("allowPanChange"));
			}
			
			if(value)
				addMouseEventListener();
			else
				removeMouseEventListener();
		}
		
		public function get animatedWheelZoom():Boolean
		{
			return _animatedWheelZoom;
		}

		public function set animatedWheelZoom(value:Boolean):void
		{
			_animatedWheelZoom = value;
		}

		[Bindable(event="zoomFactorChange")]
		public function get zoomFactor():Number
		{
			return _zoomFactor;
		}

		public function set zoomFactor(value:Number):void
		{
			if( _zoomFactor !== value)
			{
				_zoomFactor = value;
				dispatchEvent(new Event("zoomFactorChange"));
			}
		}

		/**
		 *  
		 * @return 
		 * 
		 */
		public function get graph():Graph
		{
			return _graph;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set graph(value:Graph):void
		{
			if(_graph == value)
				return;
			var oldGraph:Graph = this._graph;
			if(oldGraph){
				oldGraph.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,component_propertyChangeHandler);
				this._viewport.removeElement(oldGraph);
			}
			_graph = value;
			if(this._graph){
				//				this._graph.graphLayoutShift = GraphAutoShift.NONE;
				this._graph.clipAndEnableScrolling = false;
				if(!this._viewport){
					this._viewport = this._graph;
					this._viewport.addEventListener(ResizeEvent.RESIZE,viewportResizeHandler);
				}
				this._graph.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,component_propertyChangeHandler);
			}
			dispatchEvent(new PropertyChangeEvent("graphChanged",false,false,null,"graph",oldGraph,this._graph));
		}
		/**
		 * 滚轮事件处理函数。 
		 * @param event
		 * 
		 */
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			var navigationUnit:uint = 0;
			
			if(!this._viewport || event.isDefaultPrevented())
				return;
			if(this.verticalScrollBar){
				navigationUnit = event.delta<0?NavigationUnit.DOWN:NavigationUnit.UP;
			}else if(this.horizontalScrollBar){
				
			}
			
			/*var loc1:*=NaN;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=0;
			var loc5:*=NaN;
			if (this._viewport == null || event.isDefaultPrevented()) 
			{
				return;
			}
			if (this.allowWheelZoom && isMatching(arg1, this.wheelZoomModifierKey)) 
			{
				loc1 = arg1.delta > 0 ? this._zoomFactor : 1 / this._zoomFactor;
				loc2 = new flash.geom.Point(arg1.stageX, arg1.stageY);
				loc3 = loc2.clone();
				loc2 = this._viewport.globalToLocal(loc2);
				loc3 = globalToLocal(loc3);
				this.setZoom(this.zoom, this.zoom * loc1, loc2.x, loc2.y, loc3.x, loc3.y, true, this.animatedWheelZoom);
				arg1.stopPropagation();
				arg1.updateAfterEvent();
			}
			else if (this.verticalScrollBar == null) 
			{
				if (this.horizontalScrollBar != null) 
				{
					loc4 = arg1.delta < 0 ? spark.core.NavigationUnit.LEFT : spark.core.NavigationUnit.RIGHT;
					loc5 = this.getHorizontalScrollPositionDelta(loc4);
					this.translateBy(loc5 * Math.abs(arg1.delta), 0);
					arg1.stopPropagation();
				}
			}
			else 
			{
				loc4 = arg1.delta < 0 ? spark.core.NavigationUnit.DOWN : spark.core.NavigationUnit.UP;
				loc5 = this.getVerticalScrollPositionDelta(loc4);
				this.translateBy(0, loc5 * Math.abs(arg1.delta));
				arg1.stopPropagation();
			}*/
		}
		
		private function getVerticalPositionDelta(navigationUnit:uint):void
		{
			switch(navigationUnit)
			{
				case NavigationUnit.UP:
				{
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		}//getV结束
		
		/**
		 * 获得矩阵。 
		 * @return 
		 * 
		 */
		private function getScrolledLayoutMatrix():Matrix
		{
			var matrix:Matrix = this._viewport.getLayoutMatrix();
			return matrix;
		}//getScrolledLayoutMatrix结束
		
		protected function viewportResizeHandler(event:ResizeEvent):void
		{
			updateScroll();
		}
		
		private function updateScroll():void
		{
		}
		
		//--------------------------------------------------------
		// 相关事件响应函数和逻辑函数存放处
		//--------------------------------------------------------
		private function removeMouseEventListener():void
		{
			if(skin)
				skin.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		private function addMouseEventListener():void
		{
			if(skin)
				skin.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function component_propertyChangeHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		private function installViewport():void
		{
			if (skin && _viewport)
			{
				_viewport.clipAndEnableScrolling = false;
				(skin as Group).addElementAt(_viewport, 0);
			}
			if (verticalScrollBar)
				verticalScrollBar.viewport = _viewport;
			if (horizontalScrollBar)
				horizontalScrollBar.viewport = _viewport;
		}
		
		private function uninstallViewport():void
		{
			if (horizontalScrollBar)
				horizontalScrollBar.viewport = null;
			if (verticalScrollBar)
				verticalScrollBar.viewport = null;        
			if (skin && _viewport)
			{
				_viewport.clipAndEnableScrolling = false;
				(skin as Group).removeElement(_viewport);
			}
		}
		
		public function ensureRectangleIsVisible(rectangle:Rectangle, centered:Boolean = false, animate:Boolean = false):void{
			
		}
		
		/**
		 * 更新两条滚动条是否可视。 
		 * 
		 */
		private function updateScrollbarVisibility():void{
			updateScrollbarVisibilityImpl(new Rectangle(0,0,width,height));
		}
		
		/**
		 * 更新两条滚动条是否可视。 
		 * 
		 */
		private function updateScrollbarVisibilityImpl(rectangle:Rectangle):void{
			var vScrollVisiable:Boolean = false;
			var hScrollVisiable:Boolean = false;
			var verticalScrollPolicy:String = getStyle("verticalScrollPolicy");
			var horizontalScrollPolicy:String = getStyle("horizontalScrollPolicy");
			var isVScollbarNeed:Boolean = false;
			var isHScollbarNeed:Boolean = false;
			
			if(verticalScrollPolicy == ScrollPolicy.AUTO && horizontalScrollPolicy == ScrollPolicy.AUTO){
				/*if (hScrollVisiable){
					
				}else if (hScrollVisiable){
					
				}else if (hScrollVisiable){
					
				}else if (hScrollVisiable){
					
				}*/
			}
			
			if(verticalScrollBar)
				verticalScrollBar.visible = isVScollbarNeed;
			if(horizontalScrollBar)
				horizontalScrollBar.visible = isHScollbarNeed;
		}
		
		private function isHorizontalScrollbarNeeded(rect:Rectangle,need:Boolean):void
		{
			var rectangle:Rectangle = rect.clone();
			if(need){
				
			}
		}//isHorizontalScrollbarNeeded结束
		
		private static function transformRect(matrix:Matrix,rectangle:Rectangle):Rectangle{
			var result:Rectangle = new Rectangle();
			var topLeft:Point = matrix.transformPoint(rectangle.topLeft);
			var bottomRight:Point = matrix.transformPoint(rectangle.bottomRight);
			result.x = Math.min(topLeft.x,bottomRight.x);
			result.y = Math.min(topLeft.y,bottomRight.y);
			result.width = Math.max(topLeft.x,bottomRight.x) - result.x;
			result.height = Math.max(topLeft.y,bottomRight.y) - result.y;
			return result;
		}
		//--------------------------------------------------------
		// override 覆盖函数
		//--------------------------------------------------------
		override protected function attachSkin():void{
			super.attachSkin();
			if(!skin){
				return;
			}
			
			installViewport();
			
			if(this.allowPan)
				addMouseEventListener();
		}
		
		override protected function detachSkin():void{
			if(!skin){
				return;
			}
			if(this.allowPan)
				removeMouseEventListener();
			skin.removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			this.uninstallViewport();
			super.detachSkin();
		}
	}
}