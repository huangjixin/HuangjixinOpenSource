package com.hjx.jbpm
{
	public class Event extends JbpmBase
	{
		[Bindable]
		public var action:Action = new Action;
		
		private var _type:String = "node-enter";
		
		public function Event()
		{
			super();
		}

		[Inspectable(enumeration="node-enter,task-end")]
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}