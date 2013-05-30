package com.hjx.bpmn.graphic
{
	public class Event extends FlowObject
	{
		[Bindable]
		public var trigger:String;
		
		public function Event()
		{
			super();
			maxWidth = 100;
		}
	}
}