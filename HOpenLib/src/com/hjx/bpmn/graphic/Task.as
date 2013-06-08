package com.hjx.bpmn.graphic
{
	import com.hjx.jbpm.TaskNode;

	public class Task extends Activity
	{
		[Bindable]
		public var loop:Boolean;
		
		[Bindable]
		public var multiInstance:Boolean;
		
		[Bindable]
		public var compensation:Boolean;
		
		public var task:TaskNode = new TaskNode();
		
		public function Task()
		{
			super();
			task.description = "我是bpm描述";
			task.createTasks = true;
		}
	}
}