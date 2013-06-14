package com.hjx.diagram.editor
{
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import spark.components.Group;
	
	public class ToBeAddedPalette extends Group
	{
		public var _draggedRenderer:Renderer;
		
		private var _isVertical:Boolean;
		
		public function ToBeAddedPalette()
		{
			super();
			isVertical = true;
			this.addEventListener(MouseEvent.CLICK, this.mouseClickHandler);
		}
		
		public function get isVertical():Boolean
		{
			return _isVertical;
		}

		public function set isVertical(value:Boolean):void
		{
			_isVertical = value;
		}

		/**
		 * 移动的时候，添加代理，开始拖拽 
		 * @param arg1
		 * 
		 */
		internal function mouseMoveHandler(event:MouseEvent):void
		{
			/*var rect:Rectangle = this.getBounds(this.parent);
			rect.x-=rect.width;
			rect.y-=rect.height;
			rect.width *=2;
			rect.height *=2;
			rect.contains(*/
		}
		/**
		 * 当鼠标按下的时候，计算偏移量，添加拖拽代理。 
		 * @param arg1
		 * 
		 */
		internal function mouseClickHandler(event:MouseEvent):void
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
			
//			event.stopPropagation();
		}
	}
}