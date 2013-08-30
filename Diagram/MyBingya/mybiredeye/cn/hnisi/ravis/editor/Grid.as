/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package cn.hnisi.ravis.editor
{
	import flash.display.Graphics;
	
	import spark.components.Group;

	/*******************************************
	 **** huangjixin,2012-5-17,上午11:34:51 **
	 **** 数据表格  **
	 *******************************************/
	
	/**
	 * 数据表格
	 * @author huangjixin
	 * 
	 */
	public class Grid extends Group
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
		private var _showGrid:Boolean = true;
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 构造函数，初始化相关工作可以放在里面
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function Grid()
		{
			super();
			
		}//构造函数结束
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// getter和setter函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		/**
		 *	是否显示表格 
		 * @return 
		 * 
		 */
		public function get showGrid():Boolean
		{
			return _showGrid;
		}
		
		public function set showGrid(value:Boolean):void
		{
			_showGrid = value;
			invalidateDisplayList();
		}
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 相关事件响应函数和逻辑函数存放处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		private function drawBackGroudGridLines(width:Number, height:Number, gridWidth:Number, gridHeight:Number, g:Graphics):void
		{
			var widthSize:int=width / gridWidth;
			var heightSize:int=height / gridHeight;
			
			for (var i:int=0; i < widthSize+1; i++)
			{
				g.moveTo(i * gridWidth, 0);
				g.lineTo(i * gridWidth, height);
			}
			
			for (var j:int=0; j < heightSize+1; j++)
			{
				g.moveTo(0, j * gridHeight);
				g.lineTo(width, j * gridHeight);
			}
			
			for (var m:int=0; m < widthSize; m+=5)
			{
				g.moveTo(m * gridWidth, 0);
				g.lineTo(m * gridWidth, height);
			}
			
			for (var n:int=0; n < heightSize; n+=5)
			{
				g.moveTo(0, n * gridHeight);
				g.lineTo(width, n * gridHeight);
			}
		}
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// override 覆盖函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			var g:Graphics = graphics;
			if (showGrid)
			{
				g.clear();
				g.lineStyle(1, 0x000000, 0.1);
				drawBackGroudGridLines(width, height, 10, 10, g);
			}
			else
			{
				g.clear();
			}
		} 

	}//类结束
}//包结束