package com.hjx.bpmn.graphic
{
	import com.hjx.jbpm.Decision;
	import com.hjx.jbpm.Handler;

	public class Gateway extends FlowObject
	{
		[Bindable]
		public var gatewayType:String;
		
		private var _decision:Decision = new Decision();
		
		public function Gateway()
		{
			super();
		}

		public function get decision():Decision
		{
			return _decision;
		}

		public function set decision(value:Decision):void
		{
			_decision = value;
		}

		
		override public function set label(value:String):void{
			super.label = value;
			
			decision.name = value;
		}
	}
}