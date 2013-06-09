package com.hjx.jbpm
{
	public class Swim_lane extends JbpmBase
	{
		[Bindable]
		public var assignment:Assignment = new Assignment();
		
		public function Swim_lane()
		{
			assignment.className="swim-lane";
			assignment.name="swim-lane";
		}
		
	}
}