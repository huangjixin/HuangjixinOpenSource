/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.diagram.events
{
	/*******************************************
	 **** huangjixin,2013-4-3,下午2:54:01 作者：黄记新**
	 **** 请一句话表述该类主要作用  **
	 *******************************************/
	import flash.events.Event;
	import com.hjx.graphic.Renderer;
	
	public class DiagramEvent extends Event
	{
		//--------------------------------------------------------
		// private 类私有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：private static const EXAMPLE:String = "example";
		//--------------------------------------------------------
		
		//--------------------------------------------------------
		// public 类公有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：public static const EXAMPLE:String = "example";
		//--------------------------------------------------------
		/**
		 * 
		 */
		public static const NODE_CLOSE : String = "nodeClose";
		/**
		 * 
		 */
		public static const NODE_OPEN : String = "nodeOpen";
		/**
		 * 
		 */
		public static const NODE_OPENING : String = "nodeOpening";
		/**
		 * 
		 */
		public static const SELECTION_CHANGE : String = "selectionChange";
		
		//--------------------------------------------------------
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// public 公有变量声明处
		//--------------------------------------------------------
		/**
		 * 节点或者连线里面的数据。
		 */
		public var item : Object;
		public var deselectedItems:Vector.<Object>;
		/**
		 * 渲染器。 
		 */
		public var itemRenderer:Renderer;
		public var selectedItems:Vector.<Object>
		//--------------------------------------------------------
		// 构造函数，初始化相关工作可以放在里面
		//--------------------------------------------------------
		public function DiagramEvent(type:String,item : Object= null,itemRenderer:Renderer = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.item = item;
			this.itemRenderer = itemRenderer;
		}//构造函数结束
		
		
		//--------------------------------------------------------
		// getter和setter函数
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// 相关事件响应函数和逻辑函数存放处
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// override 覆盖函数
		//--------------------------------------------------------
	}//类结束
}//包结束