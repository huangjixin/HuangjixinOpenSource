package com.hjx.bpmn.graphic
{
	import com.hjx.jbpm.End_state;

	public class EndEvent extends Event
	{
		private var _end_state:End_state = new End_state();
		public function EndEvent()
		{
			super();
		}

		public function get end_state():End_state
		{
			return _end_state;
		}

		public function set end_state(value:End_state):void
		{
			_end_state = value;
		}

		
		override public function set label(value:String):void{
			super.label = value;
			
			end_state.name = value;
		}
	}
}