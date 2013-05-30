package com.hjx.diagram.editor
{
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class NodeAdorner extends Adorner
	{
		[SkinPart(required="false")]
		public var rightArrowHandle:DisplayObject;
		[SkinPart(required="false")]
		public var topArrowHandle:DisplayObject;
		[SkinPart(required="false")]
		public var bottomArrowHandle:DisplayObject;
		[SkinPart(required="false")]
		public var leftArrowHandle:DisplayObject;
		public function NodeAdorner(adornedObject:Renderer)
		{
			super(adornedObject);
		}
		
		override protected function isHandle(object:Object):Boolean
		{
			if(object is LinkHandle)
				return true;
			return super.isHandle(object);
		}
		
		override protected function onAdornerMouseMove(event:MouseEvent):void
		{
			rightArrowHandle.visible=topArrowHandle.visible=bottomArrowHandle.visible=leftArrowHandle.visible
				= isMouseNear(8);
		}
	}
}