package com.hjx.jbpm
{
	public class Action extends JbpmBase
	{
		private var _className:String;
		
		private var _ref_name:String;
		
		private var _expression:String;
		
		private var _accept_propagated_events:Boolean = true;
		
		private var _async:Boolean = false;
		
		private var _config_type:String;
		
		public function Action()
		{
			super();
		}
		
		public function get async():Boolean
		{
			return _async;
		}

		public function set async(value:Boolean):void
		{
			_async = value;
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

		public function get accept_propagated_events():Boolean
		{
			return _accept_propagated_events;
		}

		public function set accept_propagated_events(value:Boolean):void
		{
			_accept_propagated_events = value;
		}

		public function get expression():String
		{
			return _expression;
		}

		public function set expression(value:String):void
		{
			_expression = value;
		}

		public function get ref_name():String
		{
			return _ref_name;
		}

		public function set ref_name(value:String):void
		{
			_ref_name = value;
		}

		/**
		 * 转换为描述文件的时候，要把该属性改成“class” 
		 * @return 
		 * 
		 */
		public function get className():String
		{
			return _className;
		}
		
		public function set className(value:String):void
		{
			_className = value;
		}
	}
}