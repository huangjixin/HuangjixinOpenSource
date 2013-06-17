package com.hjx.diagram.editor
{
	import com.hjx.graphic.Link;
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class LinkAdorner extends Adorner
	{
		[SkinPart]
		public var startHandle:LinkConnectionHandle;
		[SkinPart]
		public var endHandle:LinkConnectionHandle;
		
		private var _startHandleX:Number;
		
		private var _startHandleY:Number;
		
		private var _startHandleRotation:Number;
		
		private var _endHandleX:Number;
		
		private var _endHandleY:Number;
		
		private var _endHandleRotation:Number;
		
		public function LinkAdorner(adornedObject:Renderer)
		{
			super(adornedObject);
		}
		
		[Bindable]
		public function get endHandleRotation():Number
		{
			return _endHandleRotation;
		}

		public function set endHandleRotation(value:Number):void
		{
			_endHandleRotation = value;
		}
		[Bindable]
		public function get endHandleY():Number
		{
			return _endHandleY;
		}

		public function set endHandleY(value:Number):void
		{
			_endHandleY = value;
		}
		[Bindable]
		public function get endHandleX():Number
		{
			return _endHandleX;
		}

		public function set endHandleX(value:Number):void
		{
			_endHandleX = value;
		}
		[Bindable]
		public function get startHandleRotation():Number
		{
			return _startHandleRotation;
		}

		public function set startHandleRotation(value:Number):void
		{
			_startHandleRotation = value;
		}
		[Bindable]
		public function get startHandleY():Number
		{
			return _startHandleY;
		}

		public function set startHandleY(value:Number):void
		{
			_startHandleY = value;
		}
		[Bindable]
		public function get startHandleX():Number
		{
			return _startHandleX;
		}

		public function set startHandleX(value:Number):void
		{
			_startHandleX = value;
		}

		internal function isReconnectHandle(obj:Object):Boolean
		{
			return obj == this.startHandle || obj == this.endHandle;
		}
		
		protected override function isHandle(arg1:Object):Boolean
		{
			if (this.isReconnectHandle(arg1)) 
			{
				return true;
			}
			return super.isHandle(arg1);
		}
		
		public function placeHandleObject():void{
			var link:Link=null;
			var shapePoints:Vector.<Point>;
			
			if (parent != null) 
			{
				link = Link(adornedObject);
				shapePoints = link.shapePoints;
				if (shapePoints.length >= 2) 
				{
					this.placeHandle(shapePoints[1], shapePoints[0], true);
					this.placeHandle(shapePoints[shapePoints.length - 2], shapePoints[(shapePoints.length - 1)], false);
				}
			}
		}
		
		protected override function partAdded(partName:String, instance:Object):void
		{
			/*var loc1:*=null;*/
			super.partAdded(partName, instance);
			if (this.isReconnectHandle(instance)) 
			{
				/*loc1 = com.ibm.ilog.elixir.diagram.editor.DiagramEditor.getEditor(this);
				if (!(loc1 == null) && !(loc1.allowReconnectingLinks && loc1.allowCreatingLinks) && arg2 is flash.display.DisplayObject) 
				{
					flash.display.DisplayObject(arg2).visible = false;
				}*/
			}
			return;
		}
		
		protected override function commitProperties():void
		{
			var link:Link=null;
			var shapePoints:Vector.<Point>;
			super.commitProperties();
			if (parent != null) 
			{
				link = Link(adornedObject);
				shapePoints = link.shapePoints;
				if (shapePoints.length >= 2) 
				{
					this.placeHandle(shapePoints[1], shapePoints[0], true);
					this.placeHandle(shapePoints[shapePoints.length - 2], shapePoints[(shapePoints.length - 1)], false);
					/*this.placeHandle(link.fallbackEndPoint, link.fallbackStartPoint, true);
					this.placeHandle(link.fallbackStartPoint,link.fallbackEndPoint, false);*/
				}
				/*this.startHandleX = link.x;
				this.startHandleY = link.y;
				this.endHandleX = link.path.measuredWidth;
				this.endHandleY = link.path.measuredHeight;
				trace(link.path.measuredWidth+","+link.path.measuredHeight);
				var point:Point = new Point(endHandleX,endHandleY);
				point = link.path.localToGlobal(point);
				point = this.globalToLocal(point);*/
				/*var fallbackStartPoint:Point = link.fallbackStartPoint;
				fallbackStartPoint = link.path.parent.localToGlobal(fallbackStartPoint);
				fallbackStartPoint = this.parent.globalToLocal(fallbackStartPoint);
				this.startHandleX = fallbackStartPoint.x;
				this.startHandleY = fallbackStartPoint.y;*/
				
				
				/*var fallbackEndPoint:Point = link.fallbackEndPoint;*/
				
//				trace(fallbackEndPoint);
				/*fallbackEndPoint = link.parent.localToGlobal(fallbackEndPoint);
				fallbackEndPoint = this.globalToLocal(fallbackEndPoint);
				this.endHandleX = fallbackEndPoint.x;
				this.endHandleY = fallbackEndPoint.y;*/
//				trace(fallbackEndPoint);
				/*trace(link.x+link.y);
				trace(link.fallbackStartPoint+","+link.fallbackEndPoint);
				trace(this.startHandleX+","+this.startHandleY+";"+this.endHandleX+","+this.endHandleY);*/
			}
			return;
		}
		
		internal function placeHandle(startPoint:Point, endPoint:Point, isStartHandle:Boolean):void
		{
			var radian:Number = Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x) * 180 / Math.PI;
			var link:Link = Link(adornedObject);
			endPoint = this.globalToLocal(link.parent.localToGlobal(endPoint));
			if (isStartHandle) 
			{
				this.startHandleX = endPoint.x;
				this.startHandleY = endPoint.y;
				this.startHandleRotation = radian-(45)*180/Math.PI;
			}
			else 
			{
				this.endHandleX = endPoint.x;
				this.endHandleY = endPoint.y;
				this.endHandleRotation = radian-(45)*180/Math.PI;;
			}
			return;
		}
		
		/*protected override function handlePressed(arg1:flash.display.DisplayObject, arg2:flash.events.MouseEvent):void
		{
			if (this.isReconnectHandle(arg1)) 
			{
				if (this.linkConnectionHelper == null) 
				{
					this.linkConnectionHelper = new LinkConnectionHelper(editor, com.ibm.ilog.elixir.diagram.Link(adornedObject), arg1 == this.startHandle);
				}
				this.linkConnectionHelper.handlePressed(arg1, arg2);
			}
			super.handlePressed(arg1, arg2);
			return;
		}*/
		
		protected override function handleDragged(displayObject:DisplayObject, event:MouseEvent, offsetX:Number, offsetY:Number):void
		{
			if (this.isReconnectHandle(displayObject)) 
			{
				var adornerObjectRect:Rectangle = this.adornedObject.getBounds(editor.adornersGroup);
				var displayObjectRect:Rectangle = displayObject.getBounds(editor.adornersGroup);
				var fP:Point;
				var tP:Point;
				
				if(displayObject ==startHandle){
					fP = Link(adornedObject).fallbackEndPoint;
					tP = new Point(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY);
					LinkHelper.handleDragged(this,displayObject,event,fP,tP,true);
				}else if(displayObject == endHandle){
					fP = Link(adornedObject).fallbackStartPoint;
					tP = new Point(editor.adornersGroup.mouseX,editor.adornersGroup.mouseY);
					LinkHelper.handleDragged(this,displayObject,event,fP,tP);
				}
				
			}else{
				super.handleDragged(displayObject, event, offsetX, offsetY);
			}
			return;
		}
		
		protected override function handleReleased(displayObject:DisplayObject, event:MouseEvent):void
		{
			if (this.isReconnectHandle(displayObject)) 
			{
				LinkHelper.handleReleased(this,displayObject,event);
				var editor:DiagramEditor = DiagramEditor.getEditor(this);
				if(!editor){
					return;
				}
				callLater(function dels():void{editor.deselectAll()});
			}
			else 
			{
				super.handleReleased(displayObject, event);
			}
			return;
		}

	}
}