package com.hjx.jbpm
{
	public class Event extends JbpmBase
	{
		[Bindable]
		public var action:Action = new Action;
		
		public function Event()
		{
			super();
		}
	}
}