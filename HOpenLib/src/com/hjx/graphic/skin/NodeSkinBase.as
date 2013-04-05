/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.graphic.skin
{
	/*******************************************
	 **** huangjixin,2013-3-28,下午4:25:08 **
	 **** 请一句话表述该类主要作用  **
	 *******************************************/
	import spark.skins.SparkSkin;
	
	public class NodeSkinBase extends SparkSkin
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
		private var _backgroundColor : uint = 0xD1CE9C;
		private var _borderColor : uint = 0x0;
		private var _caretColor : uint = 0xfff000;
		private var _color : uint = 0x0;
		private var _selectedColor : uint = 0xffffff;
		private var _selectedTextColor : uint = 0xffffff;
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 构造函数，初始化相关工作可以放在里面
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function NodeSkinBase()
		{
			super();
		}//构造函数结束
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// getter和setter函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 相关事件响应函数和逻辑函数存放处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// override 覆盖函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
		}

		/**
		 * 背景颜色。 
		 * @return 
		 * 
		 */
		[Bindable]
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		/**
		 * 边框颜色。 
		 * @return 
		 * 
		 */
		[Bindable]
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function get caretColor():uint
		{
			return _caretColor;
		}
		/**
		 * 文字颜色。 
		 * @return 
		 * 
		 */
		[Bindable]
		public function get color():uint
		{
			return _color;
		}
		/**
		 * 选中背景颜色。 
		 * @return 
		 * 
		 */
		[Bindable]
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		/**
		 * 选中背景颜色。 
		 * @return 
		 * 
		 */
		[Bindable]
		public function get selectedTextColor():uint
		{
			return _selectedTextColor;
		}
		
	}//类结束
}//包结束