package com.bingya.common
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.BitmapAsset;
	import mx.core.DragSource;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.effects.Parallel;
	import mx.events.DragEvent;
	import mx.events.SandboxMouseEvent;
	import mx.graphics.ImageSnapshot;
	import mx.managers.DragManager;
	
	import spark.components.Image;
	import spark.components.supportClasses.ItemRenderer;
	import spark.effects.Move;
	
	public class DashBoardRenderer extends ItemRenderer
	{
		private var startX:Number;  
		private var startY:Number;
		
		public  static const DRAG_DROP_FORMAT:String = "DashBoardRenderer_format";

		private var marquee:Rectangle; 
		
		public function DashBoardRenderer()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			this.addEventListener(DragEvent.DRAG_ENTER, this.dragEnterHandler);
			this.addEventListener(DragEvent.DRAG_DROP, this.dragDropHandler);
		}
		
		/**
		 * 拖拽enter的时候 
		 * @param arg1
		 * 
		 */
		internal function dragEnterHandler(event:DragEvent):void
		{
			if (event.dragSource.hasFormat(DRAG_DROP_FORMAT))
			{
				DragManager.acceptDragDrop(this);
			}
		}
		
		internal function dragDropHandler(event:DragEvent):void
		{
			
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			var displayObject:DisplayObject = systemManager.getSandboxRoot();  
			displayObject.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);  
			displayObject.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);  
			displayObject.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);  
			displayObject.addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);  
			systemManager.deployMouseShields(true); 

//			this.startDrag();
			
			startX = this.x;  
			startY = this.y;
			
			var dragSource:DragSource = null;
			dragSource = new DragSource();
			var obj:Object = {};
			var dragImage:IFlexDisplayObject=null;
			var bitMapData:BitmapData = ImageSnapshot.captureBitmapData(this);
			var image:Image = new Image();
			image.source = new BitmapAsset(bitMapData)
			dragSource.addData(obj,DashBoardRenderer.DRAG_DROP_FORMAT);
			DragManager.doDrag(this as UIComponent, dragSource,event,image);
		}
		
		protected function mouseDragHandler(event:MouseEvent):void  
		{
			/*if(!marquee){
				marquee = new Rectangle(0,0,width,height);
			}
			
			if(marquee.contains(this.mouseX,this.mouseY)){
				graphics.lineStyle(2,0xff0000);
				graphics.drawRect(-2,-2,width+2,height+2);
				
			}else{
				graphics.clear();
			}*/
		}  

		protected function mouseUpHandler(event:MouseEvent):void  
		{
			this.stopDrag();
			
			/**/
			
			var objectsUnderPoint:Array = this.stage.getObjectsUnderPoint(new Point(event.stageX, event.stageY));
			var length:int = (objectsUnderPoint.length - 1);
			var dashBoardRenderer:DashBoardRenderer;
			while (length >= 0) 
			{
				dashBoardRenderer = objectsUnderPoint[length] as  DashBoardRenderer;
				if(dashBoardRenderer && dashBoardRenderer != this){
					
					break;
				}
				--length;
				dashBoardRenderer = null;
			}
			
			if(dashBoardRenderer){
				this.x = dashBoardRenderer.x;
				this.y = dashBoardRenderer.y;
				
				dashBoardRenderer.x = this.startX;
				dashBoardRenderer.y = this.startY;
				var dashBoardEvent:DashBoardEvent = new DashBoardEvent(DashBoardEvent.INDEX_CHANGE);
				dashBoardEvent.dashrenderer0 = this;
				dashBoardEvent.dashrenderer1 = dashBoardRenderer;
				dispatchEvent(dashBoardEvent );
			}else{
				this.x = startX;  
				this.y = startY;
			}
			
			marquee = null;
			
			var displayObject:DisplayObject=systemManager.getSandboxRoot();  
			displayObject.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);  
			displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);  
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);  
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);  
			systemManager.deployMouseShields(false);
		}  

	}
}