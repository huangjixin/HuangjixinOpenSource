//class Adorner
package com.ibm.ilog.elixir.diagram.editor 
{
	import __AS3__.vec.*;
	import com.ibm.ilog.elixir.diagram.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import mx.events.*;
	import mx.filters.*;
	import spark.components.supportClasses.*;
	import spark.filters.*;
	import spark.primitives.supportClasses.*;
	
	public class Adorner extends spark.components.supportClasses.SkinnableComponent
	{
		public function Adorner(arg1:com.ibm.ilog.elixir.diagram.Renderer)
		{
			super();
			this._adornedObject = arg1;
			arg1.addEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.updateCompleteHandler);
			this.addEventListener(flash.events.Event.ADDED, this.addedHandler);
			this.addEventListener(flash.events.Event.REMOVED, this.removedHandler);
			return;
		}
		
		internal function set interactiveHandle(arg1:flash.display.DisplayObject):void
		{
			this._interactiveHandle = arg1;
			var loc1:*=com.ibm.ilog.elixir.diagram.editor.DiagramEditor.getEditor(this);
			if (loc1 != null) 
			{
				loc1.inAdornerInteraction = !(arg1 == null);
			}
			return;
		}
		
		public function getEditableTextParts():__AS3__.vec.Vector.<Object>
		{
			var loc2:*=null;
			var loc1:*=new Vector.<Object>();
			if (this.adornedObject.hasOwnProperty("labelElement")) 
			{
				try 
				{
					loc2 = this.adornedObject["labelElement"];
					if (loc2 != null) 
					{
						loc1.push(loc2);
					}
				}
				catch (err:Error)
				{
				};
			}
			return loc1;
		}
		
		public function getTextBounds(arg1:Object, arg2:flash.display.DisplayObject):flash.geom.Rectangle
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			if (arg1 is flash.display.DisplayObject) 
			{
				return flash.display.DisplayObject(arg1).getBounds(arg2);
			}
			if (arg1 is spark.primitives.supportClasses.GraphicElement) 
			{
				loc1 = spark.primitives.supportClasses.GraphicElement(arg1);
				loc2 = new flash.geom.Point(loc1.getLayoutBoundsX(), loc1.getLayoutBoundsY());
				loc3 = new flash.geom.Point(loc2.x + loc1.getLayoutBoundsWidth(), loc2.y + loc1.getLayoutBoundsHeight());
				if (arg2 != loc1.parent) 
				{
					loc2 = arg2.globalToLocal(loc1.parent.localToGlobal(loc2));
					loc3 = arg2.globalToLocal(loc1.parent.localToGlobal(loc3));
				}
				return new flash.geom.Rectangle(loc2.x, loc2.y, loc3.x - loc2.x, loc3.y - loc2.y);
			}
			return new flash.geom.Rectangle();
		}
		
		public function isMultiline(arg1:Object):Boolean
		{
			return false;
		}
		
		public function isVertical(arg1:Object):Boolean
		{
			return false;
		}
		
		public function get editor():com.ibm.ilog.elixir.diagram.editor.DiagramEditor
		{
			return com.ibm.ilog.elixir.diagram.editor.DiagramEditor.getEditor(this);
		}
		
		public function getText(arg1:Object):String
		{
			var loc1:*=null;
			if (this.editor) 
			{
				loc1 = this.editor.defaultTextProperty;
			}
			else 
			{
				loc1 = "label";
			}
			if (this.adornedObject.hasOwnProperty(loc1)) 
			{
				try 
				{
					return this.adornedObject[loc1] as String;
				}
				catch (err:Error)
				{
				};
			}
			return null;
		}
		
		public function setText(arg1:Object, arg2:String):void
		{
			var loc1:*=null;
			if (this.editor) 
			{
				loc1 = this.editor.defaultTextProperty;
			}
			else 
			{
				loc1 = "label";
			}
			if (this.adornedObject.hasOwnProperty(loc1)) 
			{
				try 
				{
					this.adornedObject[loc1] = arg2;
				}
				catch (err:Error)
				{
				};
			}
			return;
		}
		
		public function isMouseNear(arg1:Number):Boolean
		{
			var loc1:*=getBounds(stage);
			loc1.x = loc1.x - arg1;
			loc1.y = loc1.y - arg1;
			loc1.width = loc1.width + 2 * arg1;
			loc1.height = loc1.height + 2 * arg1;
			return loc1.contains(stage.mouseX, stage.mouseY);
		}
		
		protected override function get skinParts():Object
		{
			return _skinParts;
		}
		
		public function get adornedObject():com.ibm.ilog.elixir.diagram.Renderer
		{
			return this._adornedObject;
		}
		
		
		{
			_skinParts = {"filter":false};
		}
		
		public function get graph():com.ibm.ilog.elixir.diagram.Graph
		{
			var loc1:*=this.editor;
			if (loc1 != null) 
			{
				return loc1.graph;
			}
			return null;
		}
		
		public function get highlighted():Boolean
		{
			return this._highlighted;
		}
		
		public function set highlighted(arg1:Boolean):void
		{
			this._highlighted = arg1;
			invalidateSkinState();
			invalidateProperties();
			return;
		}
		
		public function get selected():Boolean
		{
			return this._selected;
		}
		
		public function set selected(arg1:Boolean):void
		{
			this._selected = arg1;
			return;
		}
		
		internal function updateCompleteHandler(arg1:flash.events.Event):void
		{
			invalidateProperties();
			return;
		}
		
		internal function addedHandler(arg1:flash.events.Event):void
		{
			if (arg1.target == this) 
			{
				invalidateProperties();
			}
			return;
		}
		
		internal function removedHandler(arg1:flash.events.Event):void
		{
			if (arg1.target == this) 
			{
				this.cleanup();
			}
			return;
		}
		
		public function get canMove():Boolean
		{
			return true;
		}
		
		public function get canReparent():Boolean
		{
			return true;
		}
		
		public function get canCopyPaste():Boolean
		{
			return true;
		}
		
		public function canHighlightAncestor(arg1:com.ibm.ilog.elixir.diagram.Renderer):Boolean
		{
			return false;
		}
		
		public function canMoveAncestor(arg1:com.ibm.ilog.elixir.diagram.Renderer):Boolean
		{
			return false;
		}
		
		internal function getAdornedObjectBase():flash.display.DisplayObject
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc1:*=null;
			if (this._adornedObject is com.ibm.ilog.elixir.diagram.Node) 
			{
				loc2 = this._adornedObject as com.ibm.ilog.elixir.diagram.Node;
				loc1 = loc2.base;
			}
			else if (this._adornedObject is com.ibm.ilog.elixir.diagram.Link) 
			{
				loc3 = this._adornedObject as com.ibm.ilog.elixir.diagram.Link;
				loc1 = loc3.path.parent;
			}
			if (loc1 == null) 
			{
				loc1 = this._adornedObject;
			}
			return loc1;
		}
		
		protected override function commitProperties():void
		{
			var loc1:*=null;
			var loc2:*=null;
			super.commitProperties();
			if (parent != null) 
			{
				loc1 = this.getAdornedObjectBase();
				if (!this._filterSet && !(loc1 == null)) 
				{
					if (this.filter == null) 
					{
						this._filter = this.createDefaultFilter();
					}
					else 
					{
						this._filter = this.filter;
					}
					if (this._filter != null) 
					{
						loc1.filters = loc1.filters.concat(this._filter);
					}
					this._filterSet = true;
				}
				if (!(this._filter == null) && this.filter == null && this._filter.hasOwnProperty("alpha")) 
				{
					this._filter["alpha"] = getStyle(this._selected ? "glowSelectAlpha" : "glowHighlightAlpha");
				}
				loc2 = this.getAdornerRectangle(parent);
				this.left = loc2.x;
				this.top = loc2.y;
				this.width = loc2.width;
				this.height = loc2.height;
			}
			return;
		}
		
		internal function createDefaultFilter():mx.filters.BaseFilter
		{
			var loc1:*=new spark.filters.GlowFilter();
			loc1.color = getStyle("glowColor");
			var loc2:*=getStyle("glowWidth");
			loc1.blurX = loc2;
			loc1.blurY = loc2;
			return loc1;
		}
		
		protected function getAdornerRectangle(arg1:flash.display.DisplayObject):flash.geom.Rectangle
		{
			var loc1:*=this._adornedObject as com.ibm.ilog.elixir.diagram.Node;
			if (loc1 != null) 
			{
				return loc1.getNodeOrBaseBounds(arg1);
			}
			return this._adornedObject.getBounds(arg1);
		}
		
		protected override function getCurrentSkinState():String
		{
			if (this.selected && this.highlighted) 
			{
				return "selectedHighlighted";
			}
			if (this.highlighted) 
			{
				return "highlighted";
			}
			return "selected";
		}
		
		protected function cleanup():void
		{
			var loc2:*=null;
			this.stopInteraction();
			var loc1:*=this.getAdornedObjectBase();
			if (this._filterSet && !(loc1 == null)) 
			{
				if (this._filter != null) 
				{
					loc2 = loc1.filters;
					loc2.splice(loc2.indexOf(this._filter), 1).concat();
					loc1.filters = loc2.concat();
				}
				this._filterSet = false;
			}
			stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.mouseUpInStage, true);
			stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.mouseMoveInStage, true);
			stage.removeEventListener(mx.events.SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpInStage, true);
			stage.removeEventListener(mx.events.SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseMoveInStage, true);
			this.removeEventListener(flash.events.Event.ADDED, this.addedHandler);
			this.removeEventListener(flash.events.Event.REMOVED, this.removedHandler);
			this.adornedObject.removeEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.updateCompleteHandler);
			return;
		}
		
		protected function isHandle(arg1:Object):Boolean
		{
			return false;
		}
		
		protected override function partAdded(arg1:String, arg2:Object):void
		{
			var loc1:*=null;
			if (this.isHandle(arg2)) 
			{
				loc1 = flash.display.DisplayObject(arg2);
				loc1.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.mouseDownInHandle);
			}
			super.partAdded(arg1, arg2);
			return;
		}
		
		internal function mouseDownInHandle(arg1:flash.events.MouseEvent):void
		{
			this.interactiveHandle = flash.display.DisplayObject(arg1.currentTarget);
			this.handlePressed(this.interactiveHandle, arg1);
			this._startX = arg1.stageX;
			this._startY = arg1.stageY;
			this._mouseDragged = false;
			arg1.stopPropagation();
			var loc1:*=systemManager.getSandboxRoot();
			loc1.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.mouseUpInStage, true);
			loc1.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.mouseMoveInStage, true);
			loc1.addEventListener(mx.events.SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpInStage, true);
			loc1.addEventListener(mx.events.SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseMoveInStage, true);
			systemManager.deployMouseShields(true);
			return;
		}
		
		internal function mouseMoveInStage(arg1:flash.events.MouseEvent):void
		{
			var loc1:*=NaN;
			var loc2:*=NaN;
			var loc3:*=NaN;
			var loc4:*=NaN;
			var loc5:*=NaN;
			var loc6:*=null;
			var loc7:*=null;
			var loc8:*=null;
			if (this.interactiveHandle != null) 
			{
				loc1 = arg1.stageX;
				loc2 = arg1.stageY;
				loc3 = loc1 - this._startX;
				loc4 = loc2 - this._startY;
				if (!this._mouseDragged) 
				{
					loc5 = this.editor.moveThreshold;
					if (Math.abs(loc3) > loc5 || Math.abs(loc4) > loc5) 
					{
						this._mouseDragged = true;
						loc6 = new flash.geom.Point(this._startX, this._startY);
						loc6 = this.editor.snapPoint(loc6, stage);
						this._startX = loc6.x;
						this._startY = loc6.y;
					}
				}
				if (this._mouseDragged) 
				{
					loc7 = new flash.geom.Point(loc1, loc2);
					loc1 = (loc7 = this.editor.snapPoint(loc7, stage)).x;
					loc2 = loc7.y;
					loc7 = this.editor.graph.globalToLocal(stage.localToGlobal(loc7));
					loc8 = this.editor.graph.globalToLocal(stage.localToGlobal(new flash.geom.Point(this._startX, this._startY)));
					loc3 = loc7.x - loc8.x;
					loc4 = loc7.y - loc8.y;
					this._startX = loc1;
					this._startY = loc2;
					this.handleDragged(this.interactiveHandle, arg1, loc3, loc4);
				}
			}
			arg1.stopPropagation();
			return;
		}
		
		function moveDragPoint(arg1:Number, arg2:Number):void
		{
			var loc1:*=new flash.geom.Point(arg1, arg2);
			var loc2:*=this.editor.graph.localToGlobal(new flash.geom.Point(0, 0));
			loc1 = this.editor.graph.localToGlobal(loc1);
			this._startX = this._startX + (loc1.x - loc2.x);
			this._startY = this._startY + (loc1.y - loc2.y);
			return;
		}
		
		protected function handlePressed(arg1:flash.display.DisplayObject, arg2:flash.events.MouseEvent):void
		{
			return;
		}
		
		protected function handleDragged(arg1:flash.display.DisplayObject, arg2:flash.events.MouseEvent, arg3:Number, arg4:Number):void
		{
			return;
		}
		
		internal function mouseUpInStage(arg1:flash.events.MouseEvent):void
		{
			if (this.interactiveHandle != null) 
			{
				this.handleReleased(this.interactiveHandle, arg1);
			}
			this.stopInteraction();
			arg1.stopPropagation();
			return;
		}
		
		internal function stopInteraction():void
		{
			var loc1:*=null;
			if (this.interactiveHandle != null) 
			{
				this.interactiveHandle = null;
				loc1 = systemManager.getSandboxRoot();
				loc1.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.mouseUpInStage, true);
				loc1.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.mouseMoveInStage, true);
				loc1.removeEventListener(mx.events.SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpInStage, true);
				loc1.removeEventListener(mx.events.SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseMoveInStage, true);
				systemManager.deployMouseShields(false);
			}
			return;
		}
		
		protected function handleReleased(arg1:flash.display.DisplayObject, arg2:flash.events.MouseEvent):void
		{
			return;
		}
		
		internal function get interactiveHandle():flash.display.DisplayObject
		{
			return this._interactiveHandle;
		}
		
		public var filter:mx.filters.BaseFilter;
		
		internal var _adornedObject:com.ibm.ilog.elixir.diagram.Renderer;
		
		internal var _highlighted:Boolean;
		
		internal var _selected:Boolean;
		
		internal var _startX:Number;
		
		internal var _interactiveHandle:flash.display.DisplayObject;
		
		internal var _mouseDragged:Boolean;
		
		internal var _filterSet:Boolean;
		
		internal var _filter:mx.filters.BaseFilter;
		
		internal var _startY:Number;
		
		internal static var _skinParts:Object;
	}
}


