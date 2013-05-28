/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.geom
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	
	import spark.core.DisplayObjectSharingMode;
	import spark.primitives.supportClasses.GraphicElement;
	
	/**
	 * Point with associated constraints values
	 * 
	 * @description
	 * <p>Constraint values are not taken into account directly in the couple of properties x/y.<br />
	 * The method getConstraintPoint() calculates and returns the point x/y, according to constraint values, compared to a target GraphicElement.</p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 */
	public class ConstraintPoint extends Point
	{
		public static const LEFT_CONSTRAINT : String = "left";
		public static const RIGHT_CONSTRAINT : String = "right";
		public static const HORIZONTAL_CENTER_CONSTRAINT : String = "horizontalCenter";
		public static const X_CONSTRAINT : String = "x";
		
		public static const TOP_CONSTRAINT : String = "top";
		public static const BOTTOM_CONSTRAINT : String = "bottom";
		public static const VERTICAL_CENTER_CONSTRAINT : String = "verticalCenter";
		public static const Y_CONSTRAINT : String = "y";
		
		/**
		 * Constructor
		 */
		public function ConstraintPoint(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
		
		private var _valuesInPercent : Boolean = false;

		public function get valuesInPercent():Boolean
		{
			return _valuesInPercent;
		}

		public function set valuesInPercent(value:Boolean):void
		{
			_valuesInPercent = value;
		}

		/**
		 * @private
		 */
		private var _top : Number;
		/**
		 * @private
		 */
		private var _bottom : Number;
		/**
		 * @private
		 */
		private var _left : Number;		
		/**
		 * @private
		 */
		private var _right : Number;
		/**
		 * @private
		 */
		private var _horizontalCenter: Number;	
		/**
		 * @private
		 */
		private var _verticalCenter: Number;
		
		/**
		 * HorizontalCenter constraint value
		 */
		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		/**
		 * @private
		 */
		public function set horizontalCenter(value:Number):void
		{
			_horizontalCenter = value;
		}
		/**
		 * VerticalCenter constraint value
		 */
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		/**
		 * @private
		 */
		public function set verticalCenter(value:Number):void
		{
			_verticalCenter = value;
		}
		/**
		 * Top constraint value
		 */
		public function get top():Number
		{
			return _top;
		}
		/**
		 * @private
		 */
		public function set top(value:Number):void
		{
			_top = value;
		}
		/**
		 * Bottom constraint value
		 */
		public function get bottom():Number
		{
			return _bottom;
		}
		/**
		 * @private
		 */
		public function set bottom(value:Number):void
		{
			_bottom = value;
		}
		/**
		 * Left constraint value
		 */
		public function get left():Number
		{
			return _left;
		}
		/**
		 * @private
		 */
		public function set left(value:Number):void
		{
			_left = value;
		}
		/**
		 * Right constraint value
		 */
		public function get right():Number
		{
			return _right;
		}
		/**
		 * @private
		 */
		public function set right(value:Number):void
		{
			_right = value;
		}
		
		protected function hasVerticalConstraint() : Boolean
		{
			return top || verticalCenter || bottom; 
		}
		
		public function getVerticalConstraint() : String
		{
			var relevantVProperties : String;
			if( !isNaN( top ) )  {
				return TOP_CONSTRAINT;
			}
			if( !isNaN( bottom ) )  {
				return BOTTOM_CONSTRAINT;
			}
			if( !isNaN( verticalCenter ) )  {
				return VERTICAL_CENTER_CONSTRAINT;
			}
			return Y_CONSTRAINT; 
		}
		
		protected function hasHorizontalConstraint() : Boolean
		{
			return left || horizontalCenter || right; 
		}
		
		public function getHorizontalConstraint() : String
		{
			var relevantVProperties : String;
			if( !isNaN( left ) )  {
				return LEFT_CONSTRAINT;
			}
			if( !isNaN( right ) )  {
				return RIGHT_CONSTRAINT;
			}
			if( !isNaN( horizontalCenter ) )  {
				return HORIZONTAL_CENTER_CONSTRAINT;
			}
			return X_CONSTRAINT; 
		}
		
		/**
		 * Calculates and returns the point x/y, according to constraint values, compared to a target GraphicElement.
		 */
		public function getConstraintPoint( graphicElement : IVisualElement, sx:Number = 1, sy : Number = 1 ) : Point
		{
			
			var pointx : Number = 0;
			var pointy : Number = 0;
			
			var xOffset : Number;
			var yOffset : Number;
			
			if (graphicElement is GraphicElement && (graphicElement as GraphicElement).displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT) {
				xOffset = 0;
				yOffset = 0;
			}
			else {
				xOffset = graphicElement.postLayoutTransformOffsets ? graphicElement.x + graphicElement.postLayoutTransformOffsets.x : graphicElement.x;
				yOffset = graphicElement.postLayoutTransformOffsets ? graphicElement.y + graphicElement.postLayoutTransformOffsets.y : graphicElement.y;
			}
			
			// Calcutates y position
			if( !isNaN( top ) ) {
				pointy = valuesInPercent ? yOffset + top/100*graphicElement.height : yOffset + top;
			}
			else if( !isNaN( bottom ) ) {
				pointy = valuesInPercent ? yOffset + graphicElement.height - bottom/100*graphicElement.height  : yOffset + graphicElement.height - bottom;
			}
			else if( !isNaN( verticalCenter ) ) {
				pointy = valuesInPercent ? yOffset + ( graphicElement.height ) / 2 + verticalCenter/100*graphicElement.height : yOffset + ( graphicElement.height ) / 2 + verticalCenter;
			}
			else {
				pointy = valuesInPercent ? (yOffset + y/100*graphicElement.height)*sy : (yOffset + y)*sy;
			}
			
			// Calcutates x position
			if( !isNaN( left ) ) {
				pointx = valuesInPercent ? xOffset + left/100*graphicElement.width  : xOffset + left;
			}
			else if( !isNaN( right ) ) {
				pointx = valuesInPercent ? xOffset + graphicElement.width - right/100*graphicElement.width : xOffset + graphicElement.width - right;
			}
			else if( !isNaN( horizontalCenter ) ) {
				pointx = valuesInPercent ? xOffset + ( graphicElement.width ) / 2 + horizontalCenter/100*graphicElement.width : xOffset + ( graphicElement.width ) / 2 + horizontalCenter;
			}
			else {
				pointx = valuesInPercent ? (xOffset + x/100*graphicElement.width)*sx : (xOffset + x)*sx;
			}
			
			return new Point( Math.round(pointx), Math.round(pointy) );
		}
	}
}