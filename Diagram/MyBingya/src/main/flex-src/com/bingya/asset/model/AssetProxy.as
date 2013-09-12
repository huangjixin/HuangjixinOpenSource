package  com.bingya.asset.model
{
	import com.bingya.asset.controller.AssetEvent;
	import com.bingya.asset.model.business.AssetDelegate;
	
	import flash.events.EventDispatcher;
	
	import mx.controls.Alert;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	[Bindable]
	public class AssetProxy  extends EventDispatcher
	{
		public function AssetProxy()
		{
		}
		
		public function selectByUserId(userId:int):void  
		{  
			var delegate:AssetDelegate = new AssetDelegate(new Responder(selectByUserIdResult, selectByUserIdFault));  
			delegate.selectByUserId(userId);
		}
		
		private function selectByUserIdResult(event:ResultEvent):void
		{
			dispatchEvent(new AssetEvent(AssetEvent.selectByUserIdResult,event.result)); 
		}
		
		private function selectByUserIdFault(event:FaultEvent):void  
		{  
			dispatchEvent(new AssetEvent(AssetEvent.selectByUserIdFault,event.fault));
		} 
		
		public function deleteByPrimaryKey(id:int):void  
		{  
			var delegate:AssetDelegate = new AssetDelegate(new Responder(deleteByPrimaryKeyResult, deleteByPrimaryKeyFault));  
			delegate.deleteByPrimaryKey(id);
		}
		
		private function deleteByPrimaryKeyResult(event:ResultEvent):void
		{
			dispatchEvent(new AssetEvent(AssetEvent.deleteByPrimaryKeyResult,event.result)); 
		}
		
		private function deleteByPrimaryKeyFault(event:FaultEvent):void  
		{  
			dispatchEvent(new AssetEvent(AssetEvent.deleteByPrimaryKeyFault,event.fault));
		} 
	}
}