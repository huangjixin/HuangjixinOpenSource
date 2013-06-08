package com.hjx.bpmn.graphic
{
	import com.hjx.graphic.SubGraph;
	import com.hjx.jbpm.SwimLane;
	
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;
	
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
			
		public var swimlane:SwimLane;
		
		public function LaneBase()
		{
			super();
			swimlane = new SwimLane();
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
		}
	}
}