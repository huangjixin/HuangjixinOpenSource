package com.hjx.jbpm
{
	public class Event extends JbpmBase
	{
		public var action:Action;
		
		private var _type:String = "";
		
		private var _script:Script;
		private var _create_timer:Create_timer;
		private var _cancel_timer:Cancel_timer;
		public function Event()
		{
			super();
			action = new Action;
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

		[Inspectable(enumeration="node-enter,task-end,node-leave")]
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			if(action){
				xml.appendChild(action.toXml());
			}
			if(cancel_timer){
				xml.appendChild(cancel_timer.toXml());
			}
			if(create_timer){
				xml.appendChild(create_timer.toXml());
			}
			if(script){
				xml.appendChild(script.toXml());
			}
			
			if(this.type && this.type!=""){
				xml.@["type"] = type;	
			}
			
			return xml;
		}
	}
}