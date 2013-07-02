package com.hjx.bpmn.graphic
{
	import com.hjx.jbpm.Event;
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
			task.create_tasks = false;
			
			var event:com.hjx.jbpm.Event = new com.hjx.jbpm.Event();
			event.type = "node-enter";
			event.action.className = "org.wbase.framework.jbpm.extend.DynamicCreateTaskInstanceHandler";
			event.action.name = "处理";
			task.commonNodeElements.events[0] = event;
		}
		
		override public function set label(value:String):void{
			super.label = value;
			
			task.name = value;
		}
		
	}
}