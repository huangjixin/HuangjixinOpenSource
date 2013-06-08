package com.hjx.diagram.editor
{
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.core.IVisualElement;
	import mx.managers.DragManager;
	
	/**
	 * 拖拽面板。 
	 * @author huangjixin
	 * 
	 */
	public class DiagramPalette extends Graph
	{
		public static const DRAG_DROP_FORMAT:String="DIAGRAM__DRAG_DROP_FORMAT";
		
		/**
		 * 用于拖拽的基类对象。 
		 */
		internal var _draggedRenderer:Renderer;
		
		private var _startX:Number;
		
		private var _startY:Number;
		
		private var _offsetX:Number;
		
		private var _offsetY:Number;
		
		private var _dragImage:Graph;
		
		private var _data:Object;
		
		/**
		 * 构造函数当中 
		 * 
		 */
		public function DiagramPalette()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseMoveHandler);
		}
		
		[Bindable]
		/**
		 * 不直接使用是为了记录偏移量之类的信息。 
		 */
		public function get dragImage():Graph
		{
			return _dragImage;
		}

		/**
		 * @private
		 */
		public function set dragImage(value:Graph):void
		{
			_dragImage = value;
		}

		[Bindable]
		/**
		 * 拖拽纵坐标坐标偏移量。  
		 */
		public function get offsetY():Number
		{
			return _offsetY;
		}

		/**
		 * @private
		 */
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}

		[Bindable]
		/**
		 * 拖拽横坐标偏移量。 
		 */
		public function get offsetX():Number
		{
			return _offsetX;
		}

		/**
		 * @private
		 */
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}

		[Bindable]
		/**
		 * 开始拖拽的纵坐标。 
		 */
		public function get startY():Number
		{
			return _startY;
		}

		/**
		 * @private
		 */
		public function set startY(value:Number):void
		{
			_startY = value;
		}

		[Bindable]
		/**
		 * 开始拖拽的横坐标。 
		 */
		public function get startX():Number
		{
			return _startX;
		}

		/**
		 * @private
		 */
		public function set startX(value:Number):void
		{
			_startX = value;
		}

		public function set data(value:Object):void
		{
			if (!(value == this.data) && value is IVisualElement) 
			{
				addElementAt(IVisualElement(value), 0);
			}
			return;
		}
		
		[Bindable]
		public function get data():Object
		{
			return numElements > 0 ? getElementAt(0) : null;
		}
		
		/**
		 * 当鼠标按下的时候，计算偏移量，添加拖拽代理。 
		 * @param arg1
		 * 
		 */
		internal function mouseDownHandler(event:MouseEvent):void
		{
			this._draggedRenderer = null;
			var object:Object = event.target;
			while (object is DisplayObject) 
			{
				if (object is Renderer) 
				{
					this._draggedRenderer = Renderer(object);
				}
				else if (object is Adorner) 
				{
					this._draggedRenderer = Adorner(object).adornedObject;
				}
				object = object.parent;
			}
			
			if (this._draggedRenderer == null) 
			{
			}
			else 
			{
				this._startX = mouseX;
				this._startY = mouseY;
			}
			return;
		}
		
		/**
		 * 移动的时候，添加代理，开始拖拽 
		 * @param arg1
		 * 
		 */
		internal function mouseMoveHandler(event:MouseEvent):void
		{
			var dragSource:DragSource = null;
			var gapX:Number=mouseX - this._startX;
			var gapY:Number=mouseY - this._startY;
			if (!this._draggedRenderer && !DragManager.isDragging && (Math.abs(gapX) > 2 || Math.abs(gapY) > 2)) 
			{
				this._offsetX = this._startX - this._draggedRenderer.x;
				this._offsetY = this._startY - this._draggedRenderer.y;
				dragSource = new DragSource();
				dragSource.addData(this._draggedRenderer, DiagramPalette.DRAG_DROP_FORMAT);
				this._dragImage = new DiagramPalette();
				this._dragImage.mouseEnabled = false;
				this._dragImage.mouseChildren = false;
				this.addElement(this._dragImage);
				this._dragImage.addElement(this._draggedRenderer.clone());
				this.removeElement(this._dragImage);
				mx.managers.DragManager.doDrag(this._draggedRenderer, dragSource, event, this._dragImage, -gapX, -gapY);
				this._draggedRenderer = null;
			}
			return;
		}
	}
}