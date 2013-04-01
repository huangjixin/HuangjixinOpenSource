/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.graphic
{
	/*******************************************
	 **** huangjixin,2013-3-29,上午9:27:15 **
	 **** 请一句话表述该类主要作用  **
	 *******************************************/
	import com.hjx.graphic.skin.SubGraphSkin;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	[DefaultProperty("mxmlContent")] 
	public class SubGraph extends Node implements IVisualElementContainer
	{
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// private 类私有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：private static const EXAMPLE:String = "example";
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 类公有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：public static const EXAMPLE:String = "example";
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		private var mxmlContentChanged:Boolean = false;
		private var _mxmlContent:Array;
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		[SkinPart(required="true")]
		public var graph:Graph;
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 构造函数，初始化相关工作可以放在里面
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function SubGraph()
		{
			super();
			
			setStyle("skinClass",SubGraphSkin);
		}
		//构造函数结束
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// getter和setter函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/		
		/**
		 * 该setter函数保证了可以在mxml里面进行组件声明。 
		 * @param value
		 * 
		 */
		public function set mxmlContent(value:Array):void
		{
			_mxmlContent = value;
			mxmlContentChanged = true;
		}
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 相关事件响应函数和逻辑函数存放处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		//--------------------------------------------------------------------------
		//
		//  内容管理
		//
		//--------------------------------------------------------------------------
		public function get numElements():int
		{
			return graph.numElements;
		}
		
		public function getElementAt(index:int):IVisualElement
		{
			return graph.getElementAt(index);
		}
		
		public function addElement(element:IVisualElement):IVisualElement
		{
			return graph.addElement(element);
		}
		
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			return graph.addElementAt(element, index);
		}
		
		public function removeElement(element:IVisualElement):IVisualElement
		{
			return graph.removeElement(element);
		}
		
		public function removeElementAt(index:int):IVisualElement
		{
			return graph.removeElementAt(index);
		}
		
		public function removeAllElements():void
		{
			graph.removeAllElements();
		}
		
		public function getElementIndex(element:IVisualElement):int
		{
			return graph.getElementIndex(element);
		}
		
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			graph.setElementIndex(element,index);
		}
		
		public function swapElements(element1:IVisualElement, element2:IVisualElement):void
		{
			graph.swapElements(element1,element2);
		}
		
		public function swapElementsAt(index1:int, index2:int):void
		{
			graph.swapElementsAt(index1,index2);
		}
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// override 覆盖函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		/**
		 * 当graph被实例化的时候，赋值mxml内容。 
		 * @param partName
		 * @param instance
		 * 
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			if(instance == graph){
				if(mxmlContentChanged){
					graph.mxmlContent = _mxmlContent;
				}
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partRemoved(partName, instance);
			if(instance == graph){
				if(mxmlContentChanged){
					graph.mxmlContent = [];
				}
			}
		}
	}//类结束
}//包结束