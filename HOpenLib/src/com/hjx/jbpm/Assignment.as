package com.hjx.jbpm
{
	public class Assignment extends JbpmBase
	{
		private var _className:String;
		
		public function Assignment()
		{
		}

		/**
		 * 转换为描述文件的时候，要把该属性改成“class” 
		 * @return 
		 * 
		 */
		public function get className():String
		{
			return _className;
		}

		public function set className(value:String):void
		{
			_className = value;
		}

	}
}