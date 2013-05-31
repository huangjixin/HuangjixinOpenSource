//class DiagramEditor
package com.ibm.ilog.elixir.diagram.editor 
{
	import __AS3__.vec.*;
	import com.ibm.ilog.elixir.*;
	import com.ibm.ilog.elixir.diagram.*;
	import com.ibm.ilog.elixir.diagram.supportClasses.*;
	import com.ibm.ilog.elixir.diagram.utils.*;
	import com.ibm.ilog.elixir.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.*;
	import flashx.textLayout.operations.*;
	import mx.controls.*;
	import mx.core.*;
	import mx.events.*;
	import mx.graphics.*;
	import mx.logging.*;
	import mx.managers.*;
	import mx.resources.*;
	import mx.utils.*;
	import spark.components.*;
	import spark.components.supportClasses.*;
	import spark.events.*;
	import spark.primitives.*;
	
	public class DiagramEditor extends spark.components.supportClasses.SkinnableComponent
	{
		public function DiagramEditor()
		{
			this.selectedObjects = new Vector.<com.ibm.ilog.elixir.diagram.Renderer>();
			this.highlightedObjects = new Vector.<com.ibm.ilog.elixir.diagram.Renderer>();
			this.adorners = new flash.utils.Dictionary();
			this.clipboard = new com.ibm.ilog.elixir.diagram.Graph();
			super();
			this._keyboardNavigation = new com.ibm.ilog.elixir.diagram.supportClasses.KeyboardNavigationSupport(this);
			this._keyboardNavigation.setSelectedObjectFunction = this.keyboardSetSelectedObject;
			this._keyboardNavigation.getSelectedObjectsFunction = this.getSelectedObjects;
			this._keyboardNavigation.selectionMode = com.ibm.ilog.elixir.SelectionMode.MULTIPLE;
			this.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.mouseDownHandler, true);
			this.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.mouseOverHandler);
			this.addEventListener(mx.events.DragEvent.DRAG_ENTER, this.dragEnterHandler);
			this.addEventListener(mx.events.DragEvent.DRAG_OVER, this.dragOverHandler);
			this.addEventListener(mx.events.DragEvent.DRAG_DROP, this.dragDropHandler);
			this.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, this.editorKeyDownHandler);
			this.addEventListener(flash.events.Event.SELECT_ALL, this.selectAllHandler);
			this.addEventListener(flash.events.Event.CUT, this.cutHandler);
			this.addEventListener(flash.events.Event.COPY, this.copyHandler);
			this.addEventListener(flash.events.Event.PASTE, this.pasteHandler);
			return;
		}
		
		public function set gridVisible(arg1:Boolean):void
		{
			if (arg1 != this._gridVisible) 
			{
				this._gridVisible = arg1;
				this.invalidateGrid();
			}
			return;
		}
		
		internal function invalidateGrid():void
		{
			invalidateDisplayList();
			if (this.grid != null) 
			{
				this.grid.invalidateDisplayList();
				this.invalidateGridInSubgraphs(this._graph);
			}
			return;
		}
		
		internal function invalidateGridInSubgraphs(arg1:com.ibm.ilog.elixir.diagram.Graph):void
		{
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=0;
			var loc6:*=null;
			var loc1:*=arg1.numElements;
			var loc2:*=0;
			while (loc2 < loc1) 
			{
				if (!((loc3 = arg1.getElementAt(loc2) as com.ibm.ilog.elixir.diagram.Subgraph) == null) && !(loc3.graph == null)) 
				{
					if ((loc4 = loc3.graph.parent as spark.components.Group) != null) 
					{
						if ((loc5 = loc4.getElementIndex(loc3.graph)) > 0) 
						{
							if ((loc6 = loc4.getElementAt((loc5 - 1)) as com.ibm.ilog.elixir.diagram.editor.Grid) != null) 
							{
								loc6.invalidateDisplayList();
							}
						}
					}
					this.invalidateGridInSubgraphs(loc3.graph);
				}
				++loc2;
			}
			return;
		}
		
		function snapPoint(arg1:flash.geom.Point, arg2:flash.display.DisplayObjectContainer):flash.geom.Point
		{
			if (!(this.grid == null) && this._gridVisible) 
			{
				if (arg2 != this._graph) 
				{
					arg1 = this._graph.globalToLocal(arg2.localToGlobal(arg1));
				}
				arg1 = new flash.geom.Point(Math.round(arg1.x / this._gridSpacing) * this._gridSpacing, Math.round(arg1.y / this._gridSpacing) * this._gridSpacing);
				if (arg2 != this._graph) 
				{
					arg1 = arg2.globalToLocal(this._graph.localToGlobal(arg1));
				}
			}
			return arg1;
		}
		
		public function cloneRenderer(arg1:com.ibm.ilog.elixir.diagram.Renderer):com.ibm.ilog.elixir.diagram.Renderer
		{
			return cloneRendererStatic(arg1, this.cloneFunction, this.cloneMap, this.clonedLinks);
		}
		
		internal function cloneSimpleObject(arg1:Object):Object
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=null;
			var loc6:*=null;
			var loc7:*=null;
			try 
			{
				loc1 = flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName(arg1)) as Class;
				if (loc1 != null) 
				{
					loc2 = new loc1();
					(loc3 = new Object())["includeReadOnly"] = false;
					loc5 = (loc4 = mx.utils.ObjectUtil.getClassInfo(arg1, null, loc3))["properties"];
					loc8 = 0;
					var loc9:*=loc5;
					for each (loc6 in loc9) 
					{
					};
					return loc2;
				}
			}
			catch (err:Error)
			{
			};
			return null;
		}
		
		internal function cloneChildren(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Renderer):void
		{
			var loc2:*=0;
			var loc3:*=null;
			var loc4:*=null;
			var loc1:*=arg1 as com.ibm.ilog.elixir.diagram.Subgraph;
			if (loc1 != null) 
			{
				loc2 = 0;
				while (loc2 < loc1.graph.numElements) 
				{
					if ((loc3 = loc1.graph.getElementAt(loc2) as com.ibm.ilog.elixir.diagram.Renderer) != null) 
					{
						loc4 = this.cloneRenderer(loc3);
						com.ibm.ilog.elixir.diagram.Subgraph(arg2).graph.addElement(loc4);
						this.cloneChildren(loc3, loc4);
					}
					++loc2;
				}
			}
			return;
		}
		
		internal function cloneRecursive(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Graph):com.ibm.ilog.elixir.diagram.Renderer
		{
			var loc1:*=this.cloneRenderer(arg1);
			arg2.addElement(loc1);
			this.cloneChildren(arg1, loc1);
			return loc1;
		}
		
		function dispatchEditorEvent(arg1:String, arg2:com.ibm.ilog.elixir.diagram.Renderer, arg3:Boolean=true, arg4:Boolean=false):Boolean
		{
			var loc1:*=new com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent(arg1, arg2, arg3, arg4);
			dispatchEvent(loc1);
			return !loc1.isDefaultPrevented();
		}
		
		internal function ensureRendererIsVisible(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Boolean=false, arg3:Boolean=false):void
		{
			var loc1:*=null;
			var loc2:*=null;
			if (this._scroller != null) 
			{
				loc1 = new flash.geom.Point(-5, -5);
				loc2 = new flash.geom.Point(arg1.getLayoutBoundsWidth() + 5, arg1.getLayoutBoundsHeight() + 5);
				loc1 = arg1.localToGlobal(loc1);
				loc2 = arg1.localToGlobal(loc2);
				loc1 = this._scroller.graph.globalToLocal(loc1);
				loc2 = this._scroller.graph.globalToLocal(loc2);
				this._scroller.ensureRectangleIsVisible(new flash.geom.Rectangle(loc1.x, loc1.y, loc2.x - loc1.x, loc2.y - loc1.y), arg3, arg2);
			}
			return;
		}
		
		internal function keyboardSetSelectedObject(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Boolean):void
		{
			this.setSelected(arg1, arg2);
			if (arg2) 
			{
				this.ensureRendererIsVisible(arg1);
			}
			return;
		}
		
		public function get nextNodeActionKey():uint
		{
			return this._keyboardNavigation.nextNodeActionKey;
		}
		
		public function set nextNodeActionKey(arg1:uint):void
		{
			this._keyboardNavigation.nextNodeActionKey = arg1;
			return;
		}
		
		public function get previousNodeActionKey():uint
		{
			return this._keyboardNavigation.previousNodeActionKey;
		}
		
		public function set previousNodeActionKey(arg1:uint):void
		{
			this._keyboardNavigation.previousNodeActionKey = arg1;
			return;
		}
		
		public function get openNodeActionKey():uint
		{
			return this._keyboardNavigation.openNodeActionKey;
		}
		
		public function set openNodeActionKey(arg1:uint):void
		{
			this._keyboardNavigation.openNodeActionKey = arg1;
			return;
		}
		
		public function get closeNodeActionKey():uint
		{
			return this._keyboardNavigation.closeNodeActionKey;
		}
		
		public function set closeNodeActionKey(arg1:uint):void
		{
			this._keyboardNavigation.closeNodeActionKey = arg1;
			return;
		}
		
		public function get nextConnectionActionKey():uint
		{
			return this._keyboardNavigation.nextConnectionActionKey;
		}
		
		public function set nextConnectionActionKey(arg1:uint):void
		{
			this._keyboardNavigation.nextConnectionActionKey = arg1;
			return;
		}
		
		public function get previousConnectionActionKey():uint
		{
			return this._keyboardNavigation.previousConnectionActionKey;
		}
		
		public function set previousConnectionActionKey(arg1:uint):void
		{
			this._keyboardNavigation.previousConnectionActionKey = arg1;
			return;
		}
		
		public function get followConnectionForwardActionKey():uint
		{
			return this._keyboardNavigation.followConnectionForwardActionKey;
		}
		
		public function set followConnectionForwardActionKey(arg1:uint):void
		{
			this._keyboardNavigation.followConnectionForwardActionKey = arg1;
			return;
		}
		
		public function get followConnectionBackwardsActionKey():uint
		{
			return this._keyboardNavigation.followConnectionBackwardsActionKey;
		}
		
		public function set followConnectionBackwardsActionKey(arg1:uint):void
		{
			this._keyboardNavigation.followConnectionBackwardsActionKey = arg1;
			return;
		}
		
		public function get undoFollowConnectionForwardActionKey():uint
		{
			return this._keyboardNavigation.undoFollowConnectionForwardActionKey;
		}
		
		public function set undoFollowConnectionForwardActionKey(arg1:uint):void
		{
			this._keyboardNavigation.undoFollowConnectionForwardActionKey = arg1;
			return;
		}
		
		public function get undoFollowConnectionBackwardsActionKey():uint
		{
			return this._keyboardNavigation.undoFollowConnectionBackwardsActionKey;
		}
		
		public function set undoFollowConnectionBackwardsActionKey(arg1:uint):void
		{
			this._keyboardNavigation.undoFollowConnectionBackwardsActionKey = arg1;
			return;
		}
		
		public function get extendSelectionActionKey():uint
		{
			return this._keyboardNavigation.extendSelectionActionKey;
		}
		
		internal function setScroller(arg1:com.ibm.ilog.elixir.diagram.GraphScroller):void
		{
			if (arg1 != this._scroller) 
			{
				this.setGraph(null);
				this.setDiagram(null);
				if (this._scroller != null) 
				{
					if (this.diagramParent != null) 
					{
						this.diagramParent.removeElement(this._scroller);
					}
					this.addOrRemoveScrollerEvents(this._scroller, false);
					this._currentZoom = Number.NaN;
				}
				this._scroller = arg1;
				if (this._scroller != null) 
				{
					this._scroller.percentWidth = 100;
					this._scroller.percentHeight = 100;
					if (this.diagramParent != null) 
					{
						this.diagramParent.addElement(this._scroller);
					}
					if (this.getScrolledGraph(this._scroller) != null) 
					{
						this.wireGraph(this.getScrolledGraph(this._scroller));
					}
					this.addOrRemoveScrollerEvents(this._scroller, true);
					this._currentZoom = this._scroller.zoom;
					this.invalidateGrid();
				}
			}
			return;
		}
		
		public function set extendSelectionActionKey(arg1:uint):void
		{
			this._keyboardNavigation.extendSelectionActionKey = arg1;
			return;
		}
		
		public function get addModeActionKey():uint
		{
			return this._keyboardNavigation.addModeActionKey;
		}
		
		public function set addModeActionKey(arg1:uint):void
		{
			this._keyboardNavigation.addModeActionKey = arg1;
			return;
		}
		
		public function get addModeModifierKey():String
		{
			return this._keyboardNavigation.addModeModifierKey;
		}
		
		public function set addModeModifierKey(arg1:String):void
		{
			this._keyboardNavigation.addModeModifierKey = arg1;
			return;
		}
		
		public function get keyboardNavigationPolicy():String
		{
			return this._keyboardNavigation.keyboardNavigationPolicy;
		}
		
		internal function set _2037499501keyboardNavigationPolicy(arg1:String):void
		{
			this._keyboardNavigation.keyboardNavigationPolicy = arg1;
			return;
		}
		
		public function get caretRenderer():com.ibm.ilog.elixir.diagram.Renderer
		{
			return this._keyboardNavigation.getShowsCaretRenderer();
		}
		
		public function get showsCaretMode():String
		{
			return this._keyboardNavigation.showCaretMode;
		}
		
		public function set showsCaretMode(arg1:String):void
		{
			this._keyboardNavigation.showCaretMode = arg1;
			return;
		}
		
		public final function set keyboardMoveNodesIncrementalModifierKey(arg1:String):void
		{
			var loc1:*=this.keyboardMoveNodesIncrementalModifierKey;
			if (loc1 !== arg1) 
			{
				this._371781529keyboardMoveNodesIncrementalModifierKey = arg1;
				if (this.hasEventListener("propertyChange")) 
				{
					this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "keyboardMoveNodesIncrementalModifierKey", loc1, arg1));
				}
			}
			return;
		}
		
		public function set keyboardNavigationPolicy(arg1:String):void
		{
			var loc1:*=this.keyboardNavigationPolicy;
			if (loc1 !== arg1) 
			{
				this._2037499501keyboardNavigationPolicy = arg1;
				if (this.hasEventListener("propertyChange")) 
				{
					this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "keyboardNavigationPolicy", loc1, arg1));
				}
			}
			return;
		}
		
		protected override function get skinParts():Object
		{
			return _skinParts;
		}
		
		internal static function getLayoutBounds(arg1:mx.core.UIComponent, arg2:flash.display.DisplayObject):flash.geom.Rectangle
		{
			var loc1:*=new flash.geom.Point(arg1.getLayoutBoundsX(), arg1.getLayoutBoundsY());
			if (arg1.parent && arg2 && !(arg2 == arg1.parent)) 
			{
				loc1 = arg1.parent.localToGlobal(loc1);
				loc1 = arg2.globalToLocal(loc1);
			}
			return new flash.geom.Rectangle(loc1.x, loc1.y, arg1.getLayoutBoundsWidth(), arg1.getLayoutBoundsHeight());
		}
		
		public static function getEditor(arg1:flash.display.DisplayObject):com.ibm.ilog.elixir.diagram.editor.DiagramEditor
		{
			var loc1:*=arg1.parent;
			while (loc1 != null) 
			{
				if (loc1 is com.ibm.ilog.elixir.diagram.editor.DiagramEditor) 
				{
					return DiagramEditor(loc1);
				}
				loc1 = loc1.parent;
			}
			return null;
		}
		
		static function reparentLink(arg1:com.ibm.ilog.elixir.diagram.Link):void
		{
			var loc2:*=null;
			var loc5:*=null;
			var loc6:*=null;
			var loc7:*=0;
			var loc8:*=0;
			var loc9:*=null;
			var loc10:*=null;
			var loc1:*=arg1.parent as com.ibm.ilog.elixir.diagram.Graph;
			if (!loc1) 
			{
				return;
			}
			var loc3:*=arg1.startNode;
			var loc4:*=arg1.endNode;
			arg1.cleanUpCollapsedPorts();
			if (loc3 == null) 
			{
				loc3 = arg1;
			}
			if (loc4 == null) 
			{
				loc4 = arg1;
			}
			if (loc3 && loc4) 
			{
				loc2 = getLowestCommonGraph(loc3, loc4);
				if (loc2 == null) 
				{
					return;
				}
				loc5 = com.ibm.ilog.elixir.diagram.editor.DiagramEditor.getEditor(arg1);
				if (loc2 == loc1) 
				{
					if (!(loc3 == null) && !(loc3.parent == null) && !(loc3.parent == loc1) || !(loc4 == null) && !(loc4.parent == null) && !(loc4.parent == loc1)) 
					{
						loc8 = -1;
						if (loc3 != null) 
						{
							loc9 = loc3;
							while (!(loc9 == null) && !(loc9.parent == loc1)) 
							{
								if ((loc10 = loc9.parent as com.ibm.ilog.elixir.diagram.Graph).owningSubgraph) 
								{
									loc9 = loc10.owningSubgraph;
									continue;
								}
								break;
							}
							if (loc9 != null) 
							{
								loc8 = loc1.getElementIndex(loc9);
							}
						}
						if (loc4 != null) 
						{
							loc9 = loc4;
							while (!(loc9 == null) && !(loc9.parent == loc1)) 
							{
								if ((loc10 = loc9.parent as com.ibm.ilog.elixir.diagram.Graph).owningSubgraph) 
								{
									loc9 = loc10.owningSubgraph;
									continue;
								}
								break;
							}
							if (loc9 != null) 
							{
								loc8 = Math.max(loc8, loc1.getElementIndex(loc9));
							}
						}
						if (loc8 > loc1.getElementIndex(arg1)) 
						{
							if (loc5) 
							{
								if (!loc5.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_CHANGE_ZORDER, arg1)) 
								{
									return;
								}
							}
							loc1.setElementIndex(arg1, loc8);
						}
					}
				}
				else 
				{
					if (loc5) 
					{
						if (!loc5.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_REPARENT, arg1)) 
						{
							return;
						}
					}
					loc1.removeElement(arg1);
					if ((loc6 = arg1.intermediatePoints).length != 0) 
					{
						loc7 = 0;
						while (loc7 < loc6.length) 
						{
							loc6[loc7] = loc2.globalToLocal(loc1.localToGlobal(loc6[loc7]));
							++loc7;
						}
						arg1.intermediatePoints = loc6;
					}
					arg1.fallbackStartPoint = loc2.globalToLocal(loc1.localToGlobal(arg1.fallbackStartPoint));
					arg1.fallbackEndPoint = loc2.globalToLocal(loc1.localToGlobal(arg1.fallbackEndPoint));
					loc2.addElement(arg1);
				}
			}
			return;
		}
		
		static function reparentIntergraphLinks(arg1:com.ibm.ilog.elixir.diagram.Subgraph):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=0;
			var loc5:*=arg1.graph.getNodes();
			for each (loc1 in loc5) 
			{
				var loc6:*=0;
				var loc7:*=loc1.getLinks();
				for each (loc2 in loc7) 
				{
					reparentLink(loc2);
				}
				if ((loc3 = loc1 as com.ibm.ilog.elixir.diagram.Subgraph) == null) 
				{
					continue;
				}
				reparentIntergraphLinks(loc3);
			}
			return;
		}
		
		public static function getLowestCommonGraph(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Renderer):com.ibm.ilog.elixir.diagram.Graph
		{
			var loc3:*=null;
			if (arg1 == null || arg2 == null) 
			{
				loc3 = com.ibm.ilog.elixir.diagram.utils.ResourceUtil.getError(mx.resources.ResourceManager.getInstance(), 1001, "diagram.expert.message.invalidArguments");
				com.ibm.ilog.elixir.utils.LoggingUtil.log(com.ibm.ilog.elixir.diagram.editor.DiagramEditor, mx.logging.LogEventLevel.ERROR, loc3);
				throw new ArgumentError(loc3);
			}
			var loc1:*=arg1.parent as com.ibm.ilog.elixir.diagram.Graph;
			var loc2:*=arg2.parent as com.ibm.ilog.elixir.diagram.Graph;
			if (loc1 == null || loc2 == null) 
			{
				return null;
			}
			if (loc1 == loc2) 
			{
				return loc1;
			}
			if (isGraphAncestorOf(loc1, loc2)) 
			{
				return loc1;
			}
			if (isGraphAncestorOf(loc2, loc1)) 
			{
				return loc2;
			}
			if (loc1.owningSubgraph == null) 
			{
				return loc1;
			}
			return getLowestCommonGraph(loc1.owningSubgraph, arg2);
		}
		
		internal static function isGraphAncestorOf(arg1:com.ibm.ilog.elixir.diagram.Graph, arg2:com.ibm.ilog.elixir.diagram.Graph):Boolean
		{
			var loc1:*=null;
			if (arg2.owningSubgraph == null) 
			{
				loc1 = arg2.parent as com.ibm.ilog.elixir.diagram.Graph;
			}
			else 
			{
				loc1 = arg2.owningSubgraph.parent as com.ibm.ilog.elixir.diagram.Graph;
			}
			while (loc1 != null) 
			{
				if (loc1 == arg1) 
				{
					return true;
				}
				if (loc1.owningSubgraph != null) 
				{
					loc1 = loc1.owningSubgraph.parent as com.ibm.ilog.elixir.diagram.Graph;
					continue;
				}
				loc1 = loc1.parent as com.ibm.ilog.elixir.diagram.Graph;
			}
			return false;
		}
		
		internal static function GetRenderer(arg1:Object):com.ibm.ilog.elixir.diagram.Renderer
		{
			while (arg1 is flash.display.DisplayObject) 
			{
				if (arg1 is com.ibm.ilog.elixir.diagram.Renderer) 
				{
					return com.ibm.ilog.elixir.diagram.Renderer(arg1);
				}
				if (arg1 is com.ibm.ilog.elixir.diagram.editor.Adorner) 
				{
					return com.ibm.ilog.elixir.diagram.editor.Adorner(arg1).adornedObject;
				}
				arg1 = arg1.parent;
			}
			return null;
		}
		
		internal static function cloneRendererStatic(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Function=null, arg3:flash.utils.Dictionary=null, arg4:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Link>=null):com.ibm.ilog.elixir.diagram.Renderer
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			try 
			{
				if ((loc1 = flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName(arg1)) as Class) != null) 
				{
					loc2 = com.ibm.ilog.elixir.diagram.Renderer(new loc1());
					cloneProperties(arg1, loc2, arg2);
					if (arg2 != null) 
					{
						arg2(arg1, loc2, !(arg3 == null));
					}
					if (arg3 != null) 
					{
						arg3[arg1] = loc2;
					}
					if (arg1 is com.ibm.ilog.elixir.diagram.Link) 
					{
						loc3 = com.ibm.ilog.elixir.diagram.Link(arg1);
						if (arg4 != null) 
						{
							arg4.push(loc3);
						}
						loc4 = com.ibm.ilog.elixir.diagram.Link(loc2);
						if (loc3.fallbackStartPoint) 
						{
							loc4.fallbackStartPoint = new flash.geom.Point(loc3.fallbackStartPoint.x, loc3.fallbackStartPoint.y);
						}
						if (loc3.fallbackEndPoint) 
						{
							loc4.fallbackEndPoint = new flash.geom.Point(loc3.fallbackEndPoint.x, loc3.fallbackEndPoint.y);
						}
					}
					return loc2;
				}
			}
			catch (err:Error)
			{
			};
			return null;
		}
		
		internal static function cloneProperties(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Renderer, arg3:Function):void
		{
			var loc4:*=null;
			var loc5:*=null;
			var loc6:*=null;
			var loc7:*=null;
			if (!(arg1 == null) && !(arg2 == null)) 
			{
				if (!(arg2 is com.ibm.ilog.elixir.diagram.Link)) 
				{
					setX(arg2, getX(arg1));
					setY(arg2, getY(arg1));
				}
				arg2.explicitWidth = arg1.explicitWidth;
				arg2.explicitHeight = arg1.explicitHeight;
				arg2.percentWidth = arg1.percentWidth;
				arg2.percentHeight = arg1.percentHeight;
				arg2.explicitMinWidth = arg1.explicitMinWidth;
				arg2.explicitMinHeight = arg1.explicitMinHeight;
				arg2.explicitMaxWidth = arg1.explicitMaxWidth;
				arg2.explicitMaxHeight = arg1.explicitMaxHeight;
			}
			if (rendererProperties == null) 
			{
				rendererProperties = new Array();
				var loc8:*=0;
				var loc9:*=mx.utils.ObjectUtil.getClassInfo(new com.ibm.ilog.elixir.diagram.Renderer())["properties"];
				for each (loc5 in loc9) 
				{
					rendererProperties.push(loc5.localName);
				}
			}
			var loc1:*;
			(loc1 = new Object())["includeReadOnly"] = false;
			var loc2:*;
			var loc3:*=(loc2 = mx.utils.ObjectUtil.getClassInfo(arg1, rendererProperties, loc1))["properties"];
			loc8 = 0;
			loc9 = loc3;
			for each (loc4 in loc9) 
			{
			};
			return;
		}
		
		public function get editedComponent():mx.core.UIComponent
		{
			return this._editedComponent;
		}
		
		public function set editedComponent(arg1:mx.core.UIComponent):void
		{
			var loc1:*=null;
			if (arg1 != this._editedComponent) 
			{
				this._editedComponent = arg1;
				if (this._editedComponent is com.ibm.ilog.elixir.diagram.Diagram) 
				{
					this.setDiagram(com.ibm.ilog.elixir.diagram.Diagram(this._editedComponent));
				}
				else if (this._editedComponent is com.ibm.ilog.elixir.diagram.Graph) 
				{
					this.setGraph(com.ibm.ilog.elixir.diagram.Graph(this._editedComponent));
				}
				else if (this._editedComponent is com.ibm.ilog.elixir.diagram.GraphScroller) 
				{
					this.setScroller(com.ibm.ilog.elixir.diagram.GraphScroller(this._editedComponent));
				}
				else 
				{
					loc1 = com.ibm.ilog.elixir.diagram.utils.ResourceUtil.getError(resourceManager, 1003, "diagram.expert.message.invalidEditedComponent");
					com.ibm.ilog.elixir.utils.LoggingUtil.log(com.ibm.ilog.elixir.diagram.editor.DiagramEditor, mx.logging.LogEventLevel.ERROR, loc1);
					throw new ArgumentError(loc1);
				}
			}
			return;
		}
		
		public function get graph():com.ibm.ilog.elixir.diagram.Graph
		{
			return this._graph;
		}
		
		internal function setGraph(arg1:com.ibm.ilog.elixir.diagram.Graph):void
		{
			var loc1:*=null;
			if (arg1 != this._graph) 
			{
				this.setDiagram(null);
				this.setScroller(null);
				if (this._graph != null) 
				{
					if (this.diagramParent != null) 
					{
						this.diagramParent.removeElement(this._graph);
					}
				}
				this.wireGraph(arg1);
				if (this._graph != null) 
				{
					this._graph.percentWidth = 100;
					this._graph.percentHeight = 100;
					if (this.diagramParent != null) 
					{
						loc1 = new spark.primitives.Rect();
						loc1.fill = new mx.graphics.SolidColor(0, 0);
						loc1.percentWidth = 100;
						loc1.percentHeight = 100;
						this.diagramParent.addElement(loc1);
						this.diagramParent.addElement(this._graph);
					}
				}
			}
			return;
		}
		
		internal function wireGraph(arg1:com.ibm.ilog.elixir.diagram.Graph):void
		{
			if (this._graph != null) 
			{
				this._graph.removeEventListener(spark.events.ElementExistenceEvent.ELEMENT_ADD, this.elementAdded);
				this._graph.removeEventListener(spark.events.ElementExistenceEvent.ELEMENT_REMOVE, this.elementRemoved);
			}
			this._graph = arg1;
			this._keyboardNavigation.graph = this._graph;
			if (this._graph != null) 
			{
				this._graph.addEventListener(spark.events.ElementExistenceEvent.ELEMENT_ADD, this.elementAdded);
				this._graph.addEventListener(spark.events.ElementExistenceEvent.ELEMENT_REMOVE, this.elementRemoved);
			}
			return;
		}
		
		internal function elementAdded(arg1:spark.events.ElementExistenceEvent):void
		{
			var loc1:*=arg1.element as com.ibm.ilog.elixir.diagram.Subgraph;
			if (loc1 != null) 
			{
				this.addGridToSubgraph(loc1);
			}
			return;
		}
		
		internal function addGridToSubgraph(arg1:com.ibm.ilog.elixir.diagram.Subgraph):void
		{
			var loc2:*=null;
			var loc3:*=0;
			var loc4:*=0;
			var loc5:*=0;
			var loc6:*=null;
			var loc1:*=arg1.graph;
			if (loc1 != null) 
			{
				loc2 = loc1.parent as spark.components.Group;
				if (loc2 != null) 
				{
					if ((loc5 = loc2.getElementIndex(loc1)) >= 0 && !(loc5 > 0 && loc2.getElementAt((loc5 - 1)) is com.ibm.ilog.elixir.diagram.editor.Grid)) 
					{
						(loc6 = new com.ibm.ilog.elixir.diagram.editor.Grid()).drawBorder = true;
						loc2.addElementAt(loc6, loc5);
					}
				}
				loc3 = loc1.numElements;
				loc4 = 0;
				while (loc4 < loc3) 
				{
					arg1 = loc1.getElementAt(loc4) as com.ibm.ilog.elixir.diagram.Subgraph;
					if (arg1 != null) 
					{
						this.addGridToSubgraph(arg1);
					}
					++loc4;
				}
				loc1.addEventListener(spark.events.ElementExistenceEvent.ELEMENT_ADD, this.elementAdded);
				loc1.addEventListener(spark.events.ElementExistenceEvent.ELEMENT_REMOVE, this.elementRemoved);
			}
			return;
		}
		
		internal function elementRemoved(arg1:spark.events.ElementExistenceEvent):void
		{
			var loc1:*=arg1.element as com.ibm.ilog.elixir.diagram.Subgraph;
			if (loc1 != null) 
			{
				this.removeGridToSubgraph(loc1);
			}
			return;
		}
		
		internal function removeGridToSubgraph(arg1:com.ibm.ilog.elixir.diagram.Subgraph):void
		{
			var loc2:*=0;
			var loc3:*=0;
			var loc1:*=arg1.graph;
			if (loc1 != null) 
			{
				loc2 = loc1.numElements;
				loc3 = 0;
				while (loc3 < loc2) 
				{
					arg1 = loc1.getElementAt(loc3) as com.ibm.ilog.elixir.diagram.Subgraph;
					if (arg1 != null) 
					{
						this.removeGridToSubgraph(arg1);
					}
					++loc3;
				}
				loc1.removeEventListener(spark.events.ElementExistenceEvent.ELEMENT_ADD, this.elementAdded);
				loc1.removeEventListener(spark.events.ElementExistenceEvent.ELEMENT_REMOVE, this.elementRemoved);
			}
			return;
		}
		
		internal function setDiagram(arg1:com.ibm.ilog.elixir.diagram.Diagram):void
		{
			if (arg1 != this._diagram) 
			{
				this.setGraph(null);
				this.setScroller(null);
				if (this._diagram != null) 
				{
					if (this.diagramParent != null) 
					{
						this.diagramParent.removeElement(this._diagram);
					}
					if (this._diagram.scroller != null) 
					{
						this.addOrRemoveScrollerEvents(this._diagram.scroller, false);
						this._currentZoom = Number.NaN;
					}
				}
				this._diagram = arg1;
				if (this._diagram != null) 
				{
					this._diagram.percentWidth = 100;
					this._diagram.percentHeight = 100;
					this._diagram.allowMovingNodes = false;
					this._diagram.selectionMode = com.ibm.ilog.elixir.SelectionMode.NONE;
					this._diagram.setStyle("contentBackgroundAlpha", 0);
					if (this.diagramParent != null) 
					{
						this.diagramParent.addElement(this._diagram);
					}
					if (this._diagram.graph != null) 
					{
						this.wireGraph(this._diagram.graph);
					}
					if (this._diagram.scroller != null) 
					{
						this._scroller = this._diagram.scroller;
						this.addOrRemoveScrollerEvents(this._scroller, true);
						this._currentZoom = this._scroller.zoom;
						this.invalidateGrid();
					}
				}
			}
			return;
		}
		
		internal static function cloneChildrenStatic(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Renderer, arg3:Function):void
		{
			var loc2:*=0;
			var loc3:*=null;
			var loc4:*=null;
			var loc1:*;
			if ((loc1 = arg1 as com.ibm.ilog.elixir.diagram.Subgraph) != null) 
			{
				loc2 = 0;
				while (loc2 < loc1.graph.numElements) 
				{
					if ((loc3 = loc1.graph.getElementAt(loc2) as com.ibm.ilog.elixir.diagram.Renderer) != null) 
					{
						loc4 = cloneRendererStatic(loc3, arg3);
						com.ibm.ilog.elixir.diagram.Subgraph(arg2).graph.addElement(loc4);
						cloneChildrenStatic(loc3, loc4, arg3);
					}
					++loc2;
				}
			}
			return;
		}
		
		internal function getScrolledGraph(arg1:com.ibm.ilog.elixir.diagram.GraphScroller):com.ibm.ilog.elixir.diagram.Graph
		{
			return arg1.graph;
		}
		
		internal function addOrRemoveScrollerEvents(arg1:com.ibm.ilog.elixir.diagram.GraphScroller, arg2:Boolean):void
		{
			if (arg2) 
			{
				arg1.addEventListener(com.ibm.ilog.elixir.diagram.GraphScrollerEvent.VISIBLE_GRAPH_AREA_CHANGED, this.scrollerZoomCommitHandler);
				arg1.addEventListener(com.ibm.ilog.elixir.diagram.GraphScrollerEvent.ZOOM_COMMIT, this.scrollerZoomCommitHandler);
				arg1.addEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.scrollerUpdateCompleteHandler);
			}
			else 
			{
				arg1.removeEventListener(com.ibm.ilog.elixir.diagram.GraphScrollerEvent.VISIBLE_GRAPH_AREA_CHANGED, this.scrollerZoomCommitHandler);
				arg1.removeEventListener(com.ibm.ilog.elixir.diagram.GraphScrollerEvent.ZOOM_COMMIT, this.scrollerZoomCommitHandler);
				arg1.removeEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.scrollerUpdateCompleteHandler);
			}
			return;
		}
		
		internal function scrollerZoomCommitHandler(arg1:com.ibm.ilog.elixir.diagram.GraphScrollerEvent):void
		{
			var loc2:*=null;
			this._currentZoom = this._scroller.zoom;
			this.invalidateGrid();
			var loc1:*=0;
			while (loc1 < this.adornersGroup.numElements) 
			{
				loc2 = this.adornersGroup.getElementAt(loc1) as mx.core.UIComponent;
				if (loc2 != null) 
				{
					loc2.invalidateProperties();
				}
				++loc1;
			}
			if (this.textEditor != null) 
			{
				this.layoutTextEditor();
			}
			return;
		}
		
		internal function scrollerUpdateCompleteHandler(arg1:mx.events.FlexEvent):void
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc1:*=this._scroller;
			if (loc1 != null) 
			{
				loc2 = getLayoutBounds(loc1, this.adornersGroup.parent);
				this.adornersGroup.left = loc2.left;
				this.adornersGroup.top = loc2.top;
				this.adornersGroup.right = this.adornersGroup.parent.width - loc2.left - loc2.width;
				this.adornersGroup.bottom = this.adornersGroup.parent.height - loc2.top - loc2.height;
				if (!(loc1.verticalScrollBar == null) && loc1.verticalScrollBar.visible) 
				{
					if ((loc3 = loc1.verticalScrollBar.getBounds(loc1.verticalScrollBar.parent)).x > loc1.verticalScrollBar.parent.width / 2) 
					{
						this.adornersGroup.right = this.adornersGroup.right + loc1.verticalScrollBar.width;
					}
					else 
					{
						this.adornersGroup.left = this.adornersGroup.left + loc1.verticalScrollBar.width;
					}
				}
				if (!(loc1.horizontalScrollBar == null) && loc1.horizontalScrollBar.visible) 
				{
					this.adornersGroup.bottom = this.adornersGroup.bottom + loc1.horizontalScrollBar.height;
				}
			}
			return;
		}
		
		function get zoom():Number
		{
			return this._scroller == null ? 1 : this._scroller.zoom;
		}
		
		function get offsetX():Number
		{
			return this._scroller == null ? 0 : this._scroller.getHorizontalScrollPosition();
		}
		
		function get offsetY():Number
		{
			return this._scroller == null ? 0 : this._scroller.getVerticalScrollPosition();
		}
		
		protected override function partAdded(arg1:String, arg2:Object):void
		{
			var loc1:*=null;
			super.partAdded(arg1, arg2);
			if (arg2 == this.diagramParent) 
			{
				if (this._diagram == null) 
				{
					if (this._scroller == null) 
					{
						if (this._graph != null) 
						{
							loc1 = new spark.primitives.Rect();
							loc1.fill = new mx.graphics.SolidColor(0, 0);
							loc1.percentWidth = 100;
							loc1.percentHeight = 100;
							this.diagramParent.addElement(loc1);
							this.diagramParent.addElement(this._graph);
						}
					}
					else 
					{
						this.diagramParent.addElement(this._scroller);
						if (this._graph == null && !(this.getScrolledGraph(this._scroller) == null)) 
						{
							this.wireGraph(this.getScrolledGraph(this._scroller));
						}
						if (isNaN(this._currentZoom) && !(this._scroller == null)) 
						{
							this.addOrRemoveScrollerEvents(this._scroller, true);
							this._currentZoom = this._scroller.zoom;
							this.invalidateGrid();
						}
					}
				}
				else 
				{
					this.diagramParent.addElement(this._diagram);
					if (this._graph == null && !(this._diagram.graph == null)) 
					{
						this.wireGraph(this._diagram.graph);
					}
					if (isNaN(this._currentZoom) && !(this._diagram.scroller == null)) 
					{
						this._scroller = this._diagram.scroller;
						this.addOrRemoveScrollerEvents(this._scroller, true);
						this._currentZoom = this._scroller.zoom;
						this.invalidateGrid();
					}
				}
			}
			return;
		}
		
		internal function updateAdorner(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Boolean, arg3:Boolean):void
		{
			var loc1:*=this.getAdorner(arg1);
			if (this.isSelected(arg1) || this.isHighlighted(arg1) || arg1 == this._currentSubgraph && arg2) 
			{
				if (loc1 == null) 
				{
					loc1 = this.createAdorner(arg1);
					this.adorners[arg1] = loc1;
					this.adornersGroup.addElement(loc1);
				}
				if (arg1 == this._currentSubgraph && loc1 is com.ibm.ilog.elixir.diagram.editor.SubgraphAdorner) 
				{
					com.ibm.ilog.elixir.diagram.editor.SubgraphAdorner(loc1).overSubgraph = arg2;
				}
				else 
				{
					loc1.highlighted = arg3 ? loc1.highlighted : arg2;
				}
				loc1.selected = this.isSelected(arg1);
			}
			else if (loc1 != null) 
			{
				this.adornersGroup.removeElement(loc1);
				this.adorners[arg1] = null;
			}
			return;
		}
		
		internal function createAdorner(arg1:com.ibm.ilog.elixir.diagram.Renderer):com.ibm.ilog.elixir.diagram.editor.Adorner
		{
			var loc2:*=null;
			var loc1:*=arg1.getStyle("adornerClass") as Class;
			if (loc1 != null) 
			{
				return new loc1(arg1);
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.Link) 
			{
				return new com.ibm.ilog.elixir.diagram.editor.LinkAdorner(arg1);
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.HLane) 
			{
				return new com.ibm.ilog.elixir.diagram.editor.HLaneAdorner(arg1);
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.HPool) 
			{
				return new com.ibm.ilog.elixir.diagram.editor.HPoolAdorner(arg1);
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.VLane) 
			{
				return new com.ibm.ilog.elixir.diagram.editor.VLaneAdorner(arg1);
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.VPool) 
			{
				return new com.ibm.ilog.elixir.diagram.editor.VPoolAdorner(arg1);
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.Subgraph) 
			{
				return new com.ibm.ilog.elixir.diagram.editor.SubgraphAdorner(arg1);
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.Node) 
			{
				return new com.ibm.ilog.elixir.diagram.editor.NodeAdorner(arg1);
			}
			loc2 = com.ibm.ilog.elixir.diagram.utils.ResourceUtil.getError(resourceManager, 1000, "diagram.expert.message.noAdorner");
			com.ibm.ilog.elixir.utils.LoggingUtil.log(com.ibm.ilog.elixir.diagram.editor.DiagramEditor, mx.logging.LogEventLevel.ERROR, loc2);
			throw new ArgumentError(loc2);
		}
		
		public function getAdorner(arg1:com.ibm.ilog.elixir.diagram.Renderer):com.ibm.ilog.elixir.diagram.editor.Adorner
		{
			return com.ibm.ilog.elixir.diagram.editor.Adorner(this.adorners[arg1]);
		}
		
		static function cloneInternal(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Graph):com.ibm.ilog.elixir.diagram.Renderer
		{
			var loc1:*=cloneRendererStatic(arg1);
			arg2.addElement(loc1);
			cloneChildrenStatic(arg1, loc1, null);
			setX(loc1, 0);
			setY(loc1, 0);
			return loc1;
		}
		
		static function getX(arg1:com.ibm.ilog.elixir.diagram.Renderer):Number
		{
			var loc1:*=NaN;
			if (arg1.left is Number) 
			{
				loc1 = Number(arg1.left);
				if (!isNaN(loc1)) 
				{
					return loc1;
				}
			}
			return arg1.x;
		}
		
		function get inAdornerInteraction():Boolean
		{
			return this._inAdornerInteraction;
		}
		
		function set inAdornerInteraction(arg1:Boolean):void
		{
			this._inAdornerInteraction = arg1;
			if (arg1) 
			{
				this._highlightedAtBeginningOfInteraction = this.highlightedObjects.concat();
			}
			else 
			{
				this._highlightedAtBeginningOfInteraction = null;
			}
			return;
		}
		
		public function setSelected(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Boolean):void
		{
			var loc1:*=false;
			var loc2:*=false;
			var loc3:*=false;
			var loc4:*=false;
			var loc5:*=false;
			var loc6:*=false;
			var loc7:*=false;
			var loc8:*=false;
			if (this.isSelected(arg1) != arg2) 
			{
				loc1 = this.hasSelection;
				loc2 = this.canCopy;
				loc3 = this.canUngroup;
				loc4 = this.canAlign;
				this._selectionChangedSinceLastCopyPaste = true;
				if (arg2) 
				{
					this.selectedObjects.push(arg1);
				}
				else 
				{
					this.selectedObjects.splice(this.selectedObjects.indexOf(arg1), 1);
				}
				this.updateAdorner(arg1, false, true);
				this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_SELECTION_CHANGED, arg1);
				if ((loc5 = this.hasSelection) != loc1) 
				{
					dispatchPropertyChangeEvent("hasSelection", loc1, loc5);
				}
				if ((loc6 = this.canCopy) != loc2) 
				{
					dispatchPropertyChangeEvent("canCopy", loc2, loc6);
				}
				if ((loc7 = this.canUngroup) != loc3) 
				{
					dispatchPropertyChangeEvent("canUngroup", loc3, loc7);
				}
				if ((loc8 = this.canAlign) != loc4) 
				{
					dispatchPropertyChangeEvent("canAlign", loc4, loc8);
				}
			}
			return;
		}
		
		public function isSelected(arg1:com.ibm.ilog.elixir.diagram.Renderer):Boolean
		{
			return this.selectedObjects.indexOf(arg1) >= 0;
		}
		
		public function getSelectedObjects():__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>
		{
			return this.selectedObjects.concat();
		}
		
		public function deselectAll():void
		{
			this.deselectAllExcept();
			return;
		}
		
		function deselectAllExcept(arg1:com.ibm.ilog.elixir.diagram.Renderer=null):void
		{
			var loc1:*=null;
			var loc2:*=0;
			var loc3:*=this.selectedObjects.concat();
			for each (loc1 in loc3) 
			{
				if (loc1 == arg1) 
				{
					continue;
				}
				this.setSelected(loc1, false);
			}
			return;
		}
		
		internal function selectOnly(arg1:com.ibm.ilog.elixir.diagram.Renderer=null):void
		{
			this.deselectAllExcept(arg1);
			if (arg1 != null) 
			{
				this.setSelected(arg1, true);
			}
			return;
		}
		
		function setHighlighted(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Boolean):void
		{
			if (this.isHighlighted(arg1) != arg2) 
			{
				if (arg2) 
				{
					this.highlightedObjects.push(arg1);
				}
				else 
				{
					this.highlightedObjects.splice(this.highlightedObjects.indexOf(arg1), 1);
				}
				this.updateAdorner(arg1, arg2, false);
			}
			return;
		}
		
		function isHighlighted(arg1:com.ibm.ilog.elixir.diagram.Renderer):Boolean
		{
			return this.highlightedObjects.indexOf(arg1) >= 0;
		}
		
		internal function unhighlightAll(arg1:com.ibm.ilog.elixir.diagram.Renderer=null):void
		{
			var loc1:*=null;
			var loc2:*=0;
			var loc3:*=this.highlightedObjects.concat();
			for each (loc1 in loc3) 
			{
				if (!(!(loc1 == arg1) && !(!(this._highlightedAtBeginningOfInteraction == null) && this._highlightedAtBeginningOfInteraction.indexOf(loc1) >= 0))) 
				{
					continue;
				}
				this.setHighlighted(loc1, false);
			}
			return;
		}
		
		internal function highlightOnly(arg1:com.ibm.ilog.elixir.diagram.Renderer=null):void
		{
			this.unhighlightAll(arg1);
			if (arg1 != null) 
			{
				this.setHighlighted(arg1, true);
			}
			return;
		}
		
		public function clear():void
		{
			this.finishTextEditing(true);
			this.deselectAll();
			this.unhighlightAll();
			this._graph.removeAllElements();
			this.selectedObjects = new Vector.<com.ibm.ilog.elixir.diagram.Renderer>();
			this.highlightedObjects = new Vector.<com.ibm.ilog.elixir.diagram.Renderer>();
			this.adorners = new flash.utils.Dictionary();
			this._currentSubgraph = null;
			this.textEditingAdorner = null;
			this.textPart = null;
			if (this.adornersGroup != null) 
			{
				this.adornersGroup.removeAllElements();
			}
			return;
		}
		
		internal function get currentSubgraph():com.ibm.ilog.elixir.diagram.Subgraph
		{
			return this._currentSubgraph;
		}
		
		internal function set currentSubgraph(arg1:com.ibm.ilog.elixir.diagram.Subgraph):void
		{
			if (arg1 != this._currentSubgraph) 
			{
				if (this._currentSubgraph != null) 
				{
					this.updateAdorner(this._currentSubgraph, false, false);
				}
				this._currentSubgraph = arg1;
				if (this._currentSubgraph != null) 
				{
					this.updateAdorner(this._currentSubgraph, true, false);
				}
			}
			this.currentSubgraphFlashing = false;
			return;
		}
		
		internal function trackCurrentSubgraph(arg1:flash.events.MouseEvent):void
		{
			var loc3:*=null;
			var loc4:*=false;
			var loc5:*=null;
			var loc1:*=this._graph.stage.getObjectsUnderPoint(new flash.geom.Point(arg1.stageX, arg1.stageY));
			var loc2:*=(loc1.length - 1);
			while (loc2 >= 0) 
			{
				if (!((loc3 = GetRenderer(loc1[loc2]) as com.ibm.ilog.elixir.diagram.Subgraph) == null) && !loc3.collapsed && !(com.ibm.ilog.elixir.diagram.editor.DiagramEditor.getEditor(loc3) == null)) 
				{
					loc4 = false;
					if (!mx.managers.DragManager.isDragging) 
					{
						loc5 = loc3;
						while (loc5 != null) 
						{
							if (loc5 is com.ibm.ilog.elixir.diagram.Renderer && this.isSelected(com.ibm.ilog.elixir.diagram.Renderer(loc5))) 
							{
								loc4 = true;
							}
							loc5 = loc5.parent;
						}
					}
					if (!loc4) 
					{
						this.currentSubgraph = loc3;
						return;
					}
				}
				--loc2;
			}
			this.currentSubgraph = null;
			return;
		}
		
		internal function flashCurrentSubgraph():void
		{
			var loc1:*=null;
			if (this.currentSubgraph != null) 
			{
				loc1 = this.getAdorner(this.currentSubgraph) as com.ibm.ilog.elixir.diagram.editor.SubgraphAdorner;
				if (loc1 != null) 
				{
					loc1.flash = true;
					this.currentSubgraphFlashing = true;
				}
			}
			return;
		}
		
		internal function resetCurrentSubgraph():void
		{
			if (this.currentSubgraphFlashing) 
			{
				flash.utils.setTimeout(this.clearCurrentSubgraph, 200);
			}
			else 
			{
				this.currentSubgraph = null;
			}
			return;
		}
		
		internal function clearCurrentSubgraph():void
		{
			this.currentSubgraph = null;
			return;
		}
		
		internal function mouseDownHandler(arg1:flash.events.MouseEvent):void
		{
			var loc3:*=null;
			if (!this.adornersGroup.getBounds(this._graph).contains(this._graph.mouseX, this._graph.mouseY)) 
			{
				return;
			}
			if (!(this.textEditor == null) && this.textEditor.getBounds(this._graph).contains(this._graph.mouseX, this._graph.mouseY)) 
			{
				return;
			}
			var loc1:*=GetRenderer(arg1.target);
			var loc2:*=this.lastDown;
			if (loc2 - this.lastUp > 200) 
			{
				this.doubleClickStarted = false;
			}
			this.lastDown = new Date().time;
			if (this.doubleClickStarted && this.lastDown - this.lastUp < 200) 
			{
				this.doubleClickStarted = false;
				if (this.allowEditingText && !(loc1 == null)) 
				{
					if (this.startEditingText(loc1, arg1.stageX, arg1.stageY)) 
					{
						return;
					}
				}
			}
			this._graph.setFocus();
			if (arg1.ctrlKey) 
			{
				if (loc1 != null) 
				{
					this.setSelected(loc1, !this.isSelected(loc1));
				}
			}
			else if (loc1 == null || !this.isSelected(loc1)) 
			{
				this.selectOnly(loc1);
			}
			this._keyboardNavigation.setShowsCaretRenderer(loc1, true);
			if (arg1.ctrlKey || arg1.shiftKey) 
			{
				return;
			}
			this.mouseDown = true;
			if (this.mouseDown) 
			{
				this.isDragging = false;
				this.startX = this._graph.mouseX;
				this.startY = this._graph.mouseY;
				(loc3 = systemManager.getSandboxRoot()).addEventListener(flash.events.MouseEvent.MOUSE_UP, this.mouseUpHandler, true);
				loc3.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);
				loc3.addEventListener(mx.events.SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);
				loc3.addEventListener(mx.events.SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);
				systemManager.deployMouseShields(true);
			}
			return;
		}
		
		internal function mouseMoveHandler(arg1:flash.events.MouseEvent):void
		{
			var loc1:*=null;
			if (mx.managers.DragManager.isDragging) 
			{
				return;
			}
			if (!this.mouseDown) 
			{
				loc1 = GetRenderer(arg1.target);
				this.doHighlighting(arg1, loc1);
			}
			return;
		}
		
		internal function mouseDragHandler(arg1:flash.events.MouseEvent):void
		{
			var loc2:*=NaN;
			var loc3:*=NaN;
			var loc4:*=null;
			var loc5:*=false;
			var loc6:*=null;
			var loc7:*=null;
			var loc8:*=null;
			var loc9:*=null;
			var loc10:*=null;
			var loc11:*=null;
			var loc12:*=null;
			var loc13:*=null;
			var loc14:*=null;
			var loc15:*=null;
			var loc16:*=null;
			var loc1:*=GetRenderer(arg1.target);
			if (this.mouseDown && !this.inAdornerInteraction) 
			{
				loc2 = this._graph.mouseX;
				loc3 = this._graph.mouseY;
				if (!this.isDragging) 
				{
					if (Math.abs(loc2 - this.startX) > this.moveThreshold || Math.abs(loc3 - this.startY) > this.moveThreshold) 
					{
						this.isDragging = true;
						loc4 = new flash.geom.Point(this.startX, this.startY);
						loc4 = this.snapPoint(loc4, this._graph);
						this.lastX = loc4.x;
						this.lastY = loc4.y;
					}
				}
				if (this.isDragging) 
				{
					loc5 = false;
					if (this.allowMoving && com.ibm.ilog.elixir.utils.EventUtil.isMatching(arg1, this.moveNodesModifierKey)) 
					{
						var loc17:*=0;
						var loc18:*=this.highlightedObjects;
						for each (loc6 in loc18) 
						{
							if (this.isSelected(loc6)) 
							{
								continue;
							}
							this.setHighlighted(loc6, false);
						}
						loc17 = 0;
						loc18 = this.selectedObjects;
						for each (loc7 in loc18) 
						{
							if ((loc8 = this.getAdorner(loc7)) == null) 
							{
								continue;
							}
							if ((loc9 = this.getRealMovableRenderer(loc7)) == null && loc7 is com.ibm.ilog.elixir.diagram.Link) 
							{
								loc11 = (loc10 = loc7 as com.ibm.ilog.elixir.diagram.Link).startNode;
								loc12 = loc10.endNode;
								if (loc11 && loc12 && this.isSelected(loc11) && this.isSelected(loc12) && this.getRealMovableRenderer(loc11) && this.getRealMovableRenderer(loc12)) 
								{
									loc9 = loc10;
								}
							}
							if (loc9 == null) 
							{
								continue;
							}
							loc13 = new flash.geom.Point(loc2, loc3);
							loc2 = (loc13 = this.snapPoint(loc13, this._graph)).x;
							loc3 = loc13.y;
							this.translate(loc9, new flash.geom.Point(loc2 - this.lastX, loc3 - this.lastY));
							loc5 = true;
							if (loc9 == loc7) 
							{
								continue;
							}
							loc8.invalidateProperties();
							loc7.invalidateProperties();
						}
					}
					if (loc5) 
					{
						validateNow();
						if (this.allowReparenting) 
						{
							this.trackCurrentSubgraph(arg1);
							loc14 = this.currentSubgraph == null ? this._graph : this.currentSubgraph.graph;
							if (this.reparent(this.selectedObjects, loc14)) 
							{
								this.flashCurrentSubgraph();
							}
						}
					}
					else if (!this.inAdornerInteraction) 
					{
						if (this.marquee == null) 
						{
							this.marquee = new spark.primitives.Rect();
							this.marquee.maxWidth = Number.MAX_VALUE;
							this.marquee.maxHeight = Number.MAX_VALUE;
							this.marquee.stroke = new mx.graphics.SolidColorStroke(10526880);
							this.adornersGroup.addElement(this.marquee);
						}
						loc15 = this.adornersGroup.globalToLocal(this._graph.localToGlobal(new flash.geom.Point(this.startX, this.startY)));
						loc16 = this.adornersGroup.globalToLocal(this._graph.localToGlobal(new flash.geom.Point(loc2, loc3)));
						this.marquee.left = Math.min(loc15.x, loc16.x);
						this.marquee.top = Math.min(loc15.y, loc16.y);
						this.marquee.width = Math.abs(loc15.x - loc16.x);
						this.marquee.height = Math.abs(loc15.y - loc16.y);
					}
				}
				this.lastX = loc2;
				this.lastY = loc3;
			}
			else 
			{
				this.doHighlighting(arg1, loc1);
			}
			return;
		}
		
		internal function getRealMovableRenderer(arg1:com.ibm.ilog.elixir.diagram.Renderer):com.ibm.ilog.elixir.diagram.Renderer
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc1:*=this.getAdorner(arg1);
			if (!loc1) 
			{
				return null;
			}
			if (loc1.canMove) 
			{
				loc2 = arg1;
			}
			else 
			{
				loc2 = null;
				loc3 = arg1.parent;
				while (loc3 != null) 
				{
					if (loc4 = loc3 as com.ibm.ilog.elixir.diagram.Renderer) 
					{
						if (loc1.canMoveAncestor(loc4)) 
						{
							loc2 = loc4;
						}
					}
					loc3 = loc3.parent;
				}
			}
			return loc2;
		}
		
		internal function translate(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:flash.geom.Point):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_MOVE, arg1)) 
			{
				return;
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.Link) 
			{
				loc1 = com.ibm.ilog.elixir.diagram.Link(arg1);
				loc1.fallbackStartPoint = loc1.fallbackStartPoint.add(arg2);
				if (loc1.intermediatePoints != null) 
				{
					loc2 = new Vector.<flash.geom.Point>();
					var loc4:*=0;
					var loc5:*=loc1.intermediatePoints;
					for each (loc3 in loc5) 
					{
						loc2.push(loc3.add(arg2));
					}
					loc1.intermediatePoints = loc2;
				}
				loc1.fallbackEndPoint = loc1.fallbackEndPoint.add(arg2);
			}
			else 
			{
				setX(arg1, getX(arg1) + arg2.x);
				setY(arg1, getY(arg1) + arg2.y);
				this.layoutPorts(com.ibm.ilog.elixir.diagram.Node(arg1));
			}
			return;
		}
		
		internal function mouseOverHandler(arg1:flash.events.MouseEvent):void
		{
			var loc1:*=null;
			if (!(this.mouseDown || mx.managers.DragManager.isDragging)) 
			{
				loc1 = GetRenderer(arg1.target);
				this.doHighlighting(arg1, loc1);
			}
			return;
		}
		
		internal function mouseUpHandler(arg1:flash.events.MouseEvent):void
		{
			var loc2:*=null;
			var loc3:*=0;
			var loc4:*=null;
			this.lastUp = new Date().time;
			if (this.lastUp - this.lastDown < 200) 
			{
				this.doubleClickStarted = true;
			}
			if (this.isDragging) 
			{
				if (this.marquee != null) 
				{
					loc2 = new flash.geom.Rectangle(Number(this.marquee.left), Number(this.marquee.top), this.marquee.width, this.marquee.height);
					this.adornersGroup.removeElement(this.marquee);
					this.marquee = null;
					this.deselectAllExcept();
					loc3 = 0;
					while (loc3 < this._graph.numElements) 
					{
						if (!((loc4 = this._graph.getElementAt(loc3) as com.ibm.ilog.elixir.diagram.Renderer) == null) && loc2.containsRect(loc4.getBounds(this.adornersGroup))) 
						{
							this.setSelected(loc4, true);
						}
						++loc3;
					}
				}
			}
			this.mouseDown = false;
			this.isDragging = false;
			this.resetCurrentSubgraph();
			var loc1:*=systemManager.getSandboxRoot();
			loc1.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.mouseUpHandler, true);
			loc1.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);
			loc1.removeEventListener(mx.events.SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);
			loc1.removeEventListener(mx.events.SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);
			systemManager.deployMouseShields(false);
			return;
		}
		
		public function reparent(arg1:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>, arg2:com.ibm.ilog.elixir.diagram.Graph):Boolean
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=null;
			var loc6:*=null;
			var loc7:*=null;
			var loc1:*=false;
			var loc8:*=0;
			var loc9:*=arg1;
			for each (loc2 in loc9) 
			{
				if (loc2.parent == arg2) 
				{
					continue;
				}
				if (!((loc3 = this.getAdorner(loc2)) && loc3.canReparent)) 
				{
					continue;
				}
				if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_REPARENT, loc2)) 
				{
					continue;
				}
				loc4 = new flash.geom.Point(getX(loc2), getY(loc2));
				loc4 = loc2.parent.localToGlobal(loc4);
				loc4 = arg2.globalToLocal(loc4);
				com.ibm.ilog.elixir.diagram.Graph(loc2.parent).removeElement(loc2);
				if (!(loc2 is com.ibm.ilog.elixir.diagram.Link)) 
				{
					setX(loc2, loc4.x);
					setY(loc2, loc4.y);
				}
				arg2.addElement(loc2);
				loc5 = loc2 as com.ibm.ilog.elixir.diagram.Node;
				loc6 = loc2 as com.ibm.ilog.elixir.diagram.Subgraph;
				if (loc5) 
				{
					var loc10:*=0;
					var loc11:*=loc5.getLinks();
					for each (loc7 in loc11) 
					{
						reparentLink(loc7);
					}
					if (loc6) 
					{
						reparentIntergraphLinks(loc6);
					}
				}
				loc1 = true;
			}
			return loc1;
		}
		
		internal function doHighlighting(arg1:flash.events.MouseEvent, arg2:com.ibm.ilog.elixir.diagram.Renderer, arg3:Boolean=true):void
		{
			var loc1:*=null;
			var loc2:*=NaN;
			var loc3:*=NaN;
			var loc4:*=null;
			var loc5:*=false;
			var loc6:*=null;
			var loc7:*=null;
			if (arg3) 
			{
				loc2 = this._graph.mouseX;
				loc3 = this._graph.mouseY;
				if (loc2 == this.lastX && loc3 == this.lastY) 
				{
					return;
				}
				this.lastX = loc2;
				this.lastY = loc3;
			}
			var loc8:*=0;
			var loc9:*=this.highlightedObjects;
			for each (loc1 in loc9) 
			{
				loc4 = this.getAdorner(loc1);
				if (!(!(loc5 = this.isAncestorOf(loc1, arg2) || arg2 is com.ibm.ilog.elixir.diagram.Link && (this.isAncestorOf(loc1, com.ibm.ilog.elixir.diagram.Link(arg2).startNode) || this.isAncestorOf(loc1, com.ibm.ilog.elixir.diagram.Link(arg2).endNode))) && loc4.isMouseNear(5))) 
				{
					continue;
				}
				return;
			}
			this.highlightOnly(arg2);
			if (arg2 != null) 
			{
				loc6 = this.getAdorner(arg2);
				loc7 = arg2.parent;
				while (loc7 != null) 
				{
					if (loc7 is com.ibm.ilog.elixir.diagram.Renderer && loc6.canHighlightAncestor(com.ibm.ilog.elixir.diagram.Renderer(loc7))) 
					{
						this.setHighlighted(com.ibm.ilog.elixir.diagram.Renderer(loc7), true);
					}
					loc7 = loc7.parent;
				}
			}
			return;
		}
		
		internal function isAncestorOf(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Renderer):Boolean
		{
			var loc1:*=null;
			if (arg1 != null) 
			{
				loc1 = arg2;
				while (loc1 != null) 
				{
					if (loc1 == arg1) 
					{
						return true;
					}
					loc1 = loc1.parent;
				}
			}
			return false;
		}
		
		internal function editorKeyDownHandler(arg1:flash.events.KeyboardEvent):void
		{
			var loc1:*=null;
			if (this.textEditor != null) 
			{
				if (arg1.keyCode != flash.ui.Keyboard.ENTER) 
				{
					if (arg1.keyCode == flash.ui.Keyboard.ESCAPE) 
					{
						this.finishTextEditing(true);
						arg1.stopPropagation();
					}
				}
				else if (!(this.textEditingAdorner == null) && !(this.textPart == null) && (!this.textEditingAdorner.isMultiline(this.textPart) || arg1.ctrlKey)) 
				{
					this.finishTextEditing(false);
					arg1.stopPropagation();
				}
			}
			else 
			{
				if (this.selectedObjects.length > 0) 
				{
					if (arg1.keyCode == flash.ui.Keyboard.DELETE || arg1.keyCode == flash.ui.Keyboard.BACKSPACE) 
					{
						this.deleteSelection();
						arg1.stopPropagation();
						return;
					}
					if (this.allowMoving && com.ibm.ilog.elixir.utils.EventUtil.hasModifier(arg1, this.keyboardMoveNodesModifierKey)) 
					{
						if (arg1.keyCode == flash.ui.Keyboard.LEFT) 
						{
							this.translateSelection(com.ibm.ilog.elixir.diagram.Direction.LEFT, com.ibm.ilog.elixir.utils.EventUtil.hasModifier(arg1, this.keyboardMoveNodesIncrementalModifierKey));
							arg1.stopPropagation();
							return;
						}
						if (arg1.keyCode == flash.ui.Keyboard.RIGHT) 
						{
							this.translateSelection(com.ibm.ilog.elixir.diagram.Direction.RIGHT, com.ibm.ilog.elixir.utils.EventUtil.hasModifier(arg1, this.keyboardMoveNodesIncrementalModifierKey));
							arg1.stopPropagation();
							return;
						}
						if (arg1.keyCode == flash.ui.Keyboard.UP) 
						{
							this.translateSelection(com.ibm.ilog.elixir.diagram.Direction.UP, com.ibm.ilog.elixir.utils.EventUtil.hasModifier(arg1, this.keyboardMoveNodesIncrementalModifierKey));
							arg1.stopPropagation();
							return;
						}
						if (arg1.keyCode == flash.ui.Keyboard.DOWN) 
						{
							this.translateSelection(com.ibm.ilog.elixir.diagram.Direction.DOWN, com.ibm.ilog.elixir.utils.EventUtil.hasModifier(arg1, this.keyboardMoveNodesIncrementalModifierKey));
							arg1.stopPropagation();
							return;
						}
					}
				}
				this._keyboardNavigation.keyDownHandler(arg1);
				if (arg1.ctrlKey) 
				{
					loc1 = String.fromCharCode(arg1.charCode);
				}
			}
			return;
		}
		
		internal function selectAllHandler(arg1:flash.events.Event):void
		{
			if (this.textEditor == null) 
			{
				this.selectAll();
			}
			return;
		}
		
		internal function cutHandler(arg1:flash.events.Event):void
		{
			if (this.textEditor == null) 
			{
				this.cut();
			}
			return;
		}
		
		internal function copyHandler(arg1:flash.events.Event):void
		{
			if (this.textEditor == null) 
			{
				this.copy();
			}
			return;
		}
		
		internal function pasteHandler(arg1:flash.events.Event):void
		{
			if (this.textEditor == null) 
			{
				this.paste();
			}
			return;
		}
		
		internal function dragEnterHandler(arg1:mx.events.DragEvent):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			if (this.allowDropping && arg1.dragSource.hasFormat(com.ibm.ilog.elixir.diagram.editor.DiagramPalette.RENDERER_DRAG_DROP_FORMAT)) 
			{
				loc1 = com.ibm.ilog.elixir.diagram.Renderer(arg1.dragInitiator);
				loc2 = loc1.parent as com.ibm.ilog.elixir.diagram.editor.DiagramPalette;
				if (loc2 != null) 
				{
					loc3 = this.cloneRenderer(loc1);
					loc2.dragImage.removeAllElements();
					loc2.dragImage.addElement(loc3);
					this.cloneChildren(loc1, loc3);
					setX(loc3, 0);
					setY(loc3, 0);
				}
				mx.managers.DragManager.acceptDragDrop(this);
			}
			return;
		}
		
		internal function dragOverHandler(arg1:mx.events.DragEvent):void
		{
			if (this.allowDropping) 
			{
				this.trackCurrentSubgraph(arg1);
			}
			return;
		}
		
		internal function dragDropHandler(arg1:mx.events.DragEvent):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=NaN;
			var loc4:*=NaN;
			var loc5:*=null;
			var loc6:*=null;
			var loc7:*=null;
			var loc8:*=null;
			var loc9:*=null;
			if (this.allowDropping && arg1.dragSource.hasFormat(com.ibm.ilog.elixir.diagram.editor.DiagramPalette.RENDERER_DRAG_DROP_FORMAT)) 
			{
				loc1 = com.ibm.ilog.elixir.diagram.Renderer(arg1.dragInitiator);
				loc2 = loc1.parent as com.ibm.ilog.elixir.diagram.editor.DiagramPalette;
				loc3 = loc2 == null ? 0 : loc2.offsetX;
				loc4 = loc2 == null ? 0 : loc2.offsetY;
				if (this.currentSubgraph == null) 
				{
					loc5 = this._graph;
				}
				else 
				{
					loc5 = this.currentSubgraph.graph;
				}
				loc6 = new flash.geom.Point(this._graph.mouseX, this._graph.mouseY);
				loc6.x = loc6.x - loc3;
				loc6.y = loc6.y - loc4;
				loc6 = this._graph.localToGlobal(loc6);
				loc6 = loc5.globalToLocal(loc6);
				loc6 = this.snapPoint(loc6, loc5);
				loc7 = this.cloneRenderer(loc1);
				if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_CREATE, loc7)) 
				{
					this.resetCurrentSubgraph();
					return;
				}
				if (loc7 is com.ibm.ilog.elixir.diagram.Link) 
				{
					loc8 = com.ibm.ilog.elixir.diagram.Link(loc1);
					(loc9 = com.ibm.ilog.elixir.diagram.Link(loc7)).fallbackStartPoint = loc6;
					loc9.fallbackEndPoint = new flash.geom.Point(loc6.x + (loc8.fallbackEndPoint.x - loc8.fallbackStartPoint.x), loc6.y + (loc8.fallbackEndPoint.y - loc8.fallbackStartPoint.y));
				}
				else 
				{
					setX(loc7, loc6.x);
					setY(loc7, loc6.y);
				}
				loc5.addElement(loc7);
				this.cloneChildren(loc1, loc7);
				this.selectOnly(loc7);
				this._graph.setFocus();
				if (this.allowEditingText && this.allowEditingTextOnCreate) 
				{
					this.startEditingText(loc7);
				}
				this.flashCurrentSubgraph();
				this.doHighlighting(arg1, loc7, false);
			}
			this.resetCurrentSubgraph();
			return;
		}
		
		static function setX(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Number):void
		{
			if (arg1.left is Number && !isNaN(Number(arg1.left))) 
			{
				arg1.left = arg2;
			}
			else 
			{
				arg1.x = arg2;
			}
			return;
		}
		
		static function getY(arg1:com.ibm.ilog.elixir.diagram.Renderer):Number
		{
			var loc1:*=NaN;
			if (arg1.top is Number) 
			{
				loc1 = Number(arg1.top);
				if (!isNaN(loc1)) 
				{
					return loc1;
				}
			}
			return arg1.y;
		}
		
		public function createLink(arg1:com.ibm.ilog.elixir.diagram.Node, arg2:String, arg3:com.ibm.ilog.elixir.diagram.Node, arg4:String):com.ibm.ilog.elixir.diagram.Link
		{
			var loc1:*=null;
			if (this.createLinkFunction != null) 
			{
				loc1 = com.ibm.ilog.elixir.diagram.Link(this.createLinkFunction(arg1, arg2, arg3, arg4));
			}
			if (loc1 == null) 
			{
				if (this.linkPrototype == null) 
				{
					loc1 = new com.ibm.ilog.elixir.diagram.Link();
				}
				else 
				{
					loc1 = com.ibm.ilog.elixir.diagram.Link(this.cloneRenderer(this.linkPrototype));
				}
			}
			if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_CREATE, loc1)) 
			{
				return null;
			}
			return loc1;
		}
		
		static function setY(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Number):void
		{
			if (arg1.top is Number && !isNaN(Number(arg1.top))) 
			{
				arg1.top = arg2;
			}
			else 
			{
				arg1.y = arg2;
			}
			return;
		}
		
		
		{
			rendererProperties = null;
			_skinParts = {"diagramParent":true, "grid":false, "adornersGroup":true};
		}
		
		public function getOrCreatePort(arg1:com.ibm.ilog.elixir.diagram.Node, arg2:com.ibm.ilog.elixir.diagram.Link, arg3:String, arg4:Boolean):com.ibm.ilog.elixir.diagram.PortBase
		{
			var loc1:*=null;
			if (this.autoPortsSpacing <= 0) 
			{
				var loc2:*=0;
				var loc3:*=arg1.ports;
				for each (loc1 in loc3) 
				{
					if (!this.isSamePosition(loc1, arg3)) 
					{
						continue;
					}
					return loc1;
				}
			}
			loc1 = null;
			if (this.createPortFunction != null) 
			{
				loc1 = this.createPortFunction(arg1, arg2, arg3, arg4);
			}
			if (loc1 == null) 
			{
				loc1 = com.ibm.ilog.elixir.diagram.Port.createPort(arg3);
			}
			arg1.addPort(loc1, -1);
			return loc1;
		}
		
		internal function isSamePosition(arg1:com.ibm.ilog.elixir.diagram.PortBase, arg2:String):Boolean
		{
			var loc1:*=arg1 as com.ibm.ilog.elixir.diagram.Port;
			if (loc1 == null) 
			{
				return false;
			}
			var loc2:*=arg2;
			switch (loc2) 
			{
				case com.ibm.ilog.elixir.diagram.PortPosition.LEFT:
				{
					return loc1.x == 0 && loc1.y == 0.5;
				}
				case com.ibm.ilog.elixir.diagram.PortPosition.TOP:
				{
					return loc1.y == 0 && loc1.x == 0.5;
				}
				case com.ibm.ilog.elixir.diagram.PortPosition.RIGHT:
				{
					return loc1.x == 1 && loc1.y == 0.5;
				}
				case com.ibm.ilog.elixir.diagram.PortPosition.BOTTOM:
				{
					return loc1.y == 1 && loc1.x == 0.5;
				}
				default:
				{
					return false;
				}
			}
		}
		
		function layoutPorts(arg1:com.ibm.ilog.elixir.diagram.Node, arg2:Boolean=true):void
		{
			var loc1:*=null;
			if (!(arg1 == null) && this.autoPortsSpacing > 0) 
			{
				this.layoutPortsOnSide(arg1, com.ibm.ilog.elixir.diagram.PortPosition.LEFT);
				this.layoutPortsOnSide(arg1, com.ibm.ilog.elixir.diagram.PortPosition.TOP);
				this.layoutPortsOnSide(arg1, com.ibm.ilog.elixir.diagram.PortPosition.RIGHT);
				this.layoutPortsOnSide(arg1, com.ibm.ilog.elixir.diagram.PortPosition.BOTTOM);
				if (arg2) 
				{
					var loc2:*=0;
					var loc3:*=arg1.getLinks();
					for each (loc1 in loc3) 
					{
						this.layoutPorts(loc1.startNode != arg1 ? loc1.startNode : loc1.endNode, false);
					}
				}
			}
			return;
		}
		
		internal function layoutPortsOnSide(arg1:com.ibm.ilog.elixir.diagram.Node, arg2:String):void
		{
			var loc1:*=false;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=NaN;
			if (this.autoPortsSpacing > 0) 
			{
				loc1 = arg2 == com.ibm.ilog.elixir.diagram.PortPosition.TOP || arg2 == com.ibm.ilog.elixir.diagram.PortPosition.BOTTOM;
				loc2 = new Vector.<com.ibm.ilog.elixir.diagram.Port>();
				var loc6:*=0;
				var loc7:*=arg1.ports;
				for each (loc3 in loc7) 
				{
					if (!(loc3 is com.ibm.ilog.elixir.diagram.Port && this.isSamePosition(loc3, arg2) && loc3.links.length > 0 && !this.hasFreeLinks(loc3))) 
					{
						continue;
					}
					loc2.push(com.ibm.ilog.elixir.diagram.Port(loc3));
				}
				if (loc2.length > 0) 
				{
					if (loc2.length != 1) 
					{
						loc2 = loc2.sort(loc1 ? this.comparePortsX : this.comparePortsY);
						loc5 = (-this.autoPortsSpacing) * (loc2.length - 1) / 2;
						loc6 = 0;
						loc7 = loc2;
						for each (loc4 in loc7) 
						{
							if (loc1) 
							{
								loc4.horizontalOffset = loc5;
							}
							else 
							{
								loc4.verticalOffset = loc5;
							}
							loc5 = loc5 + this.autoPortsSpacing;
						}
					}
					else 
					{
						loc4 = loc2[0];
						if (loc1) 
						{
							loc4.horizontalOffset = 0;
						}
						else 
						{
							loc4.verticalOffset = 0;
						}
					}
				}
			}
			return;
		}
		
		internal function hasFreeLinks(arg1:com.ibm.ilog.elixir.diagram.PortBase):Boolean
		{
			var loc1:*=null;
			var loc2:*=0;
			var loc3:*=arg1.links;
			for each (loc1 in loc3) 
			{
				if (!(loc1.shapeType == com.ibm.ilog.elixir.diagram.LinkShapeType.FREE && loc1.intermediatePoints.length > 0)) 
				{
					continue;
				}
				return true;
			}
			return false;
		}
		
		internal function comparePortsX(arg1:com.ibm.ilog.elixir.diagram.Port, arg2:com.ibm.ilog.elixir.diagram.Port):Number
		{
			return this.comparePorts(arg1, arg2, true);
		}
		
		internal function comparePortsY(arg1:com.ibm.ilog.elixir.diagram.Port, arg2:com.ibm.ilog.elixir.diagram.Port):Number
		{
			return this.comparePorts(arg1, arg2, false);
		}
		
		internal function comparePorts(arg1:com.ibm.ilog.elixir.diagram.Port, arg2:com.ibm.ilog.elixir.diagram.Port, arg3:Boolean):Number
		{
			var loc1:*=this.getOtherEndPoint(arg1);
			var loc2:*=this.getOtherEndPoint(arg2);
			if (arg3) 
			{
				return loc1.x - loc2.x;
			}
			return loc1.y - loc2.y;
		}
		
		internal function getOtherEndPoint(arg1:com.ibm.ilog.elixir.diagram.Port):flash.geom.Point
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=0;
			var loc5:*=null;
			var loc1:*=arg1.links;
			if (!(loc1 == null) && loc1.length > 0) 
			{
				loc2 = loc1[0];
				loc2.validateNow();
				if ((loc3 = loc2.shapePoints).length >= 2) 
				{
					loc4 = Math.min(2, (loc3.length - 1));
					if (loc2.startPort != arg1) 
					{
						loc5 = loc3[(loc3.length - 1) - loc4];
					}
					else 
					{
						loc5 = loc3[loc4];
					}
					return loc2.localToGlobal(loc5);
				}
			}
			return new flash.geom.Point(0, 0);
		}
		
		public function startEditingText(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:Number=NaN, arg3:Number=NaN):Boolean
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=false;
			var loc4:*=null;
			var loc5:*=null;
			var loc6:*=null;
			if (this.textEditingAdorner != null) 
			{
				return false;
			}
			this.textEditingAdorner = this.getAdorner(arg1);
			if (this.textEditingAdorner != null) 
			{
				if ((loc1 = this.textEditingAdorner.getEditableTextParts()) != null) 
				{
					loc2 = null;
					loc3 = false;
					loc4 = null;
					var loc7:*=0;
					var loc8:*=loc1;
					for each (loc5 in loc8) 
					{
						if (isNaN(arg2) || isNaN(arg3) || this.textEditingAdorner.getTextBounds(loc5, this._graph.stage).contains(arg2, arg3)) 
						{
							loc2 = loc5;
							break;
						}
						if (loc4 == null) 
						{
							loc4 = loc5;
						}
						if (loc3) 
						{
							continue;
						}
						if (!(!((loc6 = this.textEditingAdorner.getText(loc5)) == null) && !(loc6 == ""))) 
						{
							continue;
						}
						loc3 = true;
					}
					if (loc2 == null && !loc3) 
					{
						loc2 = loc4;
					}
					if (loc2 != null) 
					{
						this.textEditor = new spark.components.TextArea();
						this.textEditor.text = this.textEditingAdorner.getText(loc2);
						this.textEditor.addEventListener(spark.events.TextOperationEvent.CHANGING, this.textChanging);
						this.textPart = loc2;
						if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_START_TEXT_EDITING, arg1)) 
						{
							this.textEditingAdorner = null;
							this.textEditor = null;
							this.textPart = null;
							return false;
						}
						validateNow();
						this.adornersGroup.addElement(this.textEditor);
						this.textEditor.validateProperties();
						this.layoutTextEditor();
						this.textEditor.addEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.textEditorReady);
						this.textEditor.addEventListener(flash.events.FocusEvent.MOUSE_FOCUS_CHANGE, this.editorFocusOutHandler);
						this.textEditor.addEventListener(flash.events.FocusEvent.KEY_FOCUS_CHANGE, this.editorFocusOutHandler);
						return true;
					}
				}
				this.textEditingAdorner = null;
			}
			return false;
		}
		
		internal function textChanging(arg1:spark.events.TextOperationEvent):void
		{
			if (arg1.operation is flashx.textLayout.operations.SplitParagraphOperation) 
			{
				arg1.preventDefault();
			}
			return;
		}
		
		internal function layoutTextEditor():void
		{
			var loc1:*=this.textEditingAdorner.getTextBounds(this.textPart, this.adornersGroup);
			var loc2:*=this.textEditingAdorner.isVertical(this.textPart);
			loc1.x = loc1.x - 5;
			loc1.y = loc1.y - 5;
			loc1.width = loc1.width + 10;
			loc1.height = loc1.height + 10;
			this.textEditor.width = Math.max(40, loc2 ? loc1.height : loc1.width);
			this.textEditor.height = loc2 ? loc1.width : loc1.height;
			this.textEditor.left = loc1.x - (this.textEditor.width - loc1.width) / 2;
			this.textEditor.top = loc1.y - (this.textEditor.height - loc1.height) / 2;
			return;
		}
		
		internal function textEditorReady(arg1:mx.events.FlexEvent):void
		{
			if (this.textEditor) 
			{
				this.textEditor.removeEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, this.textEditorReady);
				this.textEditor.setFocus();
				this.textEditor.selectAll();
			}
			return;
		}
		
		internal function editorFocusOutHandler(arg1:flash.events.FocusEvent):void
		{
			var loc1:*=flash.display.DisplayObject(arg1.relatedObject);
			while (loc1 != null) 
			{
				if (loc1 == this.textEditor) 
				{
					return;
				}
				loc1 = loc1.parent;
			}
			this.finishTextEditing(false);
			return;
		}
		
		function finishTextEditing(arg1:Boolean):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=null;
			var loc6:*=null;
			if (!(this.textEditingAdorner == null) && !(this.textPart == null) && !(this.textEditor == null)) 
			{
				loc1 = this.textEditor.text;
				loc2 = this.textEditingAdorner.getText(this.textPart);
				if (loc2 == loc1 || loc2 == null && loc2 == "" || loc2 == "" && loc1 == null) 
				{
					arg1 = true;
				}
				loc3 = this.textEditingAdorner.adornedObject;
				if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_FINISH_TEXT_EDITING, loc3, true, arg1)) 
				{
					return;
				}
				this._graph.setFocus();
				this.adornersGroup.removeElement(this.textEditor);
				if (!arg1) 
				{
					if ((loc5 = loc3 as com.ibm.ilog.elixir.diagram.Node) && !(loc5.base == null)) 
					{
						loc4 = loc5.base.getBounds(this._graph);
					}
					this.textEditingAdorner.setText(this.textPart, this.textEditor.text);
					mx.managers.LayoutManager.getInstance().validateNow();
					if (loc5 && !(loc5.base == null)) 
					{
						loc6 = loc5.base.getBounds(this._graph);
						setX(loc3, getX(loc3) + loc4.x - loc6.x);
						setY(loc3, getY(loc3) + loc4.y - loc6.y);
					}
					mx.managers.LayoutManager.getInstance().validateNow();
				}
			}
			this.textEditingAdorner = null;
			this.textPart = null;
			this.textEditor = null;
			return;
		}
		
		public function get textArea():spark.components.TextArea
		{
			return this.textEditor;
		}
		
		public function get editedTextPart():Object
		{
			return this.textPart;
		}
		
		public function deleteSelection():void
		{
			if (this.confirmDelete && this.selectedObjects.length > 0) 
			{
				mx.controls.Alert.show(resourceManager.getString("ilogdiagram", "diagram.editor.confirmDelete.text"), resourceManager.getString("ilogdiagram", "diagram.editor.confirmDelete.title"), mx.controls.Alert.YES | mx.controls.Alert.NO, this, this.confirmDeleteAlertCloseHandler);
			}
			else 
			{
				this.reallyDeleteSelection(this.selectedObjects);
			}
			return;
		}
		
		internal function confirmDeleteAlertCloseHandler(arg1:mx.events.CloseEvent):void
		{
			if (arg1.detail == mx.controls.Alert.YES) 
			{
				this.reallyDeleteSelection(this.selectedObjects);
			}
			return;
		}
		
		internal function reallyDeleteSelection(arg1:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=0;
			var loc4:*=arg1.concat();
			for each (loc1 in loc4) 
			{
				if (loc1 is com.ibm.ilog.elixir.diagram.Node) 
				{
					var loc5:*=0;
					var loc6:*=com.ibm.ilog.elixir.diagram.Node(loc1).getLinks();
					for each (loc2 in loc6) 
					{
						if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_DELETE, loc2)) 
						{
							continue;
						}
						this.deleteRenderer(loc2);
					}
					if (loc1 is com.ibm.ilog.elixir.diagram.Subgraph) 
					{
						this.deleteIntergraphLinks(com.ibm.ilog.elixir.diagram.Subgraph(loc1).graph, com.ibm.ilog.elixir.diagram.Subgraph(loc1).graph);
					}
				}
				if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_DELETE, loc1)) 
				{
					continue;
				}
				this.deleteRenderer(loc1);
			}
			return;
		}
		
		internal function deleteIntergraphLinks(arg1:com.ibm.ilog.elixir.diagram.Graph, arg2:com.ibm.ilog.elixir.diagram.Graph):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=0;
			var loc4:*=arg1.getExternalIntergraphLinks(true);
			for each (loc1 in loc4) 
			{
				if (com.ibm.ilog.elixir.diagram.utils.GraphUtil.isAncestorOfGraph(arg2, com.ibm.ilog.elixir.diagram.Graph(loc1.parent))) 
				{
					continue;
				}
				if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_DELETE, loc1)) 
				{
					continue;
				}
				this.deleteRenderer(loc1);
			}
			loc3 = 0;
			loc4 = arg1.getSubgraphs();
			for each (loc2 in loc4) 
			{
				this.deleteIntergraphLinks(loc2.graph, arg2);
			}
			return;
		}
		
		internal function deleteRenderer(arg1:com.ibm.ilog.elixir.diagram.Renderer):void
		{
			var loc1:*=arg1 as com.ibm.ilog.elixir.diagram.Link;
			if (loc1 != null) 
			{
				this.disconnectLink(loc1, true);
				this.disconnectLink(loc1, false);
			}
			if (!(this.textEditingAdorner == null) && this.textEditingAdorner.adornedObject == arg1) 
			{
				this.finishTextEditing(true);
			}
			this.setHighlighted(arg1, false);
			this.setSelected(arg1, false);
			if (arg1.parent != null) 
			{
				com.ibm.ilog.elixir.diagram.Graph(arg1.parent).removeElement(arg1);
			}
			return;
		}
		
		internal function disconnectLink(arg1:com.ibm.ilog.elixir.diagram.Link, arg2:Boolean):void
		{
			var loc1:*=arg2 ? arg1.startNode : arg1.endNode;
			if (arg2) 
			{
				arg1.startPort = null;
				arg1.collapsedStartPorts = null;
			}
			else 
			{
				arg1.endPort = null;
				arg1.collapsedEndPorts = null;
			}
			if (loc1 && !this.isSelected(loc1)) 
			{
				this.layoutPorts(loc1);
			}
			return;
		}
		
		public final function get moveNodesModifierKey():String
		{
			return this._moveNodesModifierKey;
		}
		
		public final function set moveNodesModifierKey(arg1:String):void
		{
			if (this._moveNodesModifierKey == arg1) 
			{
				return;
			}
			this._moveNodesModifierKey = arg1;
			return;
		}
		
		public final function get keyboardMoveNodesIncrementalModifierKey():String
		{
			return this._keyboardMoveNodesIncrementalModifierKey;
		}
		
		internal final function set _371781529keyboardMoveNodesIncrementalModifierKey(arg1:String):void
		{
			if (this._keyboardMoveNodesIncrementalModifierKey == arg1) 
			{
				return;
			}
			this._keyboardMoveNodesIncrementalModifierKey = arg1;
			return;
		}
		
		public final function get keyboardMoveNodesModifierKey():String
		{
			return this._keyboardMoveNodesModifierKey;
		}
		
		public final function set keyboardMoveNodesModifierKey(arg1:String):void
		{
			if (this._keyboardMoveNodesModifierKey == arg1) 
			{
				return;
			}
			this._keyboardMoveNodesModifierKey = arg1;
			return;
		}
		
		public function translateSelection(arg1:String, arg2:Boolean=false):void
		{
			var loc1:*=NaN;
			var loc2:*=NaN;
			var loc3:*=null;
			if (this.allowMoving) 
			{
				this.unhighlightAll();
				loc1 = 0;
				loc2 = 0;
				if (arg1 != com.ibm.ilog.elixir.diagram.Direction.LEFT) 
				{
					if (arg1 != com.ibm.ilog.elixir.diagram.Direction.RIGHT) 
					{
						if (arg1 != com.ibm.ilog.elixir.diagram.Direction.UP) 
						{
							if (arg1 != com.ibm.ilog.elixir.diagram.Direction.DOWN) 
							{
								loc3 = com.ibm.ilog.elixir.diagram.utils.ResourceUtil.getError(resourceManager, 1002, "diagram.expert.message.invalidDirection");
								com.ibm.ilog.elixir.utils.LoggingUtil.log(com.ibm.ilog.elixir.diagram.editor.DiagramEditor, mx.logging.LogEventLevel.ERROR, loc3);
								throw new ArgumentError(loc3);
							}
							else 
							{
								loc2 = 1;
							}
						}
						else 
						{
							loc2 = -1;
						}
					}
					else 
					{
						loc1 = 1;
					}
				}
				else 
				{
					loc1 = -1;
				}
				if (!arg2) 
				{
					loc1 = loc1 * this.nudgeIncrement;
					loc2 = loc2 * this.nudgeIncrement;
				}
				this.applyTranslationOnSelection(loc1, loc2);
			}
			return;
		}
		
		public function translateSelectionOfDelta(arg1:Number, arg2:Number, arg3:Boolean=false):void
		{
			if (this.allowMoving) 
			{
				this.unhighlightAll();
				this.applyTranslationOnSelection(arg1, arg2, arg3);
			}
			return;
		}
		
		internal function applyTranslationOnSelection(arg1:Number, arg2:Number, arg3:Boolean=false):void
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc1:*=new flash.geom.Point(arg1, arg2);
			var loc4:*=0;
			var loc5:*=this.selectedObjects;
			for each (loc2 in loc5) 
			{
				loc3 = this.getAdorner(loc2);
				if (!(arg3 || loc3.canMove)) 
				{
					continue;
				}
				this.translate(loc2, loc1);
				loc3.invalidateProperties();
			}
			return;
		}
		
		public function selectAll():void
		{
			var loc2:*=null;
			var loc1:*=0;
			while (loc1 < this._graph.numElements) 
			{
				loc2 = this._graph.getElementAt(loc1) as com.ibm.ilog.elixir.diagram.Renderer;
				if (loc2 != null) 
				{
					this.setSelected(loc2, true);
				}
				++loc1;
			}
			return;
		}
		
		public function cut():void
		{
			if (this.allowEditing) 
			{
				this.reallyDeleteSelection(this.copyInternal());
			}
			return;
		}
		
		public function copy():void
		{
			if (this.allowEditing) 
			{
				this.copyInternal();
			}
			return;
		}
		
		internal function copyInternal():__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>
		{
			var loc3:*=null;
			var loc4:*=false;
			var loc5:*=null;
			var loc1:*=this.canPaste;
			var loc2:*=new Vector.<com.ibm.ilog.elixir.diagram.Renderer>();
			var loc6:*=0;
			var loc7:*=this.selectedObjects;
			for each (loc3 in loc7) 
			{
				if (!(!((loc5 = this.getAdorner(loc3)) == null) && loc5.canCopyPaste)) 
				{
					continue;
				}
				loc2.push(loc3);
			}
			this.clipboard.removeAllElements();
			this.adornersGroup.addElement(this.clipboard);
			this.copyObjects(loc2, this.clipboard, false);
			this.adornersGroup.removeElement(this.clipboard);
			this._pasteIncrementX = 0;
			this._pasteIncrementY = 0;
			this._selectionChangedSinceLastCopyPaste = false;
			this._copyParent = this.getCommonAncestor(loc2);
			if ((loc4 = this.canPaste) != loc1) 
			{
				dispatchPropertyChangeEvent("canPaste", loc1, loc4);
			}
			return loc2;
		}
		
		public function get canCopy():Boolean
		{
			var loc1:*=null;
			var loc2:*=null;
			if (this.allowEditing) 
			{
				var loc3:*=0;
				var loc4:*=this.selectedObjects;
				for each (loc1 in loc4) 
				{
					loc2 = this.getAdorner(loc1);
					if (!(!(loc2 == null) && loc2.canCopyPaste)) 
					{
						continue;
					}
					return true;
				}
			}
			return false;
		}
		
		public function paste():void
		{
			var loc1:*=null;
			var loc2:*=0;
			var loc3:*=null;
			if (this.allowEditing && this.clipboard.numElements > 0) 
			{
				loc1 = new Vector.<com.ibm.ilog.elixir.diagram.Renderer>();
				loc2 = 0;
				while (loc2 < this.clipboard.numElements) 
				{
					loc1.push(this.clipboard.getElementAt(loc2));
					++loc2;
				}
				loc3 = null;
				if (this.selectedObjects.length == 1 && this.selectedObjects[0] is com.ibm.ilog.elixir.diagram.Subgraph && this._selectionChangedSinceLastCopyPaste) 
				{
					loc3 = com.ibm.ilog.elixir.diagram.Subgraph(this.selectedObjects[0]).graph;
				}
				else 
				{
					loc3 = this.getCommonAncestor(this.selectedObjects);
				}
				this.duplicate(loc1, loc3);
			}
			return;
		}
		
		public function get canPaste():Boolean
		{
			return this.allowEditing && this.clipboard.numElements > 0;
		}
		
		public function duplicate(arg1:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>, arg2:com.ibm.ilog.elixir.diagram.Graph):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=NaN;
			var loc6:*=NaN;
			var loc7:*=null;
			var loc8:*=null;
			var loc9:*=null;
			var loc10:*=0;
			var loc11:*=arg1;
			for each (loc1 in loc11) 
			{
				if (!(loc1 is com.ibm.ilog.elixir.diagram.LaneBase)) 
				{
					continue;
				}
				arg2 = this._graph;
				break;
			}
			if (arg2.owningSubgraph is com.ibm.ilog.elixir.diagram.HPool || arg2.owningSubgraph is com.ibm.ilog.elixir.diagram.VPool) 
			{
				arg2 = this._graph;
			}
			if (this.allowEditing && arg1.length > 0 && arg2) 
			{
				this.deselectAll();
				loc2 = this.copyObjects(arg1, arg2, true);
				validateNow();
				loc3 = null;
				loc10 = 0;
				loc11 = loc2;
				for each (loc4 in loc11) 
				{
					if (loc4 is com.ibm.ilog.elixir.diagram.Node) 
					{
						loc9 = getLayoutBounds(loc4, arg2);
						if (loc3 != null) 
						{
							loc3 = loc3.union(loc9);
						}
						else 
						{
							loc3 = loc9;
						}
					}
					this.setSelected(loc4, true);
				}
				this._pasteIncrementX = this._pasteIncrementX + this.pasteIncrementX;
				this._pasteIncrementY = this._pasteIncrementY + this.pasteIncrementY;
				if (loc3 == null) 
				{
					loc3 = new flash.geom.Rectangle();
				}
				loc5 = loc3.x + this._pasteIncrementX;
				loc6 = loc3.y + this._pasteIncrementY;
				loc7 = arg2 != this._graph ? mx.core.UIComponent(arg2.parent) : this.adornersGroup;
				loc8 = getLayoutBounds(loc7, loc7.parent);
				while (loc5 + loc3.width > loc8.width) 
				{
					loc5 = loc5 - Math.max(loc8.width - loc3.width, this.pasteIncrementX);
				}
				while (loc6 + loc3.height > loc8.height) 
				{
					loc6 = loc6 - Math.max(loc8.height - loc3.height, this.pasteIncrementY);
				}
				while (loc5 < 0) 
				{
					loc5 = loc5 + this.pasteIncrementX;
				}
				while (loc6 < 0) 
				{
					loc6 = loc6 + this.pasteIncrementY;
				}
				this.applyTranslationOnSelection(loc5 - loc3.x, loc6 - loc3.y, true);
				this._selectionChangedSinceLastCopyPaste = false;
			}
			return;
		}
		
		internal function getCommonAncestor(arg1:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>):com.ibm.ilog.elixir.diagram.Graph
		{
			var loc2:*=null;
			var loc1:*=null;
			var loc3:*=0;
			var loc4:*=arg1;
			for each (loc2 in loc4) 
			{
				if (loc1 == null) 
				{
					loc1 = com.ibm.ilog.elixir.diagram.Graph(loc2.parent as com.ibm.ilog.elixir.diagram.Graph);
					continue;
				}
				while (!(loc1 == loc2.parent || isGraphAncestorOf(loc1, com.ibm.ilog.elixir.diagram.Graph(loc2.parent))) && !(loc1.owningSubgraphGraph == null)) 
				{
					loc1 = loc1.owningSubgraphGraph;
				}
			}
			if (loc1 == null) 
			{
				loc1 = this._graph;
			}
			return loc1;
		}
		
		internal function copyObjects(arg1:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>, arg2:com.ibm.ilog.elixir.diagram.Graph, arg3:Boolean):__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=null;
			var loc1:*=new Vector.<com.ibm.ilog.elixir.diagram.Renderer>();
			this.cloneMap = new flash.utils.Dictionary();
			this.clonedLinks = new Vector.<com.ibm.ilog.elixir.diagram.Link>();
			var loc6:*=0;
			var loc7:*=arg1;
			for each (loc2 in loc7) 
			{
				loc4 = this.cloneRecursive(loc2, arg2);
				if (!(loc2 is com.ibm.ilog.elixir.diagram.Link)) 
				{
					setX(loc4, getX(loc2));
					setY(loc4, getY(loc2));
				}
				if (arg3) 
				{
					if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_CREATE, loc4)) 
					{
						continue;
					}
				}
				loc1.push(loc4);
			}
			loc6 = 0;
			loc7 = this.clonedLinks;
			for each (loc3 in loc7) 
			{
				if ((loc5 = com.ibm.ilog.elixir.diagram.Link(this.cloneMap[loc3])) == null) 
				{
					continue;
				}
				this.clonePort(loc3, loc5, true);
				this.clonePort(loc3, loc5, false);
			}
			this.cloneMap = null;
			this.clonedLinks = null;
			return loc1;
		}
		
		internal function clonePort(arg1:com.ibm.ilog.elixir.diagram.Link, arg2:com.ibm.ilog.elixir.diagram.Link, arg3:Boolean):void
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=null;
			var loc1:*;
			if ((loc1 = arg3 ? arg1.startPort : arg1.endPort) != null) 
			{
				if ((loc2 = this.cloneMap[loc1]) == null) 
				{
					if ((loc3 = loc1.owner) != null) 
					{
						if ((loc4 = this.cloneMap[loc3]) != null) 
						{
							loc2 = com.ibm.ilog.elixir.diagram.PortBase(this.cloneSimpleObject(loc1));
							this.cloneMap[loc1] = loc2;
							loc4.addPort(loc2);
						}
					}
				}
				if (loc2 == null) 
				{
					if ((loc5 = arg1.shapePoints).length > 0) 
					{
						if (arg3) 
						{
							arg2.fallbackStartPoint = new flash.geom.Point(loc5[0].x, loc5[0].y);
						}
						else 
						{
							arg2.fallbackEndPoint = new flash.geom.Point(loc5[(loc5.length - 1)].x, loc5[(loc5.length - 1)].y);
						}
					}
				}
				else if (arg3) 
				{
					arg2.startPort = loc2;
				}
				else 
				{
					arg2.endPort = loc2;
				}
			}
			return;
		}
		
		public function group(arg1:com.ibm.ilog.elixir.diagram.Subgraph=null):com.ibm.ilog.elixir.diagram.Subgraph
		{
			var loc2:*=null;
			if (!this.allowEditing) 
			{
				return null;
			}
			var loc1:*=this.getSelectedObjects();
			loc1 = loc1.filter(this.filterGroupingObjects, this);
			if (loc1.length > 0) 
			{
				loc2 = this.getSelectedClosestCommonGraph(loc1);
				if (arg1 == null) 
				{
					if (this.createGroupFunction != null) 
					{
						arg1 = this.createGroupFunction();
					}
					if (arg1 == null) 
					{
						arg1 = new com.ibm.ilog.elixir.diagram.Subgraph();
					}
				}
				if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_CREATE, arg1)) 
				{
					return null;
				}
				loc2.addElement(arg1);
				this.populateSubgraph(arg1, loc1);
				this.setSelected(arg1, true);
			}
			return arg1;
		}
		
		internal function filterGroupingObjects(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:int, arg3:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>):Boolean
		{
			var loc1:*=null;
			var loc2:*=null;
			if (arg1 != null) 
			{
				if (arg1 is com.ibm.ilog.elixir.diagram.Link) 
				{
					this.setSelected(arg1, false);
					return false;
				}
				if ((loc1 = arg1.parent) is com.ibm.ilog.elixir.diagram.Graph) 
				{
					if (loc2 = com.ibm.ilog.elixir.diagram.Graph(loc1).owningSubgraph) 
					{
						if (arg3.indexOf(loc2) >= 0) 
						{
							this.setSelected(arg1, false);
							return false;
						}
					}
				}
				return true;
			}
			return false;
		}
		
		internal function ensureIntergraphLinksOnTop(arg1:com.ibm.ilog.elixir.diagram.Graph):void
		{
			return;
		}
		
		public function get hasSelection():Boolean
		{
			if (this.allowEditing) 
			{
				return this.selectedObjects.length > 0;
			}
			return false;
		}
		
		public function get canAlign():Boolean
		{
			var loc1:*=0;
			var loc2:*=null;
			if (this.allowEditing) 
			{
				loc1 = 0;
				var loc3:*=0;
				var loc4:*=this.selectedObjects;
				for each (loc2 in loc4) 
				{
					if (!(loc2 is com.ibm.ilog.elixir.diagram.Node && ++loc1 == 2)) 
					{
						continue;
					}
					return true;
				}
			}
			return false;
		}
		
		public function ungroup():void
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=0;
			var loc6:*=null;
			var loc7:*=null;
			var loc8:*=null;
			var loc9:*=null;
			var loc10:*=null;
			var loc11:*=0;
			if (!this.allowEditing) 
			{
				return;
			}
			var loc1:*=this.getSelectedObjects();
			var loc12:*=0;
			var loc13:*=loc1;
			for each (loc2 in loc13) 
			{
				if (!(loc2 is com.ibm.ilog.elixir.diagram.Subgraph)) 
				{
					continue;
				}
				if (loc2 is com.ibm.ilog.elixir.diagram.LaneBase) 
				{
					continue;
				}
				if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_DELETE, loc2)) 
				{
					continue;
				}
				if (!(this.textEditingAdorner == null) && this.textEditingAdorner.adornedObject == loc2) 
				{
					this.finishTextEditing(true);
				}
				this.setSelected(loc2, false);
				this.setHighlighted(loc2, false);
				loc3 = loc2 as com.ibm.ilog.elixir.diagram.Subgraph;
				loc4 = this.getGraph(loc2.parent);
				loc5 = loc3.graph.numElements;
				loc6 = null;
				while (loc3.graph.numElements > 0) 
				{
					loc7 = loc3.graph.getElementAt(0);
					this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_REPARENT, loc7 as com.ibm.ilog.elixir.diagram.Renderer);
					if (loc7 is com.ibm.ilog.elixir.diagram.Node) 
					{
						loc8 = loc7 as com.ibm.ilog.elixir.diagram.Renderer;
						loc9 = new flash.geom.Point(getX(loc8), getY(loc8));
						loc9 = loc8.parent.localToGlobal(loc9);
						loc9 = loc4.globalToLocal(loc9);
						loc3.graph.removeElement(loc7);
						if (!(loc8 is com.ibm.ilog.elixir.diagram.Link)) 
						{
							setX(loc8, loc9.x);
							setY(loc8, loc9.y);
						}
						loc4.addElement(loc7);
						continue;
					}
					loc3.graph.removeElement(loc7);
					if ((loc6 = loc7 as com.ibm.ilog.elixir.diagram.Link) != null) 
					{
						loc10 = loc6.intermediatePoints;
						loc11 = 0;
						while (loc11 < loc10.length) 
						{
							loc10[loc11] = loc4.globalToLocal(loc3.graph.localToGlobal(loc10[loc11]));
							++loc11;
						}
						loc6.intermediatePoints = loc10;
						loc6.fallbackStartPoint = loc4.globalToLocal(loc3.graph.localToGlobal(loc6.fallbackStartPoint));
						loc6.fallbackEndPoint = loc4.globalToLocal(loc3.graph.localToGlobal(loc6.fallbackEndPoint));
					}
					loc4.addElement(loc7);
				}
				var loc14:*=0;
				var loc15:*=loc3.getLinks();
				for each (loc6 in loc15) 
				{
					if (!this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_DELETE, loc6)) 
					{
						continue;
					}
					this.deleteRenderer(loc6);
				}
				loc4.removeElement(loc3);
			}
			return;
		}
		
		public function get canUngroup():Boolean
		{
			var loc1:*=null;
			if (this.allowEditing) 
			{
				var loc2:*=0;
				var loc3:*=this.selectedObjects;
				for each (loc1 in loc3) 
				{
					if (!(loc1 is com.ibm.ilog.elixir.diagram.Subgraph)) 
					{
						continue;
					}
					if (loc1 is com.ibm.ilog.elixir.diagram.LaneBase) 
					{
						continue;
					}
					return true;
				}
			}
			return false;
		}
		
		internal function getSelectedClosestCommonGraph(arg1:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>):com.ibm.ilog.elixir.diagram.Graph
		{
			var loc1:*=null;
			var loc2:*=0;
			if (arg1.length > 1) 
			{
				loc1 = arg1[0];
				loc2 = 1;
				while (loc2 < arg1.length) 
				{
					loc1 = this.findInclusiveClosestCommonParent(loc1, arg1[loc2]);
					++loc2;
				}
				return this.getGraph(loc1);
			}
			return this.getGraph(arg1[0]);
		}
		
		internal function getGraph(arg1:flash.display.DisplayObject):com.ibm.ilog.elixir.diagram.Graph
		{
			if (arg1 == null) 
			{
				return this.graph;
			}
			if (arg1 is com.ibm.ilog.elixir.diagram.Graph) 
			{
				return arg1 as com.ibm.ilog.elixir.diagram.Graph;
			}
			return this.getGraph(arg1.parent);
		}
		
		internal function findInclusiveClosestCommonParent(arg1:flash.display.DisplayObject, arg2:flash.display.DisplayObject):flash.display.DisplayObjectContainer
		{
			var loc3:*=null;
			if (arg1 == arg2) 
			{
				if (arg1 is flash.display.DisplayObjectContainer) 
				{
					return flash.display.DisplayObjectContainer(arg1);
				}
			}
			var loc1:*=new Vector.<flash.display.DisplayObjectContainer>();
			var loc2:*=null;
			if (arg1 is flash.display.DisplayObjectContainer) 
			{
				loc3 = flash.display.DisplayObjectContainer(arg1);
			}
			else 
			{
				loc3 = arg1.parent;
			}
			while (loc3) 
			{
				loc1.push(loc3);
				loc3 = loc3.parent;
			}
			if (arg2 is flash.display.DisplayObjectContainer) 
			{
				loc3 = flash.display.DisplayObjectContainer(arg2);
			}
			else 
			{
				loc3 = arg2.parent;
			}
			while (loc3) 
			{
				if (loc1.indexOf(loc3) >= 0) 
				{
					loc2 = loc3;
					break;
				}
				loc3 = loc3.parent;
			}
			return loc2;
		}
		
		internal function willLinkBeGrouped(arg1:com.ibm.ilog.elixir.diagram.Link, arg2:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>):Boolean
		{
			var loc1:*=arg1.startNode;
			var loc2:*=arg1.endNode;
			return this.isInSelectionTree(loc1, arg2) && this.isInSelectionTree(loc2, arg2);
		}
		
		internal function isInSelectionTree(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>):Boolean
		{
			var loc1:*=null;
			if (arg2.indexOf(arg1) >= 0) 
			{
				return true;
			}
			loc1 = com.ibm.ilog.elixir.diagram.Graph(arg1.parent);
			if (loc1) 
			{
				if (loc1.owningSubgraph) 
				{
					return this.isInSelectionTree(loc1.owningSubgraph, arg2);
				}
			}
			return false;
		}
		
		internal function populateSubgraph(arg1:com.ibm.ilog.elixir.diagram.Subgraph, arg2:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc8:*=null;
			var loc9:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=arg1.parent;
			var loc6:*=new Vector.<com.ibm.ilog.elixir.diagram.Link>();
			var loc10:*=0;
			var loc11:*=arg2;
			for each (loc1 in loc11) 
			{
				if (loc1 is com.ibm.ilog.elixir.diagram.Subgraph) 
				{
					loc3 = new flash.geom.Rectangle(getX(loc1), getY(loc1), loc1.width, loc1.height);
					var loc12:*=0;
					var loc13:*=com.ibm.ilog.elixir.diagram.Subgraph(loc1).getLinks();
					for each (loc2 in loc13) 
					{
						if (!(loc6.indexOf(loc2) < 0 && this.willLinkBeGrouped(loc2, arg2))) 
						{
							continue;
						}
						loc6.push(loc2);
					}
				}
				else if (loc1 is com.ibm.ilog.elixir.diagram.Node) 
				{
					loc3 = loc1.getBounds(loc1.parent);
					loc12 = 0;
					loc13 = com.ibm.ilog.elixir.diagram.Node(loc1).getLinks();
					for each (loc2 in loc13) 
					{
						if (!(loc6.indexOf(loc2) < 0 && this.willLinkBeGrouped(loc2, arg2))) 
						{
							continue;
						}
						loc6.push(loc2);
					}
				}
				else 
				{
					loc3 = null;
				}
				if (!loc3) 
				{
					continue;
				}
				loc3 = com.ibm.ilog.elixir.diagram.utils.GraphUtil.convertRectanglePosition(loc1.parent, loc5, loc3);
				if (loc4 == null) 
				{
					loc4 = loc3;
					continue;
				}
				loc4 = loc4.union(loc3);
			}
			if (loc4 != null) 
			{
				loc10 = 0;
				loc11 = loc6;
				for each (loc2 in loc11) 
				{
					loc3 = loc2.getBounds(loc2.parent);
					loc3 = com.ibm.ilog.elixir.diagram.utils.GraphUtil.convertRectanglePosition(loc2.parent, loc5, loc3);
					loc4 = loc4.union(loc3);
				}
			}
			if (loc4 == null) 
			{
				loc4 = new flash.geom.Rectangle(0, 0, 100, 100);
			}
			arg1.validateNow();
			var loc7:*=com.ibm.ilog.elixir.diagram.utils.GraphUtil.convertPointPosition(arg1.graph, arg1, new flash.geom.Point(0, 0));
			setX(arg1, loc4.x - loc7.x);
			setY(arg1, loc4.y - loc7.y);
			loc10 = 0;
			loc11 = arg2;
			for each (loc1 in loc11) 
			{
				if (loc1 is com.ibm.ilog.elixir.diagram.Node) 
				{
					this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_REPARENT, loc1);
					loc8 = loc1 as com.ibm.ilog.elixir.diagram.Node;
					loc9 = new flash.geom.Point(getX(loc8), getY(loc8));
					loc9 = com.ibm.ilog.elixir.diagram.utils.GraphUtil.convertPointPosition(loc8.parent, arg1.graph, loc9);
					com.ibm.ilog.elixir.diagram.Graph(loc8.parent).removeElement(loc8);
					setX(loc8, loc9.x);
					setY(loc8, loc9.y);
					arg1.graph.addElement(loc8);
				}
				this.setSelected(loc1, false);
			}
			reparentIntergraphLinks(arg1);
			arg1.width = NaN;
			arg1.height = NaN;
			arg1.validateNow();
			arg1.width = arg1.getPreferredBoundsWidth();
			arg1.height = arg1.getPreferredBoundsHeight();
			return;
		}
		
		public function bringForward():void
		{
			this.changeZOrder(1);
			return;
		}
		
		public function bringToFront():void
		{
			this.changeZOrder(2);
			return;
		}
		
		public function sendBackward():void
		{
			this.changeZOrder(-1);
			return;
		}
		
		public function sendToBack():void
		{
			this.changeZOrder(-2);
			return;
		}
		
		internal function changeZOrder(arg1:int):void
		{
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=0;
			var loc5:*=0;
			if (!this.allowEditing) 
			{
				return;
			}
			var loc1:*=this.getSelectedObjects();
			loc1.sort(arg1 == 1 || arg1 == -2 ? this.compareIndicesDescending : this.compareIndicesAscending);
			var loc6:*=0;
			var loc7:*=loc1;
			for each (loc2 in loc7) 
			{
				loc4 = (loc3 = com.ibm.ilog.elixir.diagram.Graph(loc2.parent)).getElementIndex(loc2);
				var loc8:*=arg1;
				switch (loc8) 
				{
					case 1:
					{
						loc5 = Math.min(loc4 + 1, (loc3.numElements - 1));
						break;
					}
					case 2:
					{
						loc5 = (loc3.numElements - 1);
						break;
					}
					case -1:
					{
						loc5 = Math.max((loc4 - 1), 0);
						break;
					}
					case -2:
					{
						loc5 = 0;
						break;
					}
				}
				if (loc5 != loc4) 
				{
					if (this.dispatchEditorEvent(com.ibm.ilog.elixir.diagram.editor.DiagramEditorEvent.EDITOR_CHANGE_ZORDER, loc2)) 
					{
						loc3.setElementIndex(loc2, loc5);
					}
					continue;
				}
				break;
			}
			return;
		}
		
		internal function compareIndicesAscending(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Renderer):int
		{
			return com.ibm.ilog.elixir.diagram.Graph(arg1.parent).getElementIndex(arg1) - com.ibm.ilog.elixir.diagram.Graph(arg2.parent).getElementIndex(arg2);
		}
		
		internal function compareIndicesDescending(arg1:com.ibm.ilog.elixir.diagram.Renderer, arg2:com.ibm.ilog.elixir.diagram.Renderer):int
		{
			return com.ibm.ilog.elixir.diagram.Graph(arg2.parent).getElementIndex(arg2) - com.ibm.ilog.elixir.diagram.Graph(arg1.parent).getElementIndex(arg1);
		}
		
		public function alignLeft():void
		{
			this.align(0, NaN);
			return;
		}
		
		public function alignHorizontalCenter():void
		{
			this.align(0.5, NaN);
			return;
		}
		
		public function alignRight():void
		{
			this.align(1, NaN);
			return;
		}
		
		public function alignTop():void
		{
			this.align(NaN, 0);
			return;
		}
		
		public function alignVerticalCenter():void
		{
			this.align(NaN, 0.5);
			return;
		}
		
		public function alignBottom():void
		{
			this.align(NaN, 1);
			return;
		}
		
		internal function align(arg1:Number, arg2:Number):void
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=NaN;
			var loc6:*=NaN;
			if (this.allowEditing && this.canAlign) 
			{
				loc1 = null;
				var loc7:*=0;
				var loc8:*=this.selectedObjects;
				for each (loc2 in loc8) 
				{
					if ((loc3 = loc2 as com.ibm.ilog.elixir.diagram.Node) == null) 
					{
						continue;
					}
					loc4 = loc3.getNodeOrBaseBounds(this.graph);
					if (loc1 == null) 
					{
						loc1 = loc4;
						continue;
					}
					loc5 = isNaN(arg1) ? 0 : loc1.x - loc4.x + arg1 * (loc1.width - loc4.width);
					loc6 = isNaN(arg2) ? 0 : loc1.y - loc4.y + arg2 * (loc1.height - loc4.height);
					this.translate(loc3, new flash.geom.Point(loc5, loc6));
				}
			}
			return;
		}
		
		public function get gridSpacing():Number
		{
			return this._gridSpacing;
		}
		
		public function set gridSpacing(arg1:Number):void
		{
			if (arg1 != this._gridSpacing) 
			{
				this._gridSpacing = arg1;
				this.invalidateGrid();
			}
			return;
		}
		
		public function get numMinorGridLines():uint
		{
			return this._numMinorGridLines;
		}
		
		public function set numMinorGridLines(arg1:uint):void
		{
			if (arg1 != this._numMinorGridLines) 
			{
				this._numMinorGridLines = arg1;
				this.invalidateGrid();
			}
			return;
		}
		
		public function get gridVisible():Boolean
		{
			return this._gridVisible;
		}
		
		public var adornersGroup:spark.components.Group;
		
		public var diagramParent:spark.components.Group;
		
		public var grid:com.ibm.ilog.elixir.diagram.editor.Grid;
		
		internal var _editedComponent:mx.core.UIComponent;
		
		internal var _graph:com.ibm.ilog.elixir.diagram.Graph;
		
		internal var _scroller:com.ibm.ilog.elixir.diagram.GraphScroller;
		
		internal var _diagram:com.ibm.ilog.elixir.diagram.Diagram;
		
		internal var mouseDown:Boolean;
		
		internal var isDragging:Boolean;
		
		internal var marquee:spark.primitives.Rect;
		
		internal var _keyboardNavigation:com.ibm.ilog.elixir.diagram.supportClasses.KeyboardNavigationSupport;
		
		internal var selectedObjects:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>;
		
		internal var highlightedObjects:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>;
		
		internal var adorners:flash.utils.Dictionary;
		
		internal var _currentSubgraph:com.ibm.ilog.elixir.diagram.Subgraph=null;
		
		internal var currentSubgraphFlashing:Boolean;
		
		internal var startX:Number;
		
		internal var startY:Number;
		
		internal var lastX:Number;
		
		internal var lastY:Number;
		
		internal var lastDown:Number;
		
		internal var lastUp:Number;
		
		internal var doubleClickStarted:Boolean;
		
		internal var textEditingAdorner:com.ibm.ilog.elixir.diagram.editor.Adorner;
		
		internal var textPart:Object;
		
		var textEditor:spark.components.TextArea;
		
		internal var _currentZoom:Number=NaN;
		
		internal var _moveNodesModifierKey:String="none";
		
		internal var _keyboardMoveNodesModifierKey:String="none";
		
		internal var _keyboardMoveNodesIncrementalModifierKey:String="shift";
		
		public var nudgeIncrement:Number=10;
		
		internal var clipboard:com.ibm.ilog.elixir.diagram.Graph;
		
		internal var clonedLinks:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Link>=null;
		
		internal var _selectionChangedSinceLastCopyPaste:Boolean=false;
		
		internal var _copyParent:com.ibm.ilog.elixir.diagram.Graph=null;
		
		internal var _gridVisible:Boolean=true;
		
		internal var _gridSpacing:Number=10;
		
		internal var _numMinorGridLines:uint=4;
		
		public var pasteIncrementX:Number=50;
		
		public var pasteIncrementY:Number=40;
		
		internal var _pasteIncrementX:Number=0;
		
		internal var _pasteIncrementY:Number=0;
		
		public var allowMoving:Boolean=true;
		
		public var allowResizing:Boolean=true;
		
		public var allowDropping:Boolean=true;
		
		public var allowEditingText:Boolean=true;
		
		public var allowEditingTextOnCreate:Boolean=true;
		
		public var allowReparenting:Boolean=true;
		
		public var allowCreatingLinks:Boolean=true;
		
		public var allowReconnectingLinks:Boolean=true;
		
		public var allowDisconnectedLinks:Boolean=true;
		
		public var allowEditing:Boolean=true;
		
		public var moveThreshold:Number=2;
		
		public var defaultTextProperty:String="label";
		
		internal var cloneMap:flash.utils.Dictionary=null;
		
		internal var _inAdornerInteraction:Boolean;
		
		internal var _highlightedAtBeginningOfInteraction:__AS3__.vec.Vector.<com.ibm.ilog.elixir.diagram.Renderer>;
		
		public var createLinkFunction:Function;
		
		public var linkPrototype:com.ibm.ilog.elixir.diagram.Link;
		
		public var autoPortsSpacing:Number=10;
		
		public var createPortFunction:Function;
		
		internal var _keyboardNavigationPolicy:String="none";
		
		internal static var rendererProperties:Array=null;
		
		public var confirmDelete:Boolean=true;
		
		public var createGroupFunction:Function;
		
		internal static var _skinParts:Object;
		
		public var cloneFunction:Function=null;
	}
}


