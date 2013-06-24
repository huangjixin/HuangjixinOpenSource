package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Create_timer extends JbpmBase
	{
		private var _duedate:String;
		private var _repeat:String;
		
		private var _transition:String;
		
		public function Create_timer()
		{
			super();
		}

		public function get transition():String
		{
			return _transition;
		}

		public function set transition(value:String):void
		{
			_transition = value;
		}

		[Inspectable(enumeration="duration,yes,true")]
		public function get repeat():String
		{
			return _repeat;
		}

		public function set repeat(value:String):void
		{
			_repeat = value;
		}

		public function get duedate():String
		{
			return _duedate;
		}

		public function set duedate(value:String):void
		{
			_duedate = value;
		}
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			if(this.duedate && this.duedate!=""){
				xml.@["duedate"] = duedate;		
			}
			
			if(this.repeat && this.repeat!=""){
				xml.@["repeat"] = repeat;		
			}
			
			if(this.transition && this.transition!=""){
				xml.@["transition"] = transition;		
			}
			
			return xml;
		}
	}
}