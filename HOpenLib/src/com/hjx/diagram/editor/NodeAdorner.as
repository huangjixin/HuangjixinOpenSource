package com.hjx.diagram.editor
{
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.Link;
	import com.hjx.graphic.LinkConnectionArea;
	import com.hjx.graphic.Node;
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElementContainer;
	
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
		
		private var link:Link;
		private var toBeAddedPalette:ToBeAddedPalette;
		
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
			var isNear:Boolean = rightArrowHandle.visible=topArrowHandle.visible=bottomArrowHandle.visible=leftArrowHandle.visible
				= isMouseNear(toBeAddedPalette?Math.min(toBeAddedPalette.width,toBeAddedPalette.height):8);
		}
		
		internal function isArrowHandle(object:Object):Boolean
		{
			return object == this.rightArrowHandle
				|| object == this.topArrowHandle
				|| object == this.bottomArrowHandle
				|| object == this.leftArrowHandle;
		}
		
		override protected function handlePressed(displayObject:DisplayObject, event:MouseEvent):void
		{
			if (this.isArrowHandle(displayObject)) 
			{
				
			}else{
				super.handlePressed(displayObject, event);
			}
		}
		
		internal function createToBeAddedPalette():ToBeAddedPalette
		{
			var toBeAddedPalette:* = adornedObject.getStyle("toBeAddedPalette");
			if(toBeAddedPalette){
				return new toBeAddedPalette();
			}
			return null;
		}
		
		override protected function handleMouseOver(displayObject:DisplayObject, event:MouseEvent):void
		{
				
			/*if(!toBeAddedPalette){
				toBeAddedPalette = createToBeAddedPalette();
			}
			if(!toBeAddedPalette){
				return;
			}
			
//			editor.adornersGroup.addElement(toBeAddedPalette);
			
			var rect:Rectangle;
			if(displayObject == rightArrowHandle){
				toBeAddedPalette.isVertical = true;
				rect = adornedObject.getBounds(editor.adornersGroup);
				toBeAddedPalette.x = rect.x+rect.width+10;
				toBeAddedPalette.y = rect.y-toBeAddedPalette.height/2;
			}else if(displayObject == topArrowHandle){
				rect = adornedObject.getBounds(editor.adornersGroup);
				toBeAddedPalette.x = rect.x-toBeAddedPalette.width/2+rect.width/2;
				toBeAddedPalette.y = rect.y-rect.height-toBeAddedPalette.height;
				toBeAddedPalette.isVertical = false;
			}
			
			if(!rect){
				return;
			}*/
			
			
		}
		
		/**
		 * 处理拖拽的情况。 
		 * @param displayObject
		 * @param event
		 * @param offsetX
		 * @param offsetY
		 * 
		 */
		override protected function handleDragged(displayObject:DisplayObject, event:MouseEvent, offsetX:Number, offsetY:Number):void
		{
			if (this.isArrowHandle(displayObject)) 
			{
				var adornerObjectRect:Rectangle = this.adornedObject.getBounds(editor.adornersGroup);
				var displayObjectRect:Rectangle = displayObject.getBounds(editor.adornersGroup);
				var fP:Point = new Point(displayObjectRect.x+displayObjectRect.width/2,displayObjectRect.y+displayObjectRect.height/2);
				var tP:Point = new Point(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY);
				LinkHelper.drawLineArrow(this,displayObject,event,fP,tP);
			}else{
				super.handleDragged(displayObject, event, offsetX, offsetY);
			}
		}
		
		/**
		 * 判断鼠标是否在节点下放开，如果是就连线节点。 
		 * @param displayObject
		 * @param event
		 * 
		 */
		override protected function handleReleased(displayObject:DisplayObject, event:MouseEvent):void
		{
			if (this.isArrowHandle(displayObject)) 
			{
				var editor:DiagramEditor = DiagramEditor.getEditor(this);
				if(!editor){
					return;
				}
				
				editor.adornersGroup.graphics.clear();
				var renderer:Renderer = trackCurrentRenderer(event);
				var startNodeConnectingArea:String = LinkConnectionArea.CENTER;
				var endNodeConnectingArea:String = LinkConnectionArea.CENTER;
				var link:Link;
				var linkParent:Graph;
				
				if(displayObject == this.topArrowHandle){
					startNodeConnectingArea = LinkConnectionArea.TOP;
				}else if(displayObject == this.rightArrowHandle){
					startNodeConnectingArea = LinkConnectionArea.RIGHT;
				}else if(displayObject == this.bottomArrowHandle){
					startNodeConnectingArea = LinkConnectionArea.BOTTOM;
				}else if(displayObject == this.leftArrowHandle){
					startNodeConnectingArea = LinkConnectionArea.LEFT;
				}else{
					startNodeConnectingArea = LinkConnectionArea.CENTER;
				}
				
				//如果放到节点上面就创建连线。
				if(renderer){
					if(renderer is Link){
						return ;
					}
					var node:Node = renderer as Node;
					var nodeRect:Rectangle = node.getBounds(editor.adornersGroup);
					var nodeTopRect:Rectangle = new Rectangle(nodeRect.x + nodeRect.width/3,nodeRect.y,nodeRect.width/3,nodeRect.height/3);
					var nodeBottomRect:Rectangle = new Rectangle(nodeRect.x + nodeRect.width/3,nodeRect.y+nodeRect.height*2/3,nodeRect.width/3,nodeRect.height/3);
					var nodeLeftRect:Rectangle = new Rectangle(nodeRect.x,nodeRect.y+nodeRect.height/3,nodeRect.width/3,nodeRect.height/3);
					var nodeRightRect:Rectangle = new Rectangle(nodeRect.x + nodeRect.width*2/3,nodeRect.y+nodeRect.height/3,nodeRect.width/3,nodeRect.height/3);
					var rect:Rectangle;
					var flag:int = -1;
					if(nodeTopRect.contains(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY)){
						rect = nodeTopRect;
						flag = 0;
					}else if(nodeBottomRect.contains(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY)){
						rect = nodeBottomRect;
						flag = 2;
					}else if(nodeLeftRect.contains(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY)){
						rect = nodeLeftRect;
						flag = 3;
					}else if(nodeRightRect.contains(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY)){
						rect = nodeRightRect;
						flag = 1;
					}else{
						rect = nodeRect;
						flag = 4;
					}
					
					if(flag ==0){
						endNodeConnectingArea = LinkConnectionArea.TOP;
					}else if(flag ==1){
						endNodeConnectingArea = LinkConnectionArea.RIGHT;
					}else if(flag ==2){
						endNodeConnectingArea = LinkConnectionArea.BOTTOM;
					}else if(flag ==3){
						endNodeConnectingArea = LinkConnectionArea.LEFT;
					}else if(flag ==4){
						endNodeConnectingArea = LinkConnectionArea.CENTER;
					}
					
					link = editor.createLink(startNodeConnectingArea,endNodeConnectingArea);
					if (link) {
						link.startNode = adornedObject as Node;
						link.endNode = renderer as Node;
						linkParent = DiagramEditor.getLowestCommonGraph(link.startNode, link.endNode);
						linkParent.addElement(link);
						link.invalidateShape();
					} 
				}else{
					link = editor.createLink(startNodeConnectingArea,endNodeConnectingArea);
					if (link) {
						link.startNode = adornedObject as Node;
						linkParent = DiagramEditor.getLowestCommonGraph(link.startNode, link.startNode);
						linkParent.addElement(link);
						var point:Point = new Point(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY);
						point = editor.adornersGroup.localToGlobal(point);
						point = link.globalToLocal(point);
						link.fallbackEndPoint = point;
						link.invalidateShape();
					}
				}
			}else{
				super.handleReleased(displayObject, event);
			}
		}
		
		internal function trackCurrentRenderer(event:MouseEvent):Renderer
		{
			var renderer:Renderer=null;
			var flag:Boolean =false;
			var objectsUnderPoint:Array = this.stage.getObjectsUnderPoint(new Point(event.stageX, event.stageY));
			var length:int = (objectsUnderPoint.length - 1);
			while (length >= 0) 
			{
				renderer = DiagramEditor.getRenderer(objectsUnderPoint[length]) as Renderer;
				
				if (renderer && DiagramEditor.getEditor(renderer)) 
				{
					return renderer;
				}
				--length;
			}
			return renderer;
		}
		
		override protected function cleanup():void
		{
			/*if(toBeAddedPalette){
				IVisualElementContainer(toBeAddedPalette.parent).removeElement(toBeAddedPalette);
				toBeAddedPalette = null;
			}*/
			super.cleanup();
		}
	}
}