package com.hjx.diagram.editor
{
	import com.hjx.graphic.Link;
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
		
		public static function drawLineArrow(adorner:Adorner,displayObject:DisplayObject,event:MouseEvent,fP:Point,tP:Point,reverse:Boolean= false):void{
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