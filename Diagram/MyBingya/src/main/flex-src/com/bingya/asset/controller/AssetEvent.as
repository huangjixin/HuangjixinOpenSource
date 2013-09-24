package com.bingya.asset.controller
{
	import flash.events.Event;
	
	public class AssetEvent extends Event
	{
		public static const selectByUserId:String = "selectByUserId";
		public static const selectByUserIdResult:String = "selectByUserIdResult";
		public static const selectByUserIdFault:String = "selectByUserIdFault";

		public static const deleteByPrimaryKey:String = "deleteByPrimaryKey";
		public static const deleteByPrimaryKeyResult:String = "deleteByPrimaryKeyResult";
		public static const deleteByPrimaryKeyFault:String = "deleteByPrimaryKeyFault";

		public static const getPathsById:String = "getPathsById";
		public static const getPathsByIdResult:String = "getPathsByIdResult";
		public static const getPathsByIdFault:String = "getPathsByIdFault";

		public static const saveXmlStringToFile:String = "saveXmlStringToFile";
		public static const saveXmlStringToFileResult:String = "saveXmlStringToFileResult";
		public static const saveXmlStringToFileFault:String = "saveXmlStringToFileFault";

		public static const saveXmlStr:String = "saveXmlStr";
		public static const saveXmlStrResult:String = "saveXmlStrResult";
		public static const saveXmlStrFault:String = "saveXmlStrFault";
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		/**
		 *	事件派发捆绑数据； 
		 */
		public var object:Object;
		
		
		public function AssetEvent(type:String, object:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.object = object;
		}
	}
}