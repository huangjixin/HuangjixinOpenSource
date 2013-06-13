package com.hjx.jbpm
{
	public class Decision extends JbpmBase
	{
		private var _handler:Handler = new Handler();
		private var _transition_conditions:String="";
		
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

		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.appendChild(handler.toXml());
			xml.@["transition-conditions"] = transition_conditions;
			return xml;
		}
	}
}