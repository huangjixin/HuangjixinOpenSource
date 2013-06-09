package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Variable extends JbpmBase
	{
		private var _access:String = "read,write";
		public function Variable()
		{
			super();
		}

		/**
		 * 
		 */
		[Inspectable(enumeration="read,write,'read,write'")]
		public function get access():String
		{
			return _access;
		}

		/**
		 * @private
		 */
		public function set access(value:String):void
		{
			_access = value;
		}

	}
}