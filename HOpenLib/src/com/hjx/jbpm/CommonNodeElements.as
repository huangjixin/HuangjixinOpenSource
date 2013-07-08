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

		override public function deserialXml(xml:XML):void{
			if(XMLList(xml.commonNodeElements).length() > 0){
				var commonNodeElementsXML:XML = xml.commonNodeElements[0];
				if(commonNodeElementsXML){
					var eventList:XMLList = commonNodeElementsXML.event;
					if(eventList.length() > 0){
						events = new Vector.<Event>();					
					}
					for each (var eventXml:XML in eventList) 
					{
						var event:Event = new Event();
						event.deserialXml(eventXml);
						events.push(event);
					}
					
				}
					
			}
//			super.deserialXml(xml);
			
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			for each (var transition:Transition in transitions) 
			{
				xml.appendChild(transition.toXml());
			}
			
			for each (var event:com.hjx.jbpm.Event in events) 
			{
				xml.appendChild(event.toXml());
			}
			
			for each (var exception_handler:Exception_handler in exception_handlers) 
			{
				xml.appendChild(exception_handler.toXml());
			}
			
			for each (var timer:Timer in timers) 
			{
				xml.appendChild(timer.toXml());
			}
			
			return xml;
		}
	}
}