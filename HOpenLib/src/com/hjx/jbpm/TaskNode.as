package com.hjx.jbpm
{
	public class TaskNode extends JbpmBase
	{
		private var _createTasks:Boolean;
		private var _description:String;
		
		[Bindable]
		public var transition:Vector.<Transition> = new Vector.<Transition>();
		
		public function TaskNode()
		{
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