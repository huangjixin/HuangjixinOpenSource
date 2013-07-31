/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.bingya.test.model.business
{
	
	import com.bingya.common.Global;
	
	import mx.rpc.IResponder;
	import mx.rpc.remoting.mxml.RemoteObject;

	/*******************************************
	 **** huangjixin,2012-5-24,下午1:25:36 **
	 **** 大厅展示远程委托类，用于远程交互调用  **
	 *******************************************/
	public class TestRemoteServerDelegate
	{
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		private var _responder : IResponder;  
		private var _service : Object; 
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 构造函数，初始化相关工作可以放在里面
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function TestRemoteServerDelegate(pResponder : IResponder)
		{
			_service = new RemoteObject();  
			_service.endpoint = Global.getInstance().endPoint;  // 端点；
			_service.destination = "testRemoteServerImpl";        // 目标对象；
			_service.makeObjectsBindable=true;  
			_service.showBusyCursor=true;
			
			_responder = pResponder;
		}//构造函数结束
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 相关事件响应函数和逻辑函数存放处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function  getStr():void
		{
			var call:Object = _service.getStr();  
			call.addResponder(_responder);  
		}
		
	}//类结束
}//包结束