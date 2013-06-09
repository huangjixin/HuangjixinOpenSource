package com.hjx.jbpm
{
	public class TaskNode extends JbpmBase
	{
		private var _createTasks:Boolean;
		private var _description:String;
		private var _signal:String = "last";
		private var _create_tasks:Boolean = true;
		private var _end_tasks:Boolean = false;
		private var _task:Task;
		private var _commonNodeElements:CommonNodeElements ;
		
		[Bindable]
		public var transition:Vector.<Transition> = new Vector.<Transition>();
		
		public function TaskNode()
		{
			task= new Task();
			commonNodeElements = new CommonNodeElements()
		}

		public function get commonNodeElements():CommonNodeElements
		{
			return _commonNodeElements;
		}

		public function set commonNodeElements(value:CommonNodeElements):void
		{
			_commonNodeElements = value;
		}

		public function get task():Task
		{
			return _task;
		}

		public function set task(value:Task):void
		{
			_task = value;
		}

		public function get end_tasks():Boolean
		{
			return _end_tasks;
		}

		public function set end_tasks(value:Boolean):void
		{
			_end_tasks = value;
		}

		public function get create_tasks():Boolean
		{
			return _create_tasks;
		}

		public function set create_tasks(value:Boolean):void
		{
			_create_tasks = value;
		}

		[Inspectable(enumeration="unsynchronized,never,first,first-wait,last,last-wait")]
		public function get signal():String
		{
			return _signal;
		}

		public function set signal(value:String):void
		{
			_signal = value;
		}

		[Bindable]
		public function get description():String
		{
			return _description;
		}

		public function set description(value:String):void
		{
			_description = value;
		}

		[Bindable]
		/**
		 * create-tasks
		 * @return 
		 * 
		 */
		public function get createTasks():Boolean
		{
			return _createTasks;
		}

		public function set createTasks(value:Boolean):void
		{
			_createTasks = value;
		}

	}
}