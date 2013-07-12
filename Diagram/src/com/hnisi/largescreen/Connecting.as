package com.hnisi.largescreen
{
	import com.hjx.graphic.Link;
	import com.hjx.graphic.Node;
	import flash.events.Event;
	
	[SkinState("safe")]
	[SkinState("alert")]
	public class Connecting extends Link
	{
		private var _monitoringStatus:String = "";
		
		public function Connecting(startNode:Node=null, endNode:Node=null)
		{
			super(startNode, endNode);
		}

		[Bindable(event="monitoringStatusChange")]
		public function get monitoringStatus():String
		{
			return _monitoringStatus;
		}

		public function set monitoringStatus(value:String):void
		{
			if( _monitoringStatus !== value)
			{
				_monitoringStatus = value;
				dispatchEvent(new Event("monitoringStatusChange"));
				invalidateSkinState();
			}
		}

	}
}