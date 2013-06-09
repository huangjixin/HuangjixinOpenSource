package com.hjx.jbpm
{
	/**
	 *  
	 * @author huangjixin
	 * 
	 */
	public class Task extends JbpmBase
	{
		private var _blocking:Boolean = false;
		
		private var _signalling:Boolean = true;
		
		private var _duedate:String;
		
		private var _swimlane:SwimLane;
		
		[Inspectable(enumeration="highest, high, normal, low, lowest")]
		private var _priority:String;
		
		private var _assignment:Assignment;
		
		private var _events:Vector.<Event>;
		private var _exception_handlers:Vector.<Exception_handler>;
		private var _timers:Vector.<Timer>;
		
//		private var controller
		public function Task()
		{
			super();
		}

		public function get timers():Vector.<Timer>
		{
			return _timers;
		}

		public function set timers(value:Vector.<Timer>):void
		{
			_timers = value;
		}

		public function get exception_handlers():Vector.<Exception_handler>
		{
			return _exception_handlers;
		}

		public function set exception_handlers(value:Vector.<Exception_handler>):void
		{
			_exception_handlers = value;
		}

		public function get events():Vector.<Event>
		{
			return _events;
		}

		public function set events(value:Vector.<Event>):void
		{
			_events = value;
		}

		public function get assignment():Assignment
		{
			return _assignment;
		}

		public function set assignment(value:Assignment):void
		{
			_assignment = value;
		}

		public function get priority():String
		{
			return _priority;
		}

		public function set priority(value:String):void
		{
			_priority = value;
		}

		public function get swimlane():SwimLane
		{
			return _swimlane;
		}

		public function set swimlane(value:SwimLane):void
		{
			_swimlane = value;
		}

		public function get duedate():String
		{
			return _duedate;
		}

		public function set duedate(value:String):void
		{
			_duedate = value;
		}

		public function get signalling():Boolean
		{
			return _signalling;
		}

		public function set signalling(value:Boolean):void
		{
			_signalling = value;
		}

		public function get blocking():Boolean
		{
			return _blocking;
		}

		public function set blocking(value:Boolean):void
		{
			_blocking = value;
		}

	}
}