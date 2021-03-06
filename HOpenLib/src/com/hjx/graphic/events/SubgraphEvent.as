/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.graphic.events
{
	/*******************************************
	 **** huangjixin,2013-4-10,下午4:32:25 作者：黄记新**
	 **** 子图事件类  **
	 *******************************************/
	import flash.events.Event;
	
	public class SubgraphEvent extends Event
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
		 * 收缩动画结束事件。 
		 */
		public static const COLLAPSE_ANIMATION_END : String = "collapseAnimationEnd";
		/**
		 * 收缩动画开始事件。 
		 */
		public static const COLLAPSE_ANIMATION_START : String = "collapseAnimationStart";
		/**
		 * 张开动画开始事件。 
		 */
		public static const EXPAND_ANIMATION_END : String = "expandAnimationEnd";
		/**
		 * 张开动画开始事件。 
		 */
		public static const EXPAND_ANIMATION_START : String = "expandAnimationStart";
		
		
		//--------------------------------------------------------
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// public 公有变量声明处
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// 构造函数，初始化相关工作可以放在里面
		//--------------------------------------------------------
		/**
		 * 创建新的子图事件。 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function SubgraphEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
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