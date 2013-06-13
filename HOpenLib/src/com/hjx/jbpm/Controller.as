package com.hjx.jbpm
{
	public class Controller extends JbpmBase
	{
		private var _className:String;
		private var _config_type:String;
		
		public function Controller()
		{
			super();
		}

		public function get className():String
		{
			return _className;
		}

		public function set className(value:String):void
		{
			_className = value;
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

		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			xml.@["class"] = className;
			xml.@["config-type"] = config_type;
			return xml;
		}
	}
}