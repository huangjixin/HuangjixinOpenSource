package com.hjx.bpmn.graphic
{
	public class Task extends Activity
	{
		[Bindable]
		public var loop:Boolean;
		
		[Bindable]
		public var multiInstance:Boolean;
		
		[Bindable]
		public var compensation:Boolean;
		
		public function Task()
		{
			super();
		}
	}
}