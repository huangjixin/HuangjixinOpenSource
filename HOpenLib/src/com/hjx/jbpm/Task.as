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
		
//		private var _swimlane:Swim_lane;
		
		private var _swimlane:String;
		
		[Inspectable(enumeration="highest, high, normal, low, lowest")]
		private var _priority:String;
		
		private var _assignment:Assignment;
		private var _events:Vector.<Event>;
		private var _exception_handlers:Vector.<Exception_handler> ;
		private var _timers:Vector.<Timer>;
		
		public function Task()
		{
			super();
			blocking = false;
			signalling = true;
			duedate = "";
//			swimlane = new Swim_lane();
			priority = "";
			events = new Vector.<Event>();
			exception_handlers = new Vector.<Exception_handler>();
			timers = new Vector.<Timer>();
		}

		public function get swimlane():String
		{
			return _swimlane;
		}

		public function set swimlane(value:String):void
		{
			_swimlane = value;
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

		/*public function get swimlane():Swim_lane
		{
			return _swimlane;
		}

		public function set swimlane(value:Swim_lane):void
		{
			_swimlane = value;
		}*/

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
		
		override public function deserialXml(xml:XML):void{
			super.deserialXml(xml);
			var nameXml:XML = xml.name[0];
			this.name = nameXml.text;
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			if(this.blocking && this.blocking){
				xml.@["blocking"] = blocking;		
			}
			if(this.signalling && !this.signalling){
				xml.@["signalling"] = signalling;		
			}
			if(this.duedate && this.duedate!=""){
				xml.@["duedate"] = duedate;		
			}
			if(this.swimlane && this.swimlane!=""){
				xml.@["swimlane"] = swimlane;		
			}
			/*if(swimlane){
				xml.appendChild(swimlane.toXml());
			}*/
			if(this.priority && this.priority!=""){
				xml.@["priority"] = priority;		
			}
			if(assignment){
				xml.appendChild(assignment.toXml());
			}
			return xml;
		}
	}
}