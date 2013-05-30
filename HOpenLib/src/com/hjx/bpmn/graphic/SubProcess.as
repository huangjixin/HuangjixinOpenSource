package com.hjx.bpmn.graphic
{
	import com.hjx.graphic.SubGraph;
	
	[SkinState("activeCollapsed")]
	[SkinState("doneCollapsed")]
	public class SubProcess extends SubGraph
	{
		[Bindable]
		public var adHoc:Boolean;
		
		private var _monitoringStatus:String = "";
		
		public function SubProcess()
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
			if(monitoringStatus=="active" && collapsed ) 
				return "activeCollapsed";
			if(monitoringStatus=="done" && collapsed ) 
				return "doneCollapsed";
			return super.getCurrentSkinState();
		}
	}
}