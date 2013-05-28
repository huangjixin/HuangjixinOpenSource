package com.hjx.diagram.editor
{
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;

	/**
	 * 边饰器基类。 
	 * @author huangjixin
	 * 
	 */
	public class Adorner extends SkinnableComponent
	{
		private var _adornedObject:Renderer;
		
		/**
		 * 构造函数。 
		 * @param adornedObject
		 * 
		 */
		public function Adorner(adornedObject:Renderer)
		{
			this._adornedObject = adornedObject;
			adornedObject.addEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.updateCompleteHandler);
			this.addEventListener(flash.events.Event.ADDED, this.addedHandler);
			this.addEventListener(flash.events.Event.REMOVED, this.removedHandler)
		}
		
		public function get adornedObject():Renderer
		{
			return this._adornedObject;
		}
		
		protected function removedHandler(event:Event):void
		{
			if (event.target == this) 
			{
				this.cleanup();
			}
		}
		
		protected function addedHandler(event:Event):void
		{
			if (event.target == this) 
			{
				invalidateProperties();
			}
		}
		
		protected function updateCompleteHandler(event:FlexEvent):void
		{
			invalidateProperties();
		}
		
		/**
		 * 获得边饰相对的矩形框。 
		 * @param displayObject
		 * @return 
		 * 
		 */
		protected function getAdornerRectangle(displayObject:DisplayObject):Rectangle
		{
			return this._adornedObject.getBounds(displayObject);
		}
		
		/**
		 * 清除边饰器。 
		 * 
		 */
		protected function cleanup():void
		{
			this.removeEventListener(flash.events.Event.ADDED, this.addedHandler);
			this.removeEventListener(flash.events.Event.REMOVED, this.removedHandler);
			this.adornedObject.removeEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.updateCompleteHandler);
			return;
		}
		
		/**
		 * 复写 commitProperties函数以便让其自动更新位置。
		 * 
		 */
		protected override function commitProperties():void
		{
			var rectangle:Rectangle=null;
			super.commitProperties();
			if (parent != null) 
			{
				rectangle = this.getAdornerRectangle(parent);
				this.left = rectangle.x;
				this.top = rectangle.y;
				this.width = rectangle.width;
				this.height = rectangle.height;
			}
			return;
		}
	}
}