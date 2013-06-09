package com.hjx.jbpm
{
	public class CommonNodeElements extends JbpmBase
	{
		private var _async:Boolean;
		public var _transitions:Vector.<Transition> = new Vector.<Transition>();
		public var _events:Vector.<Event> = new Vector.<Event>();
		public var _exception_handlers:Vector.<Exception_handler> = new Vector.<Exception_handler>();
		public var _timers:Vector.<Timer> = new Vector.<Timer>();
		
		public function CommonNodeElements()
		{
			super();
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