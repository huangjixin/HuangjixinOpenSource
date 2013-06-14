package com.hjx.bpmn.graphic
{
	import com.hjx.jbpm.Task_node;

	public class Task extends Activity
	{
		[Bindable]
		public var loop:Boolean;
		
		[Bindable]
		public var multiInstance:Boolean;
		
		[Bindable]
		public var compensation:Boolean;
		
		public var task:Task_node = new Task_node();
		
		public function Task()
		{
			super();
			task.description = "";
			task.create_tasks = true;
		}
		
	}
}