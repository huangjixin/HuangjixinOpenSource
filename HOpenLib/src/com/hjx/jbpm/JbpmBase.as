package com.hjx.jbpm
{
	import flash.utils.getQualifiedClassName;

	public class JbpmBase
	{
		private var _name:String = "";
		
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

		public function toXml():XML
		{
			var className:String = getQualifiedClassName(this);
			var nameSpace:Namespace = null;
			var dotIndex:int = className.lastIndexOf("::");
			if(dotIndex > 0){
				className = className.substr(dotIndex + 2);
				className = className.toLocaleLowerCase();
				className = className.replace("_","-");
			}	
			
			var xml:XML = new XML("<"+className+"/>");
			xml.@name = this.name;
			return xml;
		}
	}
}