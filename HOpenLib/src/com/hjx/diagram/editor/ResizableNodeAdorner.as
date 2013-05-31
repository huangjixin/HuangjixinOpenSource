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
			/*var loc1:*=NaN;
			var loc2:*=NaN;
			var loc3:*=NaN;
			var loc4:*=NaN;
			var loc5:*=null;
			var loc6:*=null;
			var loc7:*=NaN;
			var loc8:*=NaN;
			var loc9:*=NaN;
			var loc10:*=NaN;*/
			if (this.isResizeHandle(displayObject)) 
			{
				/*if (!editor.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_RESIZE, adornedObject)) 
				{
					return;
				}
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
				}*/
				//对所有的选中节点进行缩放和位置调整。
				var selectedObjs:Vector.<Renderer> = this.editor.getSelectedObjects();
				for each (var renderer:Renderer in selectedObjs) 
				{
					var adornerClass:* = renderer.getStyle("adornerClass");
					if(undefined != adornerClass && new adornerClass(renderer) is ResizableNodeAdorner){
						var offsetWidth:Number = 0;
						var offsetHeight:Number = 0;
						var rect:Rectangle = getAdornerRectangle(graph);
						var changedRect:Rectangle;
						if(displayObject == bottomRightHandle){
							resizeAdornedObject(renderer,offsetX, offsetY);
							changedRect = getAdornerRectangle(graph);
						}else if(displayObject == topLeftHandle){
							resizeAdornedObject(renderer,-offsetX, -offsetY);
							translateAdornedObject(renderer,offsetX, offsetY);
						}else if(displayObject == bottomLeftHandle){
							resizeAdornedObject(renderer,-offsetX, offsetY);
							translateAdornedObject(renderer,offsetX, 0);
						}else if(displayObject == topRightHandle){
							resizeAdornedObject(renderer,offsetX, -offsetY);
							translateAdornedObject(renderer,0, offsetY);
						}
						editor.validateNow();
					}
				}
				
				/*var offsetWidth:Number = 0;
				var offsetHeight:Number = 0;
				var rect:Rectangle = getAdornerRectangle(graph);
				var changedRect:Rectangle;
				if(displayObject == bottomRightHandle){
					resizeAdornedObject(this.adornedObject,offsetX, offsetY);
					changedRect = getAdornerRectangle(graph);
				}else if(displayObject == topLeftHandle){
					resizeAdornedObject(this.adornedObject,-offsetX, -offsetY);
					translateAdornedObject(this.adornedObject,offsetX, offsetY);
				}else if(displayObject == bottomLeftHandle){
					resizeAdornedObject(this.adornedObject,-offsetX, offsetY);
					translateAdornedObject(this.adornedObject,offsetX, 0);
				}else if(displayObject == topRightHandle){
					resizeAdornedObject(this.adornedObject,offsetX, -offsetY);
					translateAdornedObject(this.adornedObject,0, offsetY);
				}
				editor.validateNow();*/
			}
			else 
			{
				super.handleDragged(displayObject, event, offsetX, offsetY);
			}
		}
		
		protected function translateAdornedObject(adornedObject:Renderer,offsetX:Number, offsetY:Number):void
		{
			if(adornedObject.width>20){
				adornedObject.setX(adornedObject,adornedObject.getX(adornedObject)+offsetX);
			}
			if(adornedObject.height>20){
				adornedObject.setY(adornedObject,adornedObject.getY(adornedObject)+offsetY);
			}
			
			return;
		}
		
		protected function resizeAdornedObject(adornedObject:Renderer,offsetX:Number, offsetY:Number):void
		{
			var newWidth:Number=adornedObject.width + offsetX;
			var newHeight:Number=adornedObject.height + offsetY;
			
			if (!isNaN(adornedObject.minWidth)) 
			{
				newWidth = Math.max(newWidth, adornedObject.minWidth);
			}
			if (!isNaN(adornedObject.minHeight)) 
			{
				newHeight = Math.max(newHeight, adornedObject.minHeight);
			}
			if (!isNaN(adornedObject.maxWidth)) 
			{
				newWidth = Math.min(newWidth, adornedObject.maxWidth);
			}
			if (!isNaN(adornedObject.maxHeight)) 
			{
				newHeight = Math.min(newHeight, adornedObject.maxHeight);
			}
			
			newWidth = Math.max(newWidth, 20);
			newHeight = Math.max(newHeight, 20);
			adornedObject.width = newWidth;
			adornedObject.height = newHeight;
		}
		
		override protected function isHandle(object:Object):Boolean
		{
			if(object is ResizeHandle)
				return true;
			return super.isHandle(object);
		}
	}
}