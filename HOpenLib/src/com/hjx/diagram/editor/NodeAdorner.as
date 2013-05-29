package com.hjx.diagram.editor
{
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	
	public class NodeAdorner extends Adorner
	{
		[SkinPart(required="false")]
		public var topLeftHandle:DisplayObject;
		[SkinPart(required="false")]
		public var topRightHandle:DisplayObject;
		[SkinPart(required="false")]
		public var bottomLeftHandle:DisplayObject;
		[SkinPart(required="false")]
		public var bottomRightHandle:DisplayObject;
		
		public function NodeAdorner(adornedObject:Renderer)
		{
			super(adornedObject);
		}
		
		override protected function isHandle(object:Object):Boolean
		{
			if(object is Handle)
				return true;
			return false;
		}
	}
}