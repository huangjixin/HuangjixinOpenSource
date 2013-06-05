package com.hjx.jbpm
{
	public class JbpmBase
	{
		private var _name:String = "jbpm元素名称";
		
		public function JbpmBase()
		{
		}

		[Bindable]
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

	}
}