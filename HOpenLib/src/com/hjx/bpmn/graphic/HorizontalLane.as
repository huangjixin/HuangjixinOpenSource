package com.hjx.bpmn.graphic
{
	/**
	 * 横甬道 
	 * @author huangjixin
	 * 
	 */
	public class HorizontalLane extends LaneBase
	{
		
		public function HorizontalLane()
		{
			super();
		}
		
		override public function isHorizontal():Boolean
		{
			return true;
		}
		
		public override function set collapsed(value:Boolean):void 
		{
		}
		
		public override function get collapsed():Boolean
		{
			return false;
		}
		
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (partName == "graph") 
			{
			}
		}
	}
}