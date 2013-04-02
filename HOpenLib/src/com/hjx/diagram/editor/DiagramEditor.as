/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.diagram.editor
{
	/*******************************************
	 **** huangjixin,2013-4-2,下午2:06:27 作者：黄记新**
	 **** Diagram编辑器  **
	 *******************************************/
	import com.hjx.diagram.Diagram;
	import com.hjx.diagram.editor.skin.DiagramEditorSkin;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	[DefaultProperty("diagram")]
	public class DiagramEditor extends SkinnableComponent
	{
		//--------------------------------------------------------
		// private 类私有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：private static const EXAMPLE:String = "example";
		//--------------------------------------------------------
		
		//--------------------------------------------------------
		// public 类公有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：public static const EXAMPLE:String = "example";
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//--------------------------------------------------------
		private var defaultCSSStyles:Object = {
			skinClass:DiagramEditorSkin
		};
		
		private var _diagram:Diagram;
		private var _diagramChanged:Boolean = false;
		//--------------------------------------------------------
		// public 公有变量声明处
		//--------------------------------------------------------
		[SkinPart(required="true")]
		public var adornersGroup:Group;
		[SkinPart(required="true")]
		public var diagramParent:Group;
		[SkinPart(required="false")]
		public var grid:Grid;
		
		//--------------------------------------------------------
		// 构造函数，初始化相关工作可以放在里面
		//--------------------------------------------------------
		public function DiagramEditor()
		{
			super();
		}//构造函数结束
		
		
		//--------------------------------------------------------
		// getter和setter函数
		//--------------------------------------------------------
		[Bindable]
		public function get diagram():Diagram
		{
			return _diagram;
		}
		
		public function set diagram(value:Diagram):void
		{
			_diagram = value;
			_diagramChanged = true;
			invalidateProperties();
		}
		
		//--------------------------------------------------------
		// 相关事件响应函数和逻辑函数存放处
		//--------------------------------------------------------
		/**
		 * 安装Diagram。 
		 * 
		 */
		private function installDiagram():void
		{
			if (diagramParent)
			{
				diagramParent.addElementAt(diagram, 0);
			}
		}
		
		//--------------------------------------------------------
		// override 覆盖函数
		//--------------------------------------------------------
		override protected function commitProperties():void{
			super.commitProperties();
			if(_diagramChanged){
				_diagramChanged = false;
				installDiagram();
			}
		}
		
		override public function stylesInitialized():void{
			super.stylesInitialized();
			for (var i:String in defaultCSSStyles) {
				if (getStyle (i) == undefined) {
					setStyle (i, defaultCSSStyles [i]);
				}
			}
		}
	}//类结束
}//包结束