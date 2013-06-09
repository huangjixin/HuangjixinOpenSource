package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Handler extends JbpmBase
	{
		private var _expression:String;
		
		private var _className:String;
		
		private var _config_type:String;
		
		public function Handler()
		{
			super();
		}

		[Inspectable(enumeration="field,bean,constructor,configuration-property")]
		public function get config_type():String
		{
			return _config_type;
		}

		public function set config_type(value:String):void
		{
			_config_type = value;
		}

		public function get className():String
		{
			return _className;
		}

		public function set className(value:String):void
		{
			_className = value;
		}

		public function get expression():String
		{
			return _expression;
		}

		public function set expression(value:String):void
		{
			_expression = value;
		}

	}
}