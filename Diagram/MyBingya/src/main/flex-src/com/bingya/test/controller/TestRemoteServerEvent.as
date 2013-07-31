package com.bingya.test.controller
{
	import flash.events.Event;
	
	public class TestRemoteServerEvent extends Event
	{
		public static const getStr:String = "getStr";
		public static const getStrResult:String = "getStrResult";
		public static const getStrFault:String = "getStrFault";
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		/**
		 *	事件派发捆绑数据； 
		 */
		public var object:Object;
		
		
		public function TestRemoteServerEvent(type:String, object:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.object = object;
		}
	}
}