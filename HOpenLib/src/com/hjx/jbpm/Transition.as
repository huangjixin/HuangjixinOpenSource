package com.hjx.jbpm
{
	public class Transition extends JbpmBase
	{
		private var _to:String="变更审核组";
		
		public function Transition()
		{
		}

		[Bindable]
		public function get to():String
		{
			return _to;
		}

		public function set to(value:String):void
		{
			_to = value;
		}

	}
}