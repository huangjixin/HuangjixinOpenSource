/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.diagram
{
	/*******************************************
	 **** huangjixin,2013-3-29,上午8:44:56 **
	 **** 图形绘制，包括节点和连线。  **
	 *******************************************/
	import com.hjx.diagram.skin.DiagramSkin;
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.GraphScroller;
	import com.hjx.graphic.graphlayout.GraphLayout;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class Diagram extends SkinnableComponent
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
		private var _selectionMode:String = "multiple";
		
		/**
		 * 默认css风格。 
		 */
		private var defaultCSSStyles:Object = {
			skinClass:DiagramSkin
		};
		
		private var _nodeLayout:GraphLayout;
		
		private var _automaticGraphLayout:Boolean = false;
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		[SkinPart(required="true")]
		public var graph:Graph;
		
		[SkinPart(required="true")]
		public var graphScroller:GraphScroller;
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 构造函数，初始化相关工作可以放在里面
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function Diagram()
		{
			super();
		}//构造函数结束
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// getter和setter函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

		[Bindable]
		/**
		 * 是否自动布局。
		 * @return 
		 * 
		 */
		public function get automaticGraphLayout():Boolean
		{
			return _automaticGraphLayout;
		}

		public function set automaticGraphLayout(value:Boolean):void
		{
			_automaticGraphLayout = value;
		}

		[Bindable]
		[Inspectable(enumeration="multiple,single",defaultValue="multiple")]
		/**
		 * 选中模式。 
		 */
		public function get selectionMode():String
		{
			return _selectionMode;
		}

		/**
		 * @private
		 */
		public function set selectionMode(value:String):void
		{
			_selectionMode = value;
		}

		[Bindable]
		/**
		 * 节点布局。 
		 */
		public function get nodeLayout():GraphLayout
		{
			return _nodeLayout;
		}
		
		/**
		 * @private
		 */
		public function set nodeLayout(value:GraphLayout):void
		{
			_nodeLayout = value;
		}
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 相关事件响应函数和逻辑函数存放处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// override 覆盖函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

		override public function stylesInitialized():void{
			super.stylesInitialized();
			for (var i:String in defaultCSSStyles) {
				if (getStyle (i) == undefined) {
					setStyle (i, defaultCSSStyles [i]);
				}
			}
			//			setStyle("skinClass",NodeSkin);
		}
	}//类结束
}//包结束