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
		
		private var _action:Action = new Action;
		private var _script:Script = new Script();
		private var _create_timer:Create_timer = new Create_timer();
		private var _cancel_timer:Cancel_timer = new Cancel_timer();
		
		public function Timer()
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
		
		public function get action():Action
		{
			return _action;
		}
		
		public function set action(value:Action):void
		{
			_action = value;
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
			
			xml.appendChild(action.toXml());
			xml.appendChild(cancel_timer.toXml());
			xml.appendChild(create_timer.toXml());
			xml.appendChild(script.toXml());
			return xml;
		}
	}
}