package cn.hnisi.ravis.editor
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;

	public class Adorner extends SkinnableComponent
	{
		private var _adornedObject:UIComponent;
		
		public function Adorner(adornedObject:UIComponent)
		{
			this._adornedObject = adornedObject;
			adornedObject.addEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.updateCompleteHandler);
			this.addEventListener(flash.events.Event.ADDED, this.addedHandler);
			this.addEventListener(flash.events.Event.REMOVED, this.removedHandler)
		}
		
		public function get adornedObject():UIComponent
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
		
		protected function getAdornerRectangle(arg1:DisplayObject):Rectangle
		{
			return this._adornedObject.getBounds(arg1);
		}
		
		protected function cleanup():void
		{
			this.removeEventListener(flash.events.Event.ADDED, this.addedHandler);
			this.removeEventListener(flash.events.Event.REMOVED, this.removedHandler);
			this.adornedObject.removeEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.updateCompleteHandler);
			return;
		}
		
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