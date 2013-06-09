package com.hjx.jbpm
{
	public class SwimLane extends JbpmBase
	{
		[Bindable]
		public var assignment:Assignment = new Assignment();
		
		public function SwimLane()
		{
			assignment.className="swim-lane";
			assignment.name="swim-lane";
		}

	}
}