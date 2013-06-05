package com.hjx.bpmn.graphic
{
	import spark.layouts.VerticalLayout;

	/**
	 * 竖甬道池。 
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
		 * 保证布局为竖布局。 
		 * @param partName
		 * @param instance
		 * 
		 */
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (partName == "graph") 
			{
				this.graph.layout = new VerticalLayout();
			}
		}
	}
}