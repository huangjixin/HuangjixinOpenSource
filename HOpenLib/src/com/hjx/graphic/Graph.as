package com.hjx.graphic
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Group;
	import spark.events.ElementExistenceEvent;
	
	/**
	 * 图，用于展示Render节点，再者可以通过布局算法展示节点之间的关系。 
	 * @author huangjixin
	 * 
	 */
	public class Graph extends Group
	{
		private var _subgraphs:Vector.<SubGraph>;
		private var _nodes:Vector.<Node>;
		private var _links:Vector.<Link>;
		
		private var _automaticGraphLayout:Boolean;
		
		private var _owningSubGraph:SubGraph;
		
		public function Graph()
		{
			super();
			
			_subgraphs = new Vector.<SubGraph>();
			_nodes = new Vector.<Node>();
			_links = new Vector.<Link>();
			
			addEventListener(ElementExistenceEvent.ELEMENT_ADD,elementAddedHandler);
			addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,elementRemovedHandler);
			/*addEventListener(MoveEvent.MOVE,onMove);
			addEventListener(ResizeEvent.RESIZE,onResize);*/
		}
		
		public function get owningSubGraph():SubGraph
		{
			return _owningSubGraph;
		}

		public function set owningSubGraph(value:SubGraph):void
		{
			_owningSubGraph = value;
		}

		[Bindable]
		public function get automaticGraphLayout():Boolean
		{
			return _automaticGraphLayout;
		}

		public function set automaticGraphLayout(value:Boolean):void
		{
			_automaticGraphLayout = value;
		}

		public function getNodes():Vector.<Node>
		{
			return this._nodes.slice(0);
		}
		
		internal function nodeAdded(node:Node):void
		{
			this._nodes.push(node);
			return;
		}
		
		internal function nodeRemoved(node:Node):void
		{
			var index:int=this._nodes.indexOf(node);
			if (index != -1) 
			{
				this._nodes.splice(index, 1);
			}
			return;
		}
		
		public function getLinks():Vector.<Link>
		{
			return this._links.slice(0);
		}
		internal function linkAdded(link:Link):void
		{
			this._links.push(link);
			return;
		}
		
		internal function linkRemoved(link:Link):void
		{
			var index:int=this._links.indexOf(link);
			if (index != -1) 
			{
				this._links.splice(index, 1);
			}
			return;
		}
		
		public function getSubGraphs():Vector.<SubGraph>
		{
			return this._subgraphs.slice(0);
		}
		
		internal function subgraphAdded(subGraph:SubGraph):void
		{
			this._subgraphs.push(subGraph);
			return;
		}
		
		internal function subgraphRemoved(subGraph:SubGraph):void
		{
			var index:int=this._subgraphs.indexOf(subGraph);
			if (index != -1) 
			{
				this._subgraphs.splice(index, 1);
			}
			return;
		}
		
		internal function elementAddedHandler(event:ElementExistenceEvent):void
		{
			var link:Link=null;
			var element:Node =event.element as Node;
			if (element) 
			{
				if (event.element is SubGraph) 
				{
					this.subgraphAdded(SubGraph(event.element));
				}
				this.nodeAdded(element);
			}
			else if (event.element is Link) 
			{
				link = event.element as Link;
				this.linkAdded(link);
			}
			return;
		}
		
		internal function elementRemovedHandler(event:ElementExistenceEvent):void
		{
			var node:Node=null;
			var link:Link;
			
			if (event.element is SubGraph) 
			{
				this.subgraphRemoved(SubGraph(event.element));
			}
			if (event.element is Node) 
			{
				node = event.element as Node;
				this.nodeRemoved(node);
			}
			else if (event.element is Link) 
			{
				link = event.element as Link;
				this.linkRemoved(link);
			}
			return;
		}
		
		/**
		 * 
		 * @param graphic — 事件发生的地方。
		 * @return 	Renderer — 包含所给graphic的Renderer.
		 * 
		 */
		public function getHitRenderer(object:Object):Renderer{
			
			while(object){
				if(object is Renderer){
					return object as Renderer
				}
				
				object = object.parent;
			}
			
			return null;
		}

		
		/*protected function onResize(event:ResizeEvent):void
		{
			graphGeometryChanged();
		}
		
		protected function onMove(event:MoveEvent):void
		{
			graphGeometryChanged();
		}
		
		protected function onElementRemove(event:ElementExistenceEvent):void
		{
			var renderer:Renderer = event.element as Renderer;
			var index:int = -1;
			if(renderer is Node){
				if(renderer is SubGraph){
					index = _subGraphs.indexOf(renderer as SubGraph);
					_subGraphs.splice(index,1);
				}else{
					index = _nodes.indexOf(renderer as Node);
					_nodes.splice(index,1);
				}
			}else if(renderer is Link){
				index = _links.indexOf(renderer as Link);
				_links.splice(index,1);
			}
		}
		
		protected function onElementAdd(event:ElementExistenceEvent):void
		{
			var renderer:Renderer = event.element as Renderer;
			if(renderer is Node){
				if(renderer is SubGraph){
					_subGraphs.push(renderer as SubGraph);
				}else{
					_nodes.push(renderer as Node);
				}
			}else if(renderer is Link){
				_links.push(renderer as Link);
			}
		}
		
		private function graphGeometryChanged():void{
			invalidateLinksOfHierarchechyImpl();
		}
		
		private function invalidateLinksOfHierarchechyImpl():void
		{
			
		}*/
	}
}