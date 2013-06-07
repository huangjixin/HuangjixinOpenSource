package com.hjx.bpmn.graphic
{
	/**
	 * @author 黄记新, 下午09:38:08
	 */
	import com.hjx.graphic.Link;
	import com.hjx.graphic.Node;
	
	import flash.events.Event;
	
	[SkinState("active")]
	[SkinState("done")]
	public class ConnectingObject extends Link
	{
		private var _monitoringStatus:String = "";
		
		public var monitoringDelay:Number = 1000;
		
		public var label:String = "";
		
		public function ConnectingObject(startNode:Node=null, endNode:Node=null)
		{
			//TODO: implement function
			super(startNode, endNode);
		}
		
		/*[Bindable]
		public function get monitoringStatus():String{
			return _monitoringStatus;
		}
		
		public function set monitoringStatus(value:String):void{
			_monitoringStatus = value;
			invalidateSkinState();
		}*/
		
		[Bindable(event="monitoringStatusChange")]
		/** Indicates the monitoring status: either active or done*/
		public function get monitoringStatus():String
		{
			return _monitoringStatus;
		}

		/**
		 * @private
		 */
		public function set monitoringStatus(value:String):void
		{
			if( _monitoringStatus !== value)
			{
				_monitoringStatus = value;
				dispatchEvent(new flash.events.Event("monitoringStatusChange"));
			}
			invalidateSkinState();
		}

		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState() : String{
			if(monitoringStatus=="active") return "active";
			if(monitoringStatus=="done") return "done";
			return super.getCurrentSkinState();
		}
	}
}