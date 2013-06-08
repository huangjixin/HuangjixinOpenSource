package com.hjx.bpmn.graphic
{
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;
	
	import spark.layouts.HorizontalAlign;
	import spark.layouts.HorizontalLayout;
	
	/**
	 * 竖甬道池，用于放置甬道。 
	 * @author huangjixin
	 * 
	 */
	public class VerticalPool extends VerticalLane
	{
		public function VerticalPool()
		{
			super();
		}
		
		
		/**
		 * 更改布局为横布局。 
		 * @param partName
		 * @param instance
		 * 
		 */
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (partName == "graph") 
			{
				var hLayout:HorizontalLayout= new HorizontalLayout();
				hLayout.horizontalAlign= HorizontalAlign.CENTER;
				hLayout.gap = -2;
				this.graph.layout =hLayout;
				this.graph.allowReparenting = false;
			}
		}
	}
}