package com.hjx.jbpm
{
	public class Decision extends JbpmBase
	{
		private var _handler:Handler = new Handler();
		private var _transition_conditions:String="";
		
		private var _commonNodeElements:CommonNodeElements = new CommonNodeElements();
		
		public function Decision()
		{
			super();
		}

		public function get commonNodeElements():CommonNodeElements
		{
			return _commonNodeElements;
		}

		public function set commonNodeElements(value:CommonNodeElements):void
		{
			_commonNodeElements = value;
		}

		public function get transition_conditions():String
		{
			return _transition_conditions;
		}

		public function set transition_conditions(value:String):void
		{
			_transition_conditions = value;
		}

		public function get handler():Handler
		{
			return _handler;
		}

		public function set handler(value:Handler):void
		{
			_handler = value;
		}

		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.appendChild(handler.toXml());
			if(this.transition_conditions && this.transition_conditions!=""){
				xml.@["transition-conditions"] = transition_conditions;
			}
			var xmllist:XMLList = commonNodeElements.toXml().children();
			for each (var x:XML in xmllist) 
			{
				xml.appendChild(x);
			}
			
			return xml;
		}
	}
}