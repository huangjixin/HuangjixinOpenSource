package com.hnisi.largescreen
{
	import com.hjx.graphic.Node;
	
	import flash.events.Event;
	
	[SkinState("safe")]
	[SkinState("alert")]
	public class City extends Node
	{
		private var _monitoringStatus:String = "";
		
		public function City()
		{
			super();
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
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState() : String{
			if(monitoringStatus=="safe") 
				return "safe";
			if(monitoringStatus=="alert") 
				return "alert";
			return super.getCurrentSkinState();
		}
		
	}
}