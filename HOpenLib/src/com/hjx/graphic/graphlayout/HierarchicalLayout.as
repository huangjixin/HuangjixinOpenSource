/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.graphic.graphlayout
{
	/*******************************************
	 **** huangjixin,2013-4-3,上午11:30:52 作者：黄记新**
	 **** 分层布局类。  **
	 *******************************************/
	
	public class HierarchicalLayout extends GraphLayout
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
		 * 波利线 
		 */
		public static const POLYLINE_STYLE:String = "polylineStyle";
		/**
		 * 折线。 
		 */
		public static const ORTHOGONAL_STYLE:String = "orthogonalStyle";
		/**
		 * 直连线。 
		 */
		public static const STRAIGHT_LINE_STYLE :String = "straightStyle";
		public static const NO_RESHAPE_STYLE :String = "noReshapeStyle";
		/**
		 * 连线多钟风格共存。 
		 */
		public static const MIXED_STYLE :String = "mixedStyle";
		
		//--------------------------------------------------------
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//--------------------------------------------------------
		private var _flowDirection:String =  HierarchicalLayoutFlowDirection.RIGHT;
		/**
		 * 全局连线形状。 
		 */
		private var globalLinkStyle:String = "polylineStyle";
		//--------------------------------------------------------
		// public 公有变量声明处
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// 构造函数，初始化相关工作可以放在里面
		//--------------------------------------------------------
		/**
		 * 创建一个或者拷贝一个新的布局实例。 
		 * @param source
		 * 
		 */
		public function HierarchicalLayout(source:HierarchicalLayout = null)
		{
			super();
		}//构造函数结束
		
		
		//--------------------------------------------------------
		// getter和setter函数
		//--------------------------------------------------------
		[Bindable]
		[Inspectable(enumeration="left,right,top,bottom")]
		/**
		 *This feature sets the direction of the flow for the majority of the links in a directed graph. 
		 * The layout algorithm may need to direct some links in the opposite direction of the general link flow.
		 *  If the links flow to the left or right, the nodes are placed in vertical levels. 
		 * If the links flow to the top or bottom, the nodes are placed in horizontal levels. 
		 */
		public function get flowDirection():String
		{
			return _flowDirection;
		}
		
		public function set flowDirection(value:String):void
		{
			_flowDirection = value;
		}
		
		//--------------------------------------------------------
		// 相关事件响应函数和逻辑函数存放处
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// override 覆盖函数
		//--------------------------------------------------------


	}//类结束
}//包结束