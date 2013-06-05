package com.hjx.bpmn.graphic
{
	import spark.layouts.HorizontalLayout;

	/**
	 * 横甬道池，用于放置甬道。 
	 * @author huangjixin
	 * 
	 */
	public class HorizontalPool extends HorizontalLane
	{
		public function HorizontalPool()
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
				this.graph.layout = new HorizontalLayout();
			}
		}
	}
}