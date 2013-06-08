package com.hjx.bpmn.graphic
{
	public class VerticalLane extends LaneBase
	{
		public function VerticalLane()
		{
			super();
		}
		
		
		override public function isHorizontal():Boolean
		{
			return false;
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
		}
	}
}