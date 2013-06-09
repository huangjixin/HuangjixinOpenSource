package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Sub_process extends JbpmBase
	{
		private var _version:String;
		public function Sub_process()
		{
			super();
		}

		public function get version():String
		{
			return _version;
		}

		public function set version(value:String):void
		{
			_version = value;
		}

	}
}