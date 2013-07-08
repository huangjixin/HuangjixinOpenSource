package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Start_state extends JbpmBase
	{
		private var _task:Task;
		private var _event:Event;
		private var _transition:Transition;
		private var _exception_handler:Exception_handler;
		
		public function Start_state()
		{
			super();
		}

		public function get exception_handler():Exception_handler
		{
			return _exception_handler;
		}

		public function set exception_handler(value:Exception_handler):void
		{
			_exception_handler = value;
		}

		public function get transition():Transition
		{
			return _transition;
		}

		public function set transition(value:Transition):void
		{
			_transition = value;
		}

		public function get event():Event
		{
			return _event;
		}

		public function set event(value:Event):void
		{
			_event = value;
		}

		public function get task():Task
		{
			return _task;
		}

		public function set task(value:Task):void
		{
			_task = value;
		}

		override public function deserialXml(xml:XML):void{
			super.deserialXml(xml);
			if(event){
				event.deserialXml(xml.event[0]);
			}
			if(exception_handler){
//				var exception_handlerXmlList:XMLList = 
				exception_handler.deserialXml(xml.child("exception-handler")[0])
			}
			if(task){
				task.deserialXml(xml.task[0]);
			}
			
			if(transition){
				transition.deserialXml(xml.transition[0]);
			}
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
			if(task){
				xml.appendChild(task.toXml());
			}
			
			if(transition){
				xml.appendChild(transition.toXml());
			}
			
			return xml;
		}
	}
}