package com.hjx.diagram.editor
{
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/**
	 * 缩放边饰器。 
	 * @author huangjixin
	 * 
	 */
	public class ResizableNodeAdorner extends NodeAdorner
	{		
		[SkinPart(required="false")]
		public var topLeftHandle:DisplayObject;
		[SkinPart(required="false")]
		public var topRightHandle:DisplayObject;
		[SkinPart(required="false")]
		public var bottomLeftHandle:DisplayObject;
		[SkinPart(required="false")]
		public var bottomRightHandle:DisplayObject;
		
		public function ResizableNodeAdorner(adornedObject:Renderer)
		{
			super(adornedObject);
		}
		
		
		internal function isResizeHandle(event:Object):Boolean
		{
			return event == this.topLeftHandle || event == this.topRightHandle || event == this.bottomRightHandle || event == this.bottomLeftHandle;
		}
		
		override protected function isHandle(object:Object):Boolean
		{
			if(object is Handle)
				return true;
			return super.isHandle(object);
		}
	}
}