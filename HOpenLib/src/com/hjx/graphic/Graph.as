package com.hjx.graphic
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	/**
	 * 图，用于展示Render节点，再者可以通过布局算法展示节点之间的关系。 
	 * @author huangjixin
	 * 
	 */
	public class Graph extends Group
	{
		public function Graph()
		{
			super();
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
		public function getHitRenderer(graphic:Object):Object{
			// 通过递归找到该容器相对graphic最上面的元素。
			var length:int = this.numElements;
			var targetCoordinateSpace:DisplayObject = graphic as DisplayObject;
			var renderer:Object = null;
			for (var i:int = length-1; i >=0 ; i--) 
			{
				var element:IVisualElement = getElementAt(i);
				if((element as UIComponent).hasOwnProperty("graph")){
					var graph:Graph = (element as UIComponent)["graph"] as Graph;
					renderer = graph.getHitRenderer(graphic);
					if(renderer){
						return renderer;
					}
				}
				
				var rect:Rectangle = Renderer(element).getBounds(targetCoordinateSpace);
				if(rect.contains(targetCoordinateSpace.mouseX,targetCoordinateSpace.mouseY)){
					renderer = element;
					break;
				}
			}
			
			return renderer;
		}

	}
}