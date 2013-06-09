package com.hjx.jbpm
{
	public class CommonNodeElements extends JbpmBase
	{
		private var _async:Boolean;
		public var transitions:Vector.<Transition> = new Vector.<Transition>();
		public var events:Vector.<Event> = new Vector.<Event>();
		public var exception_handlers:Vector.<Exception_handler> = new Vector.<Exception_handler>();
		public var timers:Vector.<Timer> = new Vector.<Timer>();
		
		public function CommonNodeElements()
		{
			super();
			_async = false;
			transitions = new Vector.<Transition>();
			events = new Vector.<Event>();
			exception_handlers = new Vector.<Exception_handler>();
			timers= new Vector.<Timer>();
		}

		public function get async():Boolean
		{
			return _async;
		}

		public function set async(value:Boolean):void
		{
			_async = value;
		}

	}
}