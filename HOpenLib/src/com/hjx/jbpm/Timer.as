package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Timer extends JbpmBase
	{
		private var _duedate:String;
		private var _repeat:String;
		private var _transition:String;
		private var _cancel_event:String;
		
//		{action|script|create-timer|cancel-timer}
		public function Timer()
		{
			super();
		}

		public function get cancel_event():String
		{
			return _cancel_event;
		}

		public function set cancel_event(value:String):void
		{
			_cancel_event = value;
		}

		public function get transition():String
		{
			return _transition;
		}

		public function set transition(value:String):void
		{
			_transition = value;
		}

		public function get repeat():String
		{
			return _repeat;
		}

		public function set repeat(value:String):void
		{
			_repeat = value;
		}

		public function get duedate():String
		{
			return _duedate;
		}

		public function set duedate(value:String):void
		{
			_duedate = value;
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.@["duedate"] = duedate;
			xml.@["repeat"] = repeat;
			xml.@["transition"] = transition;
			xml.@["cancel-event"] = cancel_event;
			return xml;
		}
	}
}