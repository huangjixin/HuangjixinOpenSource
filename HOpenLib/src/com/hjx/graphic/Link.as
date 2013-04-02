package com.hjx.graphic
{
	import com.hjx.graphic.skin.LinkSkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.events.MoveEvent;
	
	import spark.components.Button;
	import spark.primitives.Path;

	/**
	 * 所有连线的基类，用于连接节点。一条线可以没有节点，或者一个节点，或者两个节点，所以其必须有两个Node的引用。 
	 * @author huangjixin
	 * 
	 */
	[Style(name="caps", inherit="yes", type="String",enumeration="round,square,none")]
	[Style(name="caretColor", inherit="no", type="uint",format="Color")]
	[Style(name="dashArray", inherit="no", type="Array")]
	[Style(name="dashStyle", inherit="no", type="String",enumeration="none,dash,dot,dashDot")]
	[Style(name="endArrowType", inherit="yes", type="String",enumeration="triangle,open,sunken,curved,square,diamond,circle,star")]
	[Style(name="endArrowVisible", inherit="yes", type="Boolean",format="Boolean")]
	[Style(name="joints", inherit="yes", type="String",enumeration="round,miter,bevel")]
	[Style(name="miterLimit", inherit="yes", type="uint",format="Number")]
	[Style(name="orthogonalSpacing", inherit="no", type="Number")]
	[Style(name="pixelHinting", inherit="yes", type="Boolean",format="Boolean")]
	[Style(name="radius", inherit="no", type="Number")]
	[Style(name="selectedColor", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedStrokeWidth", inherit="yes", type="uint",format="Number")]
	[Style(name="startArrowType", inherit="yes", type="String",enumeration="triangle,open,sunken,curved,square,diamond,circle,star")]
	[Style(name="startArrowVisible", inherit="yes", type="Boolean",format="Boolean")]
	[Style(name="strokeColor", inherit="yes", type="uint",format="Color")]
	[Style(name="strokeWidth", inherit="yes", type="uint",format="Number")]
	public class Link extends Renderer
	{
		private var _startNode:Node;
		private var _endNode:Node;
		
		private var _shapeType:String;
		
		private var _fallbackEndPoint:Point;
		private var _fallbackStartPoint:Point;
		
		/**
		 * 默认css风格。
		 * 
		 */
		private var defaultCSSStyles:Object = {
			dashStyle: "none", 
			endArrowType: "triangle", 
			endArrowVisible: true, 
			orthogonalSpacing: 0, 
			radius: 0, 
			strokeWidth: 1, 
			strokeColor: 0x0, 
			startArrowType: "triangle", 
			startArrowVisible: false,
			skinClass:LinkSkin
		};
		
		[SkinPart(required="false")]
		public var endArrow:Path;
		[SkinPart(required="true")]
		public var path:Path;
		[SkinPart(required="false")]
		public var startArrow:Path;
		
		public function Link(startNode:Node=null,endNode:Node=null)
		{
			super();
			this.startNode = startNode;
			this.endNode = endNode;
		}
		
		[Bindable]
		public function get fallbackStartPoint():Point
		{
			return _fallbackStartPoint;
		}

		public function set fallbackStartPoint(value:Point):void
		{
			_fallbackStartPoint = value;
		}

		[Bindable]
		public function get fallbackEndPoint():Point
		{
			return _fallbackEndPoint;
		}

		public function set fallbackEndPoint(value:Point):void
		{
			_fallbackEndPoint = value;
		}

		[Bindable]
		[Inspectable(enumeration="straight,free,orthogonal,oblique")]
		public function get shapeType():String
		{
			return _shapeType;
		}

		public function set shapeType(value:String):void
		{
			_shapeType = value;
		}

		[Bindable(event="endNodeChange")]
		/**
		 * 终止节点。 
		 */
		public function get endNode():Node
		{
			return _endNode;
		}

		/**
		 * @private
		 */
		public function set endNode(value:Node):void
		{
			if( _endNode !== value)
			{
				_endNode = value;
				dispatchEvent(new Event("endNodeChange"));
			}
		}

		/**
		 * 起始节点。 
		 */
		[Bindable(event="startNodeChange")]
		public function get startNode():Node
		{
			return _startNode;
		}

		public function set startNode(value:Node):void
		{
			if( _startNode !== value)
			{
				_startNode = value;
				dispatchEvent(new Event("startNodeChange"));
			}
		}
		
		
		/**
		 * 绘制图形。 
		 * 
		 */
		private function draw():void{
			path.data = "M 0 0 H -100 V -100 Z";var b:Button
		}
		
		//-----------------------------------------------------------
		// 覆盖函数
		//-----------------------------------------------------------
		override public function stylesInitialized():void{
			super.stylesInitialized();
			for (var i:String in defaultCSSStyles) {
				if (getStyle (i) == undefined) {
					setStyle (i, defaultCSSStyles [i]);
				}
			}
		} 
		
		override public function styleChanged(styleProp:String):void{
			super.styleChanged(styleProp);
			callLater(draw);
		} 
	}
}