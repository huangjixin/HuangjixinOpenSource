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
		
		override protected function handleDragged(displayObject:DisplayObject, event:MouseEvent, offsetX:Number, offsetY:Number):void
		{
			if (this.isArrowHandle(displayObject)) 
			{
				var editor:DiagramEditor = DiagramEditor.getEditor(this);
				if(!editor){
					return;
				}
				
				var adornerObjectRect:Rectangle = this.adornedObject.getBounds(editor.adornersGroup);
				var displayObjectRect:Rectangle = displayObject.getBounds(editor.adornersGroup);
				
				editor.adornersGroup.graphics.clear();
				editor.adornersGroup.graphics.lineStyle(2,0);
				
				
				var g:Graphics = editor.adornersGroup.graphics;
				
				var fP:Point = new Point(displayObjectRect.x+displayObjectRect.width/2,displayObjectRect.y+displayObjectRect.height/2);
				var tP:Point = new Point(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY);
				
				var lArrowBase:Point;
				var rArrowBase:Point;
				var mArrowBase:Point;
				
				var edgeAngle:Number;
				
				edgeAngle = Math.atan2(tP.y - fP.y,tP.x - fP.x);
				mArrowBase = Point.polar(Point.distance(tP,fP) - 10,edgeAngle);
				mArrowBase.offset(fP.x,fP.y);
				
				lArrowBase = Point.polar(10 / 2.9,(edgeAngle - (Math.PI / 2.0)));
				rArrowBase = Point.polar(10 / 2.9,(edgeAngle + (Math.PI / 2.0)));
				
				lArrowBase.offset(mArrowBase.x,mArrowBase.y);			
				rArrowBase.offset(mArrowBase.x,mArrowBase.y);
				
				g.beginFill(0);
				g.moveTo(fP.x, fP.y);
				g.lineTo(tP.x, tP.y);
				g.lineTo(lArrowBase.x, lArrowBase.y);
				g.lineTo(rArrowBase.x, rArrowBase.y);
				g.lineTo(tP.x, tP.y);
				g.endFill();
				
				
				var renderer:Renderer = trackCurrentRenderer(event);
				if(renderer){
					if(renderer is Link){
						return ;
					}
					var node:Node = renderer as Node;
					editor.adornersGroup.graphics.lineStyle(2,0xff0000);
					var nodeRect:Rectangle = node.getBounds(editor.adornersGroup);
					var nodeTopRect:Rectangle = new Rectangle(nodeRect.x + nodeRect.width/3,nodeRect.y,nodeRect.width/3,nodeRect.height/3);
					var nodeBottomRect:Rectangle = new Rectangle(nodeRect.x + nodeRect.width/3,nodeRect.y+nodeRect.height*2/3,nodeRect.width/3,nodeRect.height/3);
					var nodeLeftRect:Rectangle = new Rectangle(nodeRect.x,nodeRect.y+nodeRect.height/3,nodeRect.width/3,nodeRect.height/3);
					var nodeRightRect:Rectangle = new Rectangle(nodeRect.x + nodeRect.width*2/3,nodeRect.y+nodeRect.height/3,nodeRect.width/3,nodeRect.height/3);
					var rect:Rectangle;
					if(nodeTopRect.contains(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY)){
						rect = nodeTopRect;
					}else if(nodeBottomRect.contains(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY)){
						rect = nodeBottomRect;
					}else if(nodeLeftRect.contains(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY)){
						rect = nodeLeftRect;
					}else if(nodeRightRect.contains(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY)){
						rect = nodeRightRect;
					}else{
						rect = nodeRect;
					}
					
					editor.adornersGroup.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
				}
			}else{
				super.handleDragged(displayObject, event, offsetX, offsetY);
			}
		}
		
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
					
					var startNodeConnectingArea:String = LinkConnectionArea.CENTER;
					var endNodeConnectingArea:String = LinkConnectionArea.CENTER;
					
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
					
					var link:Link = editor.createLink(startNodeConnectingArea,endNodeConnectingArea);
					if (link) {
						link.startNode = adornedObject as Node;
						link.endNode = renderer as Node;
						var linkParent:Graph = DiagramEditor.getLowestCommonGraph(link.startNode, link.endNode);
						linkParent.addElement(link);
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
	}
}