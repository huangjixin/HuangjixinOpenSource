package com.hjx.graphic
{
	import com.hjx.graphic.skin.NodeSkin;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	import spark.components.Label;

	/**
	 * 节点类基类。 
	 * @author huangjixin
	 * 
	 */
	[Style(name="backgroundColor", inherit="no", type="uint",format="Color")]
	[Style(name="borderColor", inherit="no", type="uint",format="Color")]
	/*[Style(name="caretColor", inherit="no", type="uint",format="Color")]*/
	[Style(name="color", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedColor", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedTextColor", inherit="yes", type="uint",format="Color")]
	public class Node extends Renderer
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
		private var _label:String = "节点";
		
		private var _movable : Boolean = true;
		
		private var _centerX : Number = NaN;
		private var _centerY : Number = NaN;
		
		private var defaultCSSStyles:Object = {
			skinClass:NodeSkin
		};
		
		//--------------------------------------------------------
		// public 公有变量声明处
		//--------------------------------------------------------
		[SkinPart]
		public var labelElement:Label;
		
		[SkinPart(required="true")]
		public var base:UIComponent;
		
		/*[SkinPart(required="true")]
		public dynamic var  overviewDisplay:IFactory;*/
		//--------------------------------------------------------
		// 构造函数，初始化相关工作可以放在里面
		//--------------------------------------------------------
		public function Node()
		{
			super();
			
		}//构造函数结束
		
		
		//--------------------------------------------------------
		// getter和setter函数
		//--------------------------------------------------------
		public function get centerY():Number
		{
			return x + (height / 2.0);;
		}
		
		public function set centerY(value:Number):void
		{
			_centerY = value;
		}
		
		public function get centerX():Number
		{
			return x + (width / 2.0);
		}
		
		public function set centerX(value:Number):void
		{
			_centerX = value;
		}
		
		[Bindable]
		/**
		 * 是否可以移动 
		 */
		public function get movable():Boolean
		{
			return _movable;
		}
		
		public function set movable(value:Boolean):void
		{
			_movable = value;
		}
		
		[Bindable]
		/**
		 * 元素上面的字符串。 
		 */
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			_label = value;
		}
		
		//--------------------------------------------------------
		// 相关事件响应函数和逻辑函数存放处
		//--------------------------------------------------------
		public function getIncomingLinks():Vector.<Link>{
			return null;
		}
		
		public function getIncomingLinksCount():int{
			return 0;
		}
		
		public function getLinks():Vector.<Link>{
			return null;
		}
		
		public function getLinksCount():int{
			return 0;
		}
		
		public function getNodeOrBaseBounds(targetCoordinateSpace:DisplayObject):Rectangle{
			return null;
		}
		
		public function getOutgoingLinks():Vector.<Link>{
			return null;
		}
		
		public function getOutgoingLinksCount():int{
			return 0;
		}
		
		public function resumeGraphLayoutInvalidationOnMoveResize():void{
		}
		
		public function suspendGraphLayoutInvalidationOnMoveResize():void{
		}

		
		//--------------------------------------------------------
		// override 覆盖函数
		//--------------------------------------------------------
		
		override public function stylesInitialized():void{
			super.stylesInitialized();
			for (var i:String in defaultCSSStyles) {
				if (getStyle (i) == undefined) {
					setStyle (i, defaultCSSStyles [i]);
				}
			}
//			setStyle("skinClass",NodeSkin);
		}
	}
}