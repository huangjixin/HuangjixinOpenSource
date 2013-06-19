package com.hjx.bpmn.graphic.icons
{
	public class IconClass
	{
		[Embed(source='../images/wait.svg')]  
		public var wait_icon:Class;
		
		[Embed(source='../images/ok.svg')]  
		public var ok_icon:Class;
		
		public static const WAIT:String = "wait_icon";
		public static const OK:String = "ok_icon";
		
		public function IconClass()
		{
		}
		
		static public function iconClass(s:String):Class  
		{  
			var iconClass:IconClass=new IconClass();  
			
			return iconClass[s];  
		}
	}
}