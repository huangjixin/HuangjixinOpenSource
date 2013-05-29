package com.hjx.diagram.editor
{
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
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
		
		
		internal function isResizeHandle(object:Object):Boolean
		{
			return object == this.topLeftHandle || object == this.topRightHandle || object == this.bottomRightHandle || object == this.bottomLeftHandle;
		}
		
		override protected function handleDragged(displayObject:DisplayObject, event:MouseEvent, offsetX:Number, offsetY:Number):void
		{
			trace(offsetX+","+offsetY);
			var loc1:Number=NaN;
			var loc2:Number=NaN;
			var loc3:Number=NaN;
			var loc4:Number=NaN;
			var loc5:Rectangle=null;
			var loc6:Rectangle=null;
			var loc7:Number=NaN;
			var loc8:Number=NaN;
			var loc9:Number=NaN;
			var loc10:Number=NaN;
			if (this.isResizeHandle(displayObject)) 
			{
				/*if (!editor.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_RESIZE, adornedObject)) 
				{
					return;
				}*/
				loc1 = 0;
				loc2 = 0;
				loc3 = 0;
				loc4 = 0;
				if (displayObject == this.topLeftHandle || displayObject == this.bottomLeftHandle) 
				{
					loc1 = offsetX;
					loc3 = -offsetX;
				}
				if (displayObject == this.topLeftHandle || displayObject == this.topRightHandle) 
				{
					loc2 = offsetY;
					loc4 = -offsetY;
				}
				if (displayObject == this.topRightHandle || displayObject == this.bottomRightHandle) 
				{
					loc3 = offsetX;
				}
				if (displayObject == this.bottomRightHandle || displayObject == this.bottomLeftHandle) 
				{
					loc4 = offsetY;
				}
				loc5 = getAdornerRectangle(graph);
				if (!(loc1 == 0) || !(loc2 == 0)) 
				{
					this.translateAdornedObject(loc1, loc2);
				}
				if (!(loc3 == 0) || !(loc4 == 0)) 
				{
					this.resizeAdornedObject(loc3, loc4);
				}
				editor.validateNow();
				loc7 = (loc6 = getAdornerRectangle(graph)).width - (loc5.width + loc3);
				loc8 = loc6.height - (loc5.height + loc4);
				if (!(loc7 == 0) || !(loc8 == 0)) 
				{
					offsetX = 0;
					offsetY = 0;
					loc9 = 0;
					loc10 = 0;
					if (displayObject == this.topLeftHandle || displayObject == this.bottomLeftHandle) 
					{
						offsetX = -loc7;
						loc9 = -loc7;
					}
					if (displayObject == this.topLeftHandle || displayObject == this.topRightHandle) 
					{
						offsetY = -loc8;
						loc10 = -loc8;
					}
					if (displayObject == this.topRightHandle || displayObject == this.bottomRightHandle) 
					{
						loc9 = loc7;
					}
					if (displayObject == this.bottomRightHandle || displayObject == this.bottomLeftHandle) 
					{
						loc10 = loc8;
					}
					this.translateAdornedObject(offsetX, offsetY);
					moveDragPoint(loc9, loc10);
				}
			}
			else 
			{
				super.handleDragged(displayObject, event, offsetX, offsetY);
			}
			return;
		}
		
		protected function translateAdornedObject(offsetX:Number, offsetY:Number):void
		{
			adornedObject.setX(adornedObject,adornedObject.getX(adornedObject)+offsetX);
			adornedObject.setY(adornedObject,adornedObject.getY(adornedObject)+offsetY);
			return;
		}
		
		protected function resizeAdornedObject(offsetX:Number, offsetY:Number):void
		{
			var resizeX:Number=adornedObject.width + offsetX;
			var resizeY:Number=adornedObject.height + offsetY;
			
			if (!isNaN(adornedObject.minWidth)) 
			{
				resizeX = Math.max(resizeX, adornedObject.minWidth);
			}
			if (!isNaN(adornedObject.minHeight)) 
			{
				resizeY = Math.max(resizeY, adornedObject.minHeight);
			}
			if (!isNaN(adornedObject.maxWidth)) 
			{
				resizeX = Math.min(resizeX, adornedObject.maxWidth);
			}
			if (!isNaN(adornedObject.maxHeight)) 
			{
				resizeY = Math.min(resizeY, adornedObject.maxHeight);
			}
			
			resizeX = Math.max(resizeX, 10);
			resizeY = Math.max(resizeY, 10);
			adornedObject.width = resizeX;
			adornedObject.height = resizeY;
		}
		
		override protected function isHandle(object:Object):Boolean
		{
			if(object is Handle)
				return true;
			return super.isHandle(object);
		}
	}
}