package com.hjx.bpmn.graphic
{
	/**
	 * @author 黄记新, 下午09:38:08
	 */
	import com.hjx.graphic.Link;
	import com.hjx.graphic.Node;
	import com.hjx.jbpm.Transition;
	
	import flash.events.Event;
	
	[SkinState("active")]
	[SkinState("done")]
	public class ConnectingObject extends Link
	{
		private var _monitoringStatus:String = "";
		
		public var monitoringDelay:Number = 1000;
		
		public var label:String = "";
		
		private var _transition:Transition;
		
		public function ConnectingObject(startNode:Node=null, endNode:Node=null)
		{
			super(startNode, endNode);
			transition = new Transition();
		}
		
		/*[Bindable]
		public function get monitoringStatus():String{
			return _monitoringStatus;
		}
		
		public function set monitoringStatus(value:String):void{
			_monitoringStatus = value;
			invalidateSkinState();
		}*/
		
		public function get transition():Transition
		{
			return _transition;
		}

		public function set transition(value:Transition):void
		{
			_transition = value;
		}

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
			_monitoringStatus = value;
			dispatchEvent(new flash.events.Event("monitoringStatusChange"));
			invalidateSkinState();
		}

		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState() : String{
			if(monitoringStatus=="active") 
				return "active";
			if(monitoringStatus=="done") 
				return "done";
			return super.getCurrentSkinState();
		}
	}
}