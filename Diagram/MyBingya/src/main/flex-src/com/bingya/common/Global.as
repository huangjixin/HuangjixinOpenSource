/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.bingya.common
{
	import mx.core.FlexGlobals;
	import mx.utils.URLUtil;

	/*******************************************
	 **** huangjixin,2012-5-24,下午1:30:53 **
	 **** 全局静态类,可用于保存相关的静态变量或常量  **
	 *******************************************/
	[Bindable]
	public class Global
	{
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// private 类私有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：private static const EXAMPLE:String = "example";
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		private static var _instance:Global;
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 类公有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：public static const EXAMPLE:String = "example";
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public var endPoint:String = "http://localhost:8080/gdds_portal/messagebroker/amf";
		
		public var url:String = "";
		
		public var urlWithName:String = "";
		
		public var FileUploadPath:String = "";
		
		public var recordPath:String = "rtmp://localhost/RecordStream/";
		
		public var appFileUrl:String = "http://localhost:8080/gdds_portal/hall_swf/gdds_portal.swf";
		
		public var frequency:Number = 900000;			//定时播放频率；
		
		public var autoPlayFrequent:Number = 900000;	//自动播放频率
		
		public var basicValue:Number = 34;	//基准值
		
		public var isWeb:Boolean;	//是否基于web；
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 构造函数，初始化相关工作可以放在里面
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function Global()
		{
			if(_instance){
				throw new Error("请使用getInstance函数");
			}
		}//构造函数结束
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// getter和setter函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 相关事件响应函数和逻辑函数存放处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public static function getInstance():Global
		{
			if (!_instance){
				_instance = new Global();
			}
			
			return _instance; 
		}
		
		/**
		 * 通过解析URL，設置endPoint属性 
		 * @return 
		 * 
		 */
		public function setUrl():Boolean
		{
			var url:String = "";
			var endPoint:String = "";
			url = FlexGlobals.topLevelApplication.url;
			var isHttpUrl:Boolean = URLUtil.isHttpURL(url);			
			if(!isHttpUrl){
				return false;
			}
			//解析协议；
			var protocol:String = URLUtil.getProtocol(url);
			//解析服务器和端口；
			var serverNameWithPort:String = URLUtil.getServerNameWithPort(url);
			endPoint = protocol + "://"+serverNameWithPort;
			//解析应用路径；
			var array:Array = url.split("/");
			if(array && array.length>4){
				endPoint+="/"+array[3];
			}
			
 			Global.getInstance().recordPath = "rtmp://"+URLUtil.getServerName(url)+"/RecordStream/";
			
			Global.getInstance().url = endPoint;
			
			Global.getInstance().urlWithName = endPoint+"/FileUploaded";
			
			Global.getInstance().endPoint = endPoint + "/"+'messagebroker/amf';
			
			Global.getInstance().isWeb = isHttpUrl;
			return true;
		}
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// override 覆盖函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
	}//类结束
}//包结束