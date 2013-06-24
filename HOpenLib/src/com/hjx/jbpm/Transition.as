package com.hjx.jbpm
{
	public class Transition extends JbpmBase
	{
		private var _to:String="";
		
		private var _condition:String="";
		
		private var _exception_handler:Exception_handler= new Exception_handler();
		
		private var _action:Action = new Action;
		private var _script:Script = new Script();
		private var _create_timer:Create_timer = new Create_timer();
		private var _cancel_timer:Cancel_timer = new Cancel_timer();
		public function Transition()
		{
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

		public function get exception_handler():Exception_handler
		{
			return _exception_handler;
		}

		public function set exception_handler(value:Exception_handler):void
		{
			_exception_handler = value;
		}

		public function get condition():String
		{
			return _condition;
		}

		public function set condition(value:String):void
		{
			_condition = value;
		}

		[Bindable]
		public function get to():String
		{
			return _to;
		}

		public function set to(value:String):void
		{
			_to = value;
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.@["to"] = to;
			
			if(this.condition && this.condition!=""){
				xml.@["condition"] = condition;			
			}
			
			xml.appendChild(exception_handler.toXml());
			
			xml.appendChild(action.toXml());
			xml.appendChild(cancel_timer.toXml());
			xml.appendChild(create_timer.toXml());
			xml.appendChild(script.toXml());
			return xml;
		}
	}
}