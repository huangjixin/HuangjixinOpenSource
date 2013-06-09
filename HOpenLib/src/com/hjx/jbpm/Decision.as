package com.hjx.jbpm
{
	public class Decision extends JbpmBase
	{
		private var _handler:Handler;
		private var _transition_conditions:String;
		
		public function Decision()
		{
			super();
		}

		public function get transition_conditions():String
		{
			return _transition_conditions;
		}

		public function set transition_conditions(value:String):void
		{
			_transition_conditions = value;
		}

		public function get handler():Handler
		{
			return _handler;
		}

		public function set handler(value:Handler):void
		{
			_handler = value;
		}

	}
}