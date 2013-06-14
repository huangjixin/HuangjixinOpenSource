package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Join extends JbpmBase
	{
		private var _commonNodeElements:CommonNodeElements = new CommonNodeElements();
		public function Join()
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
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			var xmllist:XMLList = commonNodeElements.toXml().children();
			for each (var x:XML in xmllist) 
			{
				xml.appendChild(x);
			}
			
			return xml;
		}
		
	}
}