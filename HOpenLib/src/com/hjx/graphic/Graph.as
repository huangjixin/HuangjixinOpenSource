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
		private var _subGraphs:Vector.<SubGraph>;
		private var _nodes:Vector.<Node>;
		private var _links:Vector.<Link>;
		
		public function Graph()
		{
			super();
			
			_subGraphs = new Vector.<SubGraph>();
			_nodes = new Vector.<Node>();
			_links = new Vector.<Link>();
			
			/*addEventListener(ElementExistenceEvent.ELEMENT_ADD,onElementAdd);
			addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,onElementRemove);
			addEventListener(MoveEvent.MOVE,onMove);
			addEventListener(ResizeEvent.RESIZE,onResize);*/
		}
		
		private var _automaticGraphLayout:Boolean;
		
		[Bindable]
		public function get automaticGraphLayout():Boolean
		{
			return _automaticGraphLayout;
		}

		public function set automaticGraphLayout(value:Boolean):void
		{
			_automaticGraphLayout = value;
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