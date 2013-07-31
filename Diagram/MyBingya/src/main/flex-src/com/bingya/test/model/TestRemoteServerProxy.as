package com.bingya.test.model
{
	import com.bingya.test.controller.TestRemoteServerEvent;
	import com.bingya.test.model.business.TestRemoteServerDelegate;
	
	import flash.events.EventDispatcher;
	
	import mx.controls.Alert;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	[Bindable]
	public class TestRemoteServerProxy  extends EventDispatcher
	{
		public function TestRemoteServerProxy()
		{
		}
		
		public function getStr():void  
		{  
			var delegate:TestRemoteServerDelegate = new TestRemoteServerDelegate(new Responder(getStrResult, getStrFault));  
			delegate.getStr();
		}
		
		private function getStrResult(event:ResultEvent):void
		{
			dispatchEvent(new TestRemoteServerEvent(TestRemoteServerEvent.getStrResult,event.result)); 
			Alert.show(event.result.toString());
		}
		
		private function getStrFault(event:FaultEvent):void  
		{  
			dispatchEvent(new TestRemoteServerEvent(TestRemoteServerEvent.getStrFault,event.fault));
		} 
	}
}