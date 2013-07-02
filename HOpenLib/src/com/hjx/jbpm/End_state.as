package com.hjx.jbpm
{
	public class End_state extends JbpmBase
	{
		private var _event:Event ;
		private var _exception_handler:Exception_handler;
		public function End_state()
		{
			super();
//			event = new Event();
//			event.type = "node-enter";
		}
		
		public function get event():Event
		{
			return _event;
		}

		public function set event(value:Event):void
		{
			_event = value;
		}

		public function get exception_handler():Exception_handler
		{
			return _exception_handler;
		}

		public function set exception_handler(value:Exception_handler):void
		{
			_exception_handler = value;
		}

		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			if(event){
				xml.appendChild(event.toXml());
			}
			if(exception_handler){
				xml.appendChild(exception_handler.toXml());	
			}
			
			return xml;
		}
	}
}