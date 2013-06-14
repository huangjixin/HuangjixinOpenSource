package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Process_state extends JbpmBase
	{
		private var _sub_process:Sub_process = new Sub_process();
		private var _variable:Variable = new Variable();
		private var _commonNodeElements:CommonNodeElements = new CommonNodeElements();
		
		public function Process_state()
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
		
		
		public function get variable():Variable
		{
			return _variable;
		}

		public function set variable(value:Variable):void
		{
			_variable = value;
		}

		public function get sub_process():Sub_process
		{
			return _sub_process;
		}

		public function set sub_process(value:Sub_process):void
		{
			_sub_process = value;
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.appendChild(variable.toXml());
			xml.appendChild(sub_process.toXml());
			var xmllist:XMLList = commonNodeElements.toXml().children();
			for each (var x:XML in xmllist) 
			{
				xml.appendChild(x);
			}
			return xml;
		}

	}
}