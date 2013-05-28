/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.geom
{
	import flash.geom.Point;
	
	import spark.primitives.supportClasses.GraphicElement;

	/**
	 * ConstraintPoint with position of successor and predecessor bezier points
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 */
	public class ComplexPoint extends ConstraintPoint
	{
		/**
		 * Constructor
		 */
		public function ComplexPoint(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
		
		private var _keepAnchorPosition : Boolean = false;

		public function get keepAnchorPosition():Boolean
		{
			return _keepAnchorPosition;
		}

		public function set keepAnchorPosition(value:Boolean):void
		{
			_keepAnchorPosition = value;
		}
		
		private var _nextAnchorOffsetX : Number;
		private var _nextAnchorOffsetY : Number;
		private var _prevAnchorOffsetX : Number;
		private var _prevAnchorOffsetY : Number;
		
		/**
		 * Define the x offset in pixel of the successor bezier point
		 */
		public function get nextAnchorOffsetX():Number
		{
			return !isNaN(_nextAnchorOffsetX) ? _nextAnchorOffsetX : 0;
		}
		/**
		 * @private
		 */
		public function set nextAnchorOffsetX(value:Number):void
		{
			_nextAnchorOffsetX = value;
		}
		/**
		 * Define the y offset in pixel of the successor bezier point
		 */
		public function get nextAnchorOffsetY():Number
		{
			return !isNaN(_nextAnchorOffsetY) ? _nextAnchorOffsetY : 0;
		}
		/**
		 * @private
		 */
		public function set nextAnchorOffsetY(value:Number):void
		{
			_nextAnchorOffsetY = value;
		}
		
		/**
		 * Define the x offset in pixel of the predecessor bezier point
		 */
		public function get prevAnchorOffsetX():Number
		{
			return !isNaN(_prevAnchorOffsetX) ? _prevAnchorOffsetX : 0;
		}
		/**
		 * @private
		 */
		public function set prevAnchorOffsetX(value:Number):void
		{
			_prevAnchorOffsetX = value;
		}

		/**
		 * Define the y offset in pixel of the predecessor bezier point
		 */
		public function get prevAnchorOffsetY():Number
		{
			return !isNaN(_prevAnchorOffsetY) ? _prevAnchorOffsetY : 0;
		}
		/**
		 * @private
		 */
		public function set prevAnchorOffsetY(value:Number):void
		{
			_prevAnchorOffsetY = value;
		}
		/**
		 * retrun the predecessor Bezier point
		 */
		public function getPredecessorBezier(graphicElement : GraphicElement, sx:Number = 1, sy : Number = 1 ) : Point
		{
			if( hasVerticalConstraint() ) {
				sy = 1;
			}
			if( hasHorizontalConstraint() ) {
				sx = 1;
			}
			var point : Point = getConstraintPoint( graphicElement, sx, sy ); 
			return new Point( point.x+prevAnchorOffsetX*sx, point.y+prevAnchorOffsetY*sy );
		}
		
		/**
		 * retrun the successor Bezier point
		 */
		public function getSuccessorBezier( graphicElement : GraphicElement, sx:Number = 1, sy : Number = 1 ) : Point
		{
			if( hasVerticalConstraint() ) {
				sy = 1;
			}
			if( hasHorizontalConstraint() ) {
				sx = 1;
			}
			var point : Point = getConstraintPoint( graphicElement, sx, sy ); 
			return new Point( point.x+nextAnchorOffsetX*sx, point.y+nextAnchorOffsetY*sy );
		}
	}
}