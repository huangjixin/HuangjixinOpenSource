package com.hjx.diagram
{
	import com.hjx.bpmn.graphic.FlowObject;
	
	import flash.events.Event;
	
	public class DiagramRunnerEvent extends Event
	{
		public static const ENTER:String = "enter"
		public static const LEAVE:String = "leave"
		public static const ENDNODE:String = "endnode"
		public static const AWAITMESSAGE:String = "awaitmessage"
		
		private var _current:FlowObject = null;
		private var _next:FlowObject = null;
		private var _extraMessage:String = null
		
		/**
		 * 
		 */
		public function DiagramRunnerEvent(type:String, 
										   current:FlowObject=null, 
										   next:FlowObject=null,
										   extra:String = null,
										   bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_current = current;
			_next = next;
			_extraMessage = extra;
		}
		
		
		/**
		 * 
		 */
		public function get current():FlowObject
		{
			return _current;
		}
		
		
		/**
		 * 
		 */
		public function get next():FlowObject
		{
			return _next;
		}  
		
		
		/**
		 * 
		 */
		public function get extraMessage():String
		{
			return _extraMessage;
		}    
	}
}