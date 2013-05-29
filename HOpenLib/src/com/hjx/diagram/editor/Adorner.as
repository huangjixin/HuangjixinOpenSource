package com.hjx.diagram.editor
{
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;

	/**
	 * 边饰器基类。 
	 * @author huangjixin
	 * 
	 */
	public class Adorner extends SkinnableComponent
	{
		private var _adornedObject:Renderer;
		
		internal var _startX:Number;
		
		internal var _startY:Number;
		
		private var _interactiveHandle:DisplayObject;
		
		internal var _mouseDragged:Boolean;
		
		/**
		 * 构造函数。 
		 * @param adornedObject
		 * 
		 */
		public function Adorner(adornedObject:Renderer)
		{
			this._adornedObject = adornedObject;
			adornedObject.addEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.updateCompleteHandler);
			this.addEventListener(flash.events.Event.ADDED, this.addedHandler);
			this.addEventListener(flash.events.Event.REMOVED, this.removedHandler)
		}
		
		public function get interactiveHandle():DisplayObject
		{
			return _interactiveHandle;
		}

		public function set interactiveHandle(value:DisplayObject):void
		{
			_interactiveHandle = value;
			var editor:DiagramEditor= DiagramEditor.getEditor(this);
			if (editor != null) 
			{
				editor.inAdornerInteraction = !(value == null);
			}
		}

		public function get adornedObject():Renderer
		{
			return this._adornedObject;
		}
		
		public function get editor():DiagramEditor
		{
			return DiagramEditor.getEditor(this);
		}
		
		protected function removedHandler(event:Event):void
		{
			if (event.target == this) 
			{
				this.cleanup();
			}
		}
		
		protected function addedHandler(event:Event):void
		{
			if (event.target == this) 
			{
				invalidateProperties();
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onAdornerMouseMove);
			}
		}
		
		protected function updateCompleteHandler(event:FlexEvent):void
		{
			invalidateProperties();
		}
		
		protected function onAdornerMouseMove(event:MouseEvent):void
		{
			trace("sdfds");
		}
		
		/**
		 * 获得边饰相对的矩形框。 
		 * @param displayObject
		 * @return 
		 * 
		 */
		protected function getAdornerRectangle(displayObject:DisplayObject):Rectangle
		{
			return this._adornedObject.getBounds(displayObject);
		}
		
		/**
		 * 清除边饰器。 
		 * 
		 */
		protected function cleanup():void
		{
			this.removeEventListener(flash.events.Event.ADDED, this.addedHandler);
			this.removeEventListener(flash.events.Event.REMOVED, this.removedHandler);
			this.adornedObject.removeEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.updateCompleteHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onAdornerMouseMove);
			return;
		}
		
		/**
		 * 判断是不手柄。，由子类复写。
		 * @param arg1
		 * @return 
		 * 
		 */
		protected function isHandle(object:Object):Boolean
		{
			return false;
		}
		
		/**
		 *  
		 * @param event
		 * 
		 */
		internal function mouseDownInHandle(event:MouseEvent):void
		{
			this.interactiveHandle = DisplayObject(event.currentTarget);
			this.handlePressed(this.interactiveHandle, event);
			this._startX = event.stageX;
			this._startY = event.stageY;
			this._mouseDragged = false;
			event.stopPropagation();
			var displayObject:DisplayObject=systemManager.getSandboxRoot();
			displayObject.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.mouseUpInStage, true);
			displayObject.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.mouseMoveInStage, true);
			displayObject.addEventListener(mx.events.SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpInStage, true);
			displayObject.addEventListener(mx.events.SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseMoveInStage, true);
			systemManager.deployMouseShields(true);
			return;
		}
		
		internal function mouseMoveInStage(event:MouseEvent):void
		{
			if (this.interactiveHandle != null) 
			{
				var stageX:Number = event.stageX;
				var stageY:Number = event.stageY;
				var offsetX:Number = stageX - this._startX;
				var offsetY:Number = stageY - this._startY;
				var startPoint:Point;
				var editor:DiagramEditor = this.editor;;
				if (!this._mouseDragged) 
				{
					if (Math.abs(offsetX) > 2 || Math.abs(offsetY) > 2) 
					{
						this._mouseDragged = true;
						startPoint = new flash.geom.Point(this._startX, this._startY);
						startPoint = editor.snapPoint(startPoint, stage);
						this._startX = startPoint.x;
						this._startY = startPoint.y;
					}
				}
				
				if (this._mouseDragged) 
				{
					var stagePoint:Point = new flash.geom.Point(stageX, stageY);
					stagePoint = editor.graph.globalToLocal(stage.localToGlobal(stagePoint));
					startPoint = editor.graph.globalToLocal(stage.localToGlobal(new flash.geom.Point(this._startX, this._startY)));
					offsetX = stagePoint.x - startPoint.x;
					offsetY = stagePoint.y - startPoint.y;
					this._startX = stageX;
					this._startY = stageY;
					this.handleDragged(this.interactiveHandle, event, offsetX, offsetY);
				}
			}
			
			event.stopPropagation();
			return;
		}
		
		public function isMouseNear(offset:Number):Boolean
		{
			var rect:Rectangle=getBounds(stage);
			rect.x = rect.x - offset;
			rect.y = rect.y - offset;
			rect.width = rect.width + 2 * offset;
			rect.height = rect.height + 2 * offset;
			return rect.contains(stage.mouseX, stage.mouseY);
		}
		
		/*function moveDragPoint(arg1:Number, arg2:Number):void
		{
			var loc1:*=new flash.geom.Point(arg1, arg2);
			var loc2:*=this.editor.graph.localToGlobal(new flash.geom.Point(0, 0));
			loc1 = this.editor.graph.localToGlobal(loc1);
			this._startX = this._startX + (loc1.x - loc2.x);
			this._startY = this._startY + (loc1.y - loc2.y);
			return;
		}*/
		
		protected function handlePressed(displayObject:DisplayObject, event:MouseEvent):void
		{
			event.stopPropagation();
			return;
		}
		
		protected function handleDragged(displayObject:DisplayObject, event:MouseEvent, offsetX:Number, offsetY:Number):void
		{
			return;
		}
		
		internal function mouseUpInStage(event:MouseEvent):void
		{
			if (this.interactiveHandle != null) 
			{
				this.handleReleased(this.interactiveHandle, event);
			}
			this.stopInteraction();
			event.stopPropagation();
			return;
		}
		
		/**
		 * 停止交互。 
		 * 
		 */
		internal function stopInteraction():void
		{
			var displayObject:DisplayObject=null;
			if (this.interactiveHandle != null) 
			{
				this.interactiveHandle = null;
				displayObject = systemManager.getSandboxRoot();
				displayObject.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.mouseUpInStage, true);
				displayObject.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.mouseMoveInStage, true);
				displayObject.removeEventListener(mx.events.SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpInStage, true);
				displayObject.removeEventListener(mx.events.SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseMoveInStage, true);
				systemManager.deployMouseShields(false);
			}
			return;
		}
		
		/**
		 * 手柄放开，由子类继承并复写，实现具体内容。 
		 * @param arg1
		 * @param arg2
		 * 
		 */
		protected function handleReleased(displayObject:DisplayObject, event:MouseEvent):void
		{
			return;
		}
		
		/**
		 * 为手柄添加侦听。 
		 * @param partName
		 * @param instance
		 * 
		 */
		protected override function partAdded(partName:String, instance:Object):void{
			var displayObject:DisplayObject = null;
			if (this.isHandle(instance)) 
			{
				displayObject = DisplayObject(instance);
				displayObject.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownInHandle);
			}
			super.partAdded(partName, instance);
			return;
		}
		
		/**
		 * 复写 commitProperties函数以便让其自动更新位置。
		 * 
		 */
		protected override function commitProperties():void
		{
			var rectangle:Rectangle=null;
			super.commitProperties();
			if (parent != null) 
			{
				rectangle = this.getAdornerRectangle(parent);
				this.left = rectangle.x;
				this.top = rectangle.y;
				this.width = rectangle.width;
				this.height = rectangle.height;
			}
			return;
		}
	}
}