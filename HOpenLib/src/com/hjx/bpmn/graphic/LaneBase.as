package com.hjx.bpmn.graphic
{
	import com.hjx.graphic.SubGraph;
	
	/**
	 * 甬道基类。 
	 * @author huangjixin
	 * 
	 */
	public class LaneBase extends SubGraph
	{
		public var poolMarginLeft:Number=5;
		
		public var poolMarginTop:Number=5;
		
		public var poolMarginRight:Number=5;
		
		public var poolMarginBottom:Number=5;
		
		internal var _gap:int=-1
			
		public function LaneBase()
		{
			super();
		}
		
		public function isHorizontal():Boolean
		{
			return false;
		}
		
		public function isLeaf():Boolean
		{
			if (graph && graph.numElements > 0 && graph.getElementAt(0) is LaneBase) 
			{
				return false;
			}
			return true;
		}
		
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (partName == "graph") 
			{
				
				/*loc1 = arg2 as com.ibm.ilog.elixir.diagram.Graph;
				if (!(loc1.layout is com.ibm.ilog.elixir.diagram.LaneGraphSparkLayout)) 
				{
					(loc2 = new com.ibm.ilog.elixir.diagram.LaneGraphSparkLayout()).paddingTop = 0;
					loc2.paddingBottom = 0;
					loc2.paddingLeft = 0;
					loc2.paddingRight = 0;
					loc2.gap = this.gap;
					loc1.layout = loc2;
				}*/
			}
		}
	}
}