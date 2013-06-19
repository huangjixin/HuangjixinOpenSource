package com.hjx.jbpm
{
	public class Swim_lane extends JbpmBase
	{
		[Bindable]
		public var assignment:Assignment = new Assignment();
		
		public function Swim_lane()
		{
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.appendChild(assignment.toXml());
			return xml;
		}
	}
}