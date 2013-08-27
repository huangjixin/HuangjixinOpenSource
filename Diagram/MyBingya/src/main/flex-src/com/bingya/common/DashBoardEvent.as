package com.bingya.common
{
	import flash.events.Event;
	
	public class DashBoardEvent extends Event
	{
		public static const INDEX_CHANGE:String = "indexChange";
		public var dashrenderer0:DashBoardRenderer;
		public var dashrenderer1:DashBoardRenderer;
		
		public function DashBoardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}