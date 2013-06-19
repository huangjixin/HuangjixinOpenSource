package com.hjx.jbpm
{
	public class Event extends JbpmBase
	{
		public var action:Action = new Action;
		
		private var _type:String = "";
		
		private var _script:Script = new Script();
		private var _create_timer:Create_timer = new Create_timer();
		private var _cancel_timer:Cancel_timer = new Cancel_timer();
		public function Event()
		{
			super();
		}

		public function get cancel_timer():Cancel_timer
		{
			return _cancel_timer;
		}

		public function set cancel_timer(value:Cancel_timer):void
		{
			_cancel_timer = value;
		}

		public function get create_timer():Create_timer
		{
			return _create_timer;
		}

		public function set create_timer(value:Create_timer):void
		{
			_create_timer = value;
		}

		public function get script():Script
		{
			return _script;
		}

		public function set script(value:Script):void
		{
			_script = value;
		}

		[Inspectable(enumeration="node-enter,task-end,node-leave")]
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.appendChild(action.toXml());
			xml.appendChild(cancel_timer.toXml());
			xml.appendChild(create_timer.toXml());
			xml.appendChild(script.toXml());
			xml.@["type"] = type;
			return xml;
		}
	}
}