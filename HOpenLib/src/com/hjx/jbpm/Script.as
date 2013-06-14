package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Script extends JbpmBase
	{
		private var _accept_propagated_events:Boolean=true;
		private var _expression:Expression = new Expression();
		
		public function Script()
		{
			super();
		}

		public function get expression():Expression
		{
			return _expression;
		}

		public function set expression(value:Expression):void
		{
			_expression = value;
		}

		public function get accept_propagated_events():Boolean
		{
			return _accept_propagated_events;
		}

		public function set accept_propagated_events(value:Boolean):void
		{
			_accept_propagated_events = value;
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.@["accept-propagated-events"] = accept_propagated_events;
			xml.appendChild(expression.toXml());
			return xml;
		}
	}
}