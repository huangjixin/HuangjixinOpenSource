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

	public class LinkHelper
	{
		public function LinkHelper()
		{
		}
		
		public static function handleDragged(adorner:Adorner,displayObject:DisplayObject,event:MouseEvent,fP:Point,tP:Point,reverse:Boolean= false):void{
			var editor:DiagramEditor = DiagramEditor.getEditor(adorner);
			if(!editor){
				return;
			}
			
			editor.adornersGroup.graphics.clear();
			editor.adornersGroup.graphics.lineStyle(2,0,0.5);
			
			//绘制箭头。
			var g:Graphics = editor.adornersGroup.graphics;
			
			var lArrowBase:Point;
			var rArrowBase:Point;
			var mArrowBase:Point;
			
			var edgeAngle:Number;
			if(reverse){
				var po:Point = new Point();
				po = fP;
				fP = tP;
				tP = po;
			}
			edgeAngle = Math.atan2(tP.y - fP.y,tP.x - fP.x);
			mArrowBase = Point.polar(Point.distance(tP,fP) - 10,edgeAngle);
			mArrowBase.offset(fP.x,fP.y);
			
			lArrowBase = Point.polar(10 / 2.9,(edgeAngle - (Math.PI / 2.0)));
			rArrowBase = Point.polar(10 / 2.9,(edgeAngle + (Math.PI / 2.0)));
			
			lArrowBase.offset(mArrowBase.x,mArrowBase.y);			
			rArrowBase.offset(mArrowBase.x,mArrowBase.y);
			
			g.beginFill(0,0.3);
			g.moveTo(fP.x, fP.y);
			g.lineTo(tP.x, tP.y);
			g.lineTo(lArrowBase.x, lArrowBase.y);
			g.lineTo(rArrowBase.x, rArrowBase.y);
			g.lineTo(tP.x, tP.y);
			g.endFill();
			
			//找当前的节点，根据鼠标位置绘制红色框。
			var renderer:Renderer = trackCurrentRenderer(adorner,event);
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
		}
		
		public static function handleReleased(adorner:Adorner,displayObject:DisplayObject,
											 event:MouseEvent,
											 reverse:Boolean= false):void{
			var editor:DiagramEditor = DiagramEditor.getEditor(adorner);
			if(!editor){
				return;
			}
			
			editor.adornersGroup.graphics.clear();
			var renderer:Renderer = LinkHelper.trackCurrentRenderer(adorner,event);
			
			var startNodeConnectingArea:String = LinkConnectionArea.CENTER;
			var endNodeConnectingArea:String = LinkConnectionArea.CENTER;
			
			var linkParent:Graph;
			//判断一下是哪个类型的边饰器。
			var adornedNode:Node;
			var adornedLink:Link;
			
			if (adorner.adornedObject is Node) 
			{
				adornedNode = adorner.adornedObject as Node;
			}
			else if (adorner.adornedObject is Link) 
			{
				adornedLink = adorner.adornedObject as Link;
			}
			
			if(adornedNode){
				var nodeAdorner:NodeAdorner = adorner as NodeAdorner;
				if(!nodeAdorner){
					return;
				}
				
				if(displayObject == nodeAdorner.topArrowHandle){
					startNodeConnectingArea = LinkConnectionArea.TOP;
				}else if(displayObject == nodeAdorner.rightArrowHandle){
					startNodeConnectingArea = LinkConnectionArea.RIGHT;
				}else if(displayObject == nodeAdorner.bottomArrowHandle){
					startNodeConnectingArea = LinkConnectionArea.BOTTOM;
				}else if(displayObject == nodeAdorner.leftArrowHandle){
					startNodeConnectingArea = LinkConnectionArea.LEFT;
				}else{
					startNodeConnectingArea = LinkConnectionArea.CENTER;
				}
				
				
			}else if(adornedLink){
				var linkAdorner:LinkAdorner = adorner as LinkAdorner;
				if(!linkAdorner){
					return;
				}
				
				startNodeConnectingArea = adornedLink.startConnectionArea;
				endNodeConnectingArea = adornedLink.endConnectionArea;
				var isStart:Boolean= true;
				if(displayObject == linkAdorner.endHandle){
					adornedNode = adornedLink.startNode;
				}else if(displayObject == linkAdorner.startHandle){
					adornedNode = adornedLink.endNode;
					isStart = false;
				}
			}
			
			//如果放到节点上面就创建连线。
			if(renderer){
				if(renderer is Link){
					return ;
				}
				
				var dragReleaseNode:Node = renderer as Node;
				var nodeRect:Rectangle = dragReleaseNode.getBounds(editor.adornersGroup);
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
				
				if(adornedNode && !adornedLink){
					adornedLink = editor.createLink(startNodeConnectingArea,endNodeConnectingArea);
					if (adornedLink) {
						
						if(flag == 0){
							endNodeConnectingArea= LinkConnectionArea.TOP;
						}else if(flag == 2){
							endNodeConnectingArea= LinkConnectionArea.BOTTOM;
						}else if(flag == 3){
							endNodeConnectingArea= LinkConnectionArea.LEFT;
						}else if(flag == 1){
							endNodeConnectingArea= LinkConnectionArea.RIGHT;
						}else if(flag == 4){
							endNodeConnectingArea= LinkConnectionArea.CENTER;
						}
						
						adornedLink.startConnectionArea = startNodeConnectingArea;
						adornedLink.endConnectionArea = endNodeConnectingArea;
						adornedLink.startNode = adornedNode;
						adornedLink.endNode = renderer as Node;
						linkParent = DiagramEditor.getLowestCommonGraph(adornedLink.startNode, adornedLink.endNode);
						linkParent.addElement(adornedLink);
						
						adornedLink.invalidateProperties();
						adornedLink.invalidateShape();
					} 				
				}else if(adornedLink){
					if(flag == 0){
						isStart? endNodeConnectingArea= LinkConnectionArea.TOP: startNodeConnectingArea= LinkConnectionArea.TOP;
					}else if(flag == 2){
						isStart? endNodeConnectingArea= LinkConnectionArea.BOTTOM: startNodeConnectingArea= LinkConnectionArea.BOTTOM;
					}else if(flag == 3){
						isStart? endNodeConnectingArea= LinkConnectionArea.LEFT: startNodeConnectingArea= LinkConnectionArea.LEFT;
					}else if(flag == 1){
						isStart?endNodeConnectingArea = LinkConnectionArea.RIGHT: startNodeConnectingArea= LinkConnectionArea.RIGHT;
					}else if(flag == 4){
						isStart?endNodeConnectingArea = LinkConnectionArea.CENTER: startNodeConnectingArea= LinkConnectionArea.CENTER;
					}
					
					if(displayObject == linkAdorner.endHandle){
						adornedLink.endNode = renderer as Node;
						adornedLink.endConnectionArea = endNodeConnectingArea;
					}else if(displayObject == linkAdorner.startHandle){
						adornedLink.startNode = renderer as Node;
						adornedLink.startConnectionArea = startNodeConnectingArea;
					}
					
					linkParent = DiagramEditor.getLowestCommonGraph(adornedLink.startNode?adornedLink.startNode:adornedLink, adornedLink.endNode?adornedLink.endNode:adornedLink);
					linkParent.addElement(adornedLink);
					adornedLink.invalidateProperties();
					adornedLink.invalidateShape();
				}
			}else{
				var point:Point;
				
				if(adornedNode && !adornedLink){
					adornedLink = editor.createLink(startNodeConnectingArea,endNodeConnectingArea);
					if (adornedLink) {
						adornedLink.startNode = adornedNode;
						linkParent = DiagramEditor.getLowestCommonGraph(adornedLink.startNode, adornedLink.startNode);
						linkParent.addElement(adornedLink);
						point = new Point(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY);
						point = editor.adornersGroup.localToGlobal(point);
						point = adornedLink.globalToLocal(point);
						adornedLink.fallbackEndPoint = point;
						adornedLink.invalidateProperties();
						adornedLink.invalidateShape();
					} 				
				}else if(adornedLink){
					point = new Point(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY);
					point = editor.adornersGroup.localToGlobal(point);
					point = adornedLink.globalToLocal(point);
					if(isStart){
						adornedLink.endNode = null;
						adornedLink.endConnectionArea = LinkConnectionArea.CENTER;
						adornedLink.fallbackEndPoint = point;					
					}else{
						adornedLink.startNode = null;
						adornedLink.startConnectionArea = LinkConnectionArea.CENTER;
						adornedLink.fallbackStartPoint = point;
					}

//					adornedLink.invalidateShape();
					adornedLink.invalidateProperties();
				}
			}
			if(adornedLink){
//				editor.deselectAllExcept(adornedLink);
//				adornedLink.invalidateShape();
//				editor.deselectAll();
			}
		}
		
		internal static function trackCurrentRenderer(adorner:Adorner,event:MouseEvent):Renderer
		{
			var renderer:Renderer=null;
			var flag:Boolean =false;
			var objectsUnderPoint:Array = adorner.stage.getObjectsUnderPoint(new Point(event.stageX, event.stageY));
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