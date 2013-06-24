package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Start_state extends JbpmBase
	{
		private var _task:Task = new Task();
		private var _event:Event = new Event();
		private var _transition:Transition = new Transition();
		private var _exception_handler:Exception_handler = new Exception_handler();
		
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

		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.appendChild(transition.toXml());
			xml.appendChild(task.toXml());
			xml.appendChild(event.toXml());
			xml.appendChild(exception_handler.toXml());
			return xml;
		}
	}
}