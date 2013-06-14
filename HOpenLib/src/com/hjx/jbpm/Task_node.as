package com.hjx.jbpm
{
	public class Task_node extends JbpmBase
	{
		private var _description:String;
		private var _signal:String = "last";
		private var _create_tasks:Boolean = true;
		private var _end_tasks:Boolean = false;
		private var _task:Task;
		private var _commonNodeElements:CommonNodeElements ;
		
		[Bindable]
		public var transition:Vector.<Transition> = new Vector.<Transition>();
		
		public function Task_node()
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


		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.@["description"] = description;
			xml.@["signal"] = signal;
			xml.appendChild(task.toXml());
			xml.@["create-tasks"] = create_tasks;
			xml.@["end-tasks"] = end_tasks;
			var xmllist:XMLList = commonNodeElements.toXml().children();
			for each (var x:XML in xmllist) 
			{
				xml.appendChild(x);
			}
			return xml;
		}
	}
}