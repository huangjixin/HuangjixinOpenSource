package com.hjx.graphic
{
	/**
	 * @author 黄记新, 下午3:55:27
	 */
	import com.hjx.graphic.skin.GraphScrollerSkin;
	
	import flash.geom.Rectangle;
	
	import spark.components.Group;
	import spark.components.HScrollBar;
	import spark.components.VScrollBar;
	import spark.components.supportClasses.SkinnableComponent;

	[DefaultProperty("graph")]
	public class GraphScroller extends SkinnableComponent
	{
		private var _graph : Graph=null;
		[SkinPart(required="false")]
		[Bindable]
		public var horizontalScrollBar : HScrollBar;
		
		[SkinPart(required="false")]
		[Bindable]
		public var verticalScrollBar : VScrollBar;
		
		private var mxmlContentChanged:Boolean = false;
		private var _mxmlContent:Array;
		
		private var _graphChanged:Boolean = false;
		
		public function GraphScroller()
		{
			super();
			setStyle("skinClass",GraphScrollerSkin);
		}

		public function get graph():Graph
		{
			return _graph;
		}

		public function set graph(value:Graph):void
		{
			_graph = value;
			_graphChanged = true;
			
			invalidateProperties();
		}

		private function installGraph():void
		{
			if (skin && _graph)
			{
				_graph.clipAndEnableScrolling = true;
				(skin as Group).addElementAt(_graph, 0);
			}
			if (verticalScrollBar)
				verticalScrollBar.viewport = _graph;
			if (horizontalScrollBar)
				horizontalScrollBar.viewport = _graph;
		}
		
		private function uninstallViewport():void
		{
			if (horizontalScrollBar)
				horizontalScrollBar.viewport = null;
			if (verticalScrollBar)
				verticalScrollBar.viewport = null;        
			if (skin && graph)
			{
				graph.clipAndEnableScrolling = false;
				(skin as Group).removeElement(graph);
			}
		}
		
		public function ensureRectangleIsVisible(rectangle:Rectangle, centered:Boolean = false, animate:Boolean = false):void{
			
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
			if(_graphChanged){
				_graphChanged = false;
				installGraph();
			}
		}
	}
}