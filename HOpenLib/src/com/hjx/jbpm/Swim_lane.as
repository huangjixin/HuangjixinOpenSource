package com.hjx.jbpm
{
	import flash.utils.getQualifiedClassName;

	public class Swim_lane extends JbpmBase
	{
		[Bindable]
		public var assignment:Assignment = new Assignment();
		
		public function Swim_lane()
		{
		}
		
		override public function toXml():XML
		{
			var className:String = getQualifiedClassName(this);
			var nameSpace:Namespace = null;
			var dotIndex:int = className.lastIndexOf("::");
			if(dotIndex > 0){
				className = className.substr(dotIndex + 2);
				var firsChar:String = className.substr(0,1);
				firsChar = firsChar.toLocaleLowerCase();
				var subClassName:String = className.substr(1,className.length);
				className = firsChar + subClassName;
				className = className.replace("_","");
			}	
			
			var xml:XML = new XML("<"+className+"/>");
			xml.@name = this.name;
			xml.appendChild(assignment.toXml());
			return xml;
		}
	}
}