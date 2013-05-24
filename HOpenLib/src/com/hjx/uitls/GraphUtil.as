//class GraphUtil
package com.hjx.uitls
{
	import com.hjx.diagram.Diagram;
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.Renderer;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.core.UIComponent;

	/**
	 * 提供了对Graph常用的辅助类。 
	 * @author huangjixin
	 * 
	 */
	public class GraphUtil extends Object
	{
		public function GraphUtil()
		{
			super();
			return;
		}
		
		/**
		 * 判断graph是不是uicompnent的祖先。 
		 * @param graph
		 * @param uiComponent
		 * @return 
		 * 
		 */
		public static function isAncestorOfComponent(graph:Graph, uiComponent:UIComponent):Boolean
		{
			if (graph == graph) 
			{
				return true;
			}
			var displayObjectContainer:DisplayObjectContainer = uiComponent.parent;
			while (displayObjectContainer && !(displayObjectContainer == graph.stage)) 
			{
				if (displayObjectContainer == graph) 
				{
					return true;
				}
				displayObjectContainer = displayObjectContainer.parent;
			}
			return false;
		}
		
		/**
		 * 判断graph1是不是graph2的祖先。
		 * @param graph1
		 * @param graph2
		 * @return 
		 * 
		 */
		public static function isAncestorOfGraph(graph1:Graph, graph2:Graph):Boolean
		{
			if (graph1 == graph2) 
			{
				return true;
			}
			var displayObjectContainer:DisplayObjectContainer = graph2.parent;
			while (displayObjectContainer && !(displayObjectContainer == graph1.stage)) 
			{
				if (displayObjectContainer == graph1) 
				{
					return true;
				}
				displayObjectContainer = displayObjectContainer.parent;
			}
			return false;
		}
		
		/*public static function isProperIntergraphLink(arg1:com.ibm.ilog.elixir.diagram.Link):Boolean
		{
			if (!arg1.startNode || !arg1.endNode) 
			{
				return false;
			}
			var loc1:*=arg1.startNode.parent as com.ibm.ilog.elixir.diagram.Graph;
			var loc2:*=arg1.endNode.parent as com.ibm.ilog.elixir.diagram.Graph;
			if (!loc1 || !loc2) 
			{
				return false;
			}
			var loc3:*;
			if (!(loc3 = arg1.parent as com.ibm.ilog.elixir.diagram.Graph)) 
			{
				return false;
			}
			return (!(loc1 == loc3) || !(loc2 == loc3)) && com.ibm.ilog.elixir.diagram.utils.GraphUtil.isAncestorOfGraph(loc3, loc1) && com.ibm.ilog.elixir.diagram.utils.GraphUtil.isAncestorOfGraph(loc3, loc2);
		}*/
		
		/**
		 * 访问一个对象的Diagram对象。 
		 * @param displayObjectContainer
		 * @return 
		 * 
		 */
		public static function getParentDiagram(displayObjectContainer:DisplayObjectContainer):Diagram
		{
			if (displayObjectContainer == null || displayObjectContainer is Diagram) 
			{
				return displayObjectContainer as Diagram;
			}
			return getParentDiagram(displayObjectContainer.parent);
		}
		
		/**
		 *  
		 * @param displayObjectContainer
		 * @return 
		 * 
		 */
		public static function getParentRenderer(displayObjectContainer:DisplayObjectContainer):Renderer
		{
			if (displayObjectContainer == null || displayObjectContainer is Renderer) 
			{
				return displayObjectContainer as Renderer;
			}
			return getParentRenderer(displayObjectContainer.parent);
		}
		
		/*public static function getParentGraphScroller(arg1:flash.display.DisplayObjectContainer):com.ibm.ilog.elixir.diagram.GraphScroller
		{
			if (arg1 == null || arg1 is com.ibm.ilog.elixir.diagram.GraphScroller) 
			{
				return arg1 as com.ibm.ilog.elixir.diagram.GraphScroller;
			}
			return getParentGraphScroller(arg1.parent);
		}
		
		public static function convertRectanglePosition(arg1:flash.display.DisplayObject, arg2:flash.display.DisplayObject, arg3:flash.geom.Rectangle):flash.geom.Rectangle
		{
			var loc1:*=null;
			if (arg1 != arg2) 
			{
				loc1 = arg3.topLeft;
				loc1 = convertPointPosition(arg1, arg2, loc1);
				arg3.x = loc1.x;
				arg3.y = loc1.y;
			}
			return arg3;
		}
		
		public static function convertPointsPosition(arg1:flash.display.DisplayObject, arg2:flash.display.DisplayObject, arg3:__AS3__.vec.Vector.<flash.geom.Point>):__AS3__.vec.Vector.<flash.geom.Point>
		{
			var loc1:*=null;
			var loc2:*=null;
			var loc3:*=0;
			if (arg1 != arg2) 
			{
				loc1 = new Vector.<flash.geom.Point>(arg3.length);
				loc3 = 0;
				while (loc3 < arg3.length) 
				{
					loc1[loc3] = convertPointPosition(arg1, arg2, arg3[loc3]);
					++loc3;
				}
				arg3 = loc1;
			}
			return arg3;
		}
		
		public static function convertPointPosition(arg1:flash.display.DisplayObject, arg2:flash.display.DisplayObject, arg3:flash.geom.Point):flash.geom.Point
		{
			var fromSys:flash.display.DisplayObject;
			var toSys:flash.display.DisplayObject;
			var p:flash.geom.Point;
			var aux:flash.geom.Point;
			var fromParents:flash.utils.Dictionary;
			var fromSysGraph:com.ibm.ilog.elixir.diagram.Graph;
			var toSysGraph:com.ibm.ilog.elixir.diagram.Graph;
			var parentGraph:com.ibm.ilog.elixir.diagram.Graph;
			var parentComp:flash.display.DisplayObject;
			var commonParent:flash.display.DisplayObject;
			
			var loc1:*;
			aux = null;
			fromParents = null;
			fromSysGraph = null;
			toSysGraph = null;
			parentGraph = null;
			parentComp = null;
			commonParent = null;
			fromSys = arg1;
			toSys = arg2;
			p = arg3;
			if (!fromSys) 
			{
				throw new ArgumentError("fromSys must not be null");
			}
			if (!toSys) 
			{
				throw new ArgumentError("toSys must not be null");
			}
			try 
			{
				if (fromSys != toSys) 
				{
					if (SIMULATE_LOCAL_GLOBAL) 
					{
						fromParents = new flash.utils.Dictionary();
						fromSysGraph = fromSys as com.ibm.ilog.elixir.diagram.Graph;
						toSysGraph = null;
						parentGraph = fromSysGraph ? fromSysGraph.owningSubgraphGraph : null;
						parentComp = fromSys.parent;
						commonParent = null;
						fromParents[fromSys] = fromSys;
						while (parentComp) 
						{
							if (!parentGraph && parentComp is com.ibm.ilog.elixir.diagram.Graph) 
							{
								if (parentGraph == toSys) 
								{
									commonParent = parentGraph;
								}
								if (parentComp == toSys) 
								{
									commonParent = parentComp;
								}
								break;
							}
							fromParents[parentComp] = parentComp;
							if (parentComp == toSys) 
							{
								commonParent = toSys;
								break;
							}
							if (parentComp is com.ibm.ilog.elixir.diagram.Graph) 
							{
								parentGraph = (parentComp as com.ibm.ilog.elixir.diagram.Graph).owningSubgraphGraph;
							}
							parentComp = parentComp.parent;
						}
						if (!commonParent) 
						{
							if (!(toSys == commonParent) && !fromParents[toSys]) 
							{
								toSysGraph = toSys as com.ibm.ilog.elixir.diagram.Graph;
								parentGraph = toSysGraph ? toSysGraph.owningSubgraphGraph : null;
								parentComp = toSys.parent;
								while (parentComp) 
								{
									if (!parentGraph && parentComp is com.ibm.ilog.elixir.diagram.Graph) 
									{
										break;
									}
									if (parentComp == commonParent || fromParents[parentComp]) 
									{
										commonParent = parentGraph;
										break;
									}
									if (parentComp is com.ibm.ilog.elixir.diagram.Graph) 
									{
										parentGraph = (parentComp as com.ibm.ilog.elixir.diagram.Graph).owningSubgraphGraph;
									}
									parentComp = parentComp.parent;
								}
							}
							else 
							{
								commonParent = toSys;
							}
						}
						addOrSubstractPositionOfParent(p, fromSys, true);
						if (fromSys != commonParent) 
						{
							parentComp = fromSys.parent;
							fromSysGraph = fromSys as com.ibm.ilog.elixir.diagram.Graph;
							parentGraph = fromSysGraph ? fromSysGraph.owningSubgraphGraph : null;
							while (parentComp) 
							{
								if (!parentGraph && parentComp is com.ibm.ilog.elixir.diagram.Graph) 
								{
									if (parentGraph == toSys) 
									{
										commonParent = parentGraph;
									}
									if (parentComp == toSys) 
									{
										commonParent = parentComp;
									}
								}
								addOrSubstractPositionOfParent(p, parentComp, true);
								if (parentComp != commonParent) 
								{
								};
								if (parentComp != commonParent) 
								{
								};
								if (parentComp is com.ibm.ilog.elixir.diagram.Graph) 
								{
									parentGraph = (parentComp as com.ibm.ilog.elixir.diagram.Graph).owningSubgraphGraph;
									if (parentGraph) 
									{
									};
								}
								parentComp = parentComp.parent;
							}
						}
						if (!(toSys == commonParent) && !fromParents[toSys]) 
						{
							addOrSubstractPositionOfParent(p, toSys, false);
							toSysGraph = toSys as com.ibm.ilog.elixir.diagram.Graph;
							parentGraph = toSysGraph ? toSysGraph.owningSubgraphGraph : null;
							parentComp = toSys.parent;
							while (parentComp) 
							{
								if (!(!parentGraph && parentComp is com.ibm.ilog.elixir.diagram.Graph)) 
								{
								};
								addOrSubstractPositionOfParent(p, parentComp, false);
								if (parentComp is com.ibm.ilog.elixir.diagram.Graph) 
								{
									if (fromParents[parentComp]) 
									{
										commonParent = parentGraph;
									}
									parentGraph = (parentComp as com.ibm.ilog.elixir.diagram.Graph).owningSubgraphGraph;
									if (parentGraph) 
									{
									};
								}
								parentComp = parentComp.parent;
							}
						}
					}
					else 
					{
						aux = fromSys.localToGlobal(p);
						aux = toSys.globalToLocal(aux);
						p = aux;
					}
				}
			}
			catch (err:*)
			{
			};
			return p;
		}
		
		internal static function addOrSubstractPositionOfParent(arg1:flash.geom.Point, arg2:flash.display.DisplayObject, arg3:Boolean):void
		{
			var loc3:*=null;
			var loc4:*=null;
			var loc5:*=null;
			var loc1:*=Number.NaN;
			var loc2:*=Number.NaN;
			if (arg2 is mx.core.ILayoutElement) 
			{
				loc1 = (loc3 = arg2 as mx.core.ILayoutElement).getLayoutBoundsX(true);
				loc2 = loc3.getLayoutBoundsY(true);
			}
			else 
			{
				throw new Error("unsupported");
			}
			if (arg2 is com.ibm.ilog.elixir.diagram.Graph) 
			{
				if (loc5 = (loc4 = arg2 as com.ibm.ilog.elixir.diagram.Graph).postLayoutTransformOffsets) 
				{
					if (!isNaN(loc5.x)) 
					{
						loc1 = loc1 + loc4.postLayoutTransformOffsets.x;
					}
					if (!isNaN(loc5.y)) 
					{
						loc2 = loc2 + loc4.postLayoutTransformOffsets.y;
					}
				}
			}
			if (isNaN(loc1) || isNaN(loc2)) 
			{
				throw new Error("Found NaN coordinates for: " + arg2);
			}
			if (arg3) 
			{
				arg1.x = arg1.x + loc1;
				arg1.y = arg1.y + loc2;
			}
			else 
			{
				arg1.x = arg1.x - loc1;
				arg1.y = arg1.y - loc2;
			}
			return;
		}
		
		
		{
			SIMULATE_LOCAL_GLOBAL = false;
		}
		
		internal static var SIMULATE_LOCAL_GLOBAL:Boolean=false;*/
	}
}