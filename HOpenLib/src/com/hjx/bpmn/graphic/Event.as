package com.hjx.bpmn.graphic
{
	import flash.events.Event;

	public class Event extends FlowObject
	{
		private var _trigger:String;
		
		public function Event()
		{
			super();
			maxWidth = 100;
		}

		[Bindable(event="triggerChange")]
		public function get trigger():String
		{
			return _trigger;
		}

		public function set trigger(value:String):void
		{
			if( _trigger !== value)
			{
				_trigger = value;
				dispatchEvent(new flash.events.Event("triggerChange"));
			}
		}

	}
}