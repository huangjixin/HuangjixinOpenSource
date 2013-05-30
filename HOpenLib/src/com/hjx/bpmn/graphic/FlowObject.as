package com.hjx.bpmn.graphic
{
	import com.hjx.graphic.Node;
	
	[SkinState("active")]
	[SkinState("done")]
	public class FlowObject extends Node
	{
		/** Indicates the monitoring status: either active or done*/
		private var _monitoringStatus:String = "";
		
		public function FlowObject()
		{
			super();
		}
		
		[Bindable]
		public function get monitoringStatus():String{
			return _monitoringStatus;
		}
		
		public function set monitoringStatus(value:String):void{
			_monitoringStatus = value;
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