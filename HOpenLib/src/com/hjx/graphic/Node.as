package com.hjx.graphic
{
	import com.hjx.graphic.skin.NodeSkin;
	
	import spark.components.Label;

	/**
	 * 节点类基类。 
	 * @author huangjixin
	 * 
	 */
	[Style(name="backgroundColor", inherit="no", type="uint",format="Color")]
	[Style(name="borderColor", inherit="no", type="uint",format="Color")]
	[Style(name="caretColor", inherit="no", type="uint",format="Color")]
	[Style(name="color", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedColor", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedTextColor", inherit="yes", type="uint",format="Color")]
	public class Node extends Renderer
	{
		[SkinPart]
		public var labelElement:Label;
		
		private var _label:String;
		
		private var _movable : Boolean = true;
		
		private var _centerX : Number = NaN;
		private var _centerY : Number = NaN;
		public function Node()
		{
			super();
			
			setStyle("skinClass",NodeSkin);
			
			label = "节点";
		}

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
	}
}