/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{
	import com.lafabrick.uigfx.geom.ConstraintPoint;
	import com.lafabrick.uigfx.utils.UigfxUtils;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.MatrixUtil;
	
	/**
	 * Draw a form, using a vector of points
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @see com.lafabrick.uigfx.geom.ConstraintPoint
	 * 
	 * @example 
	 * <p>The following code draws a star with five branch, using points with static positions</p>
	 * <listing version="3.0" >
	 * &lt;uigfx:PointsPath 
	 *     radius="60" width="100%" height="100%" 
	 *     horizontalCenter="0" verticalCenter="0"&gt;
	 *		
	 *     &lt;uigfx:points&gt;
	 *         &lt;uigfx:ConstraintPoint x="100" y="0" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="125" y="75" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="200" y="75" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="140" y="125" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="160" y="200" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="100" y="155" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="40" y="200" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="60" y="125" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="0" y="75" /&gt;
	 *         &lt;uigfx:ConstraintPoint x="75" y="75" /&gt;
	 *     &lt;/uigfx:points&gt;
	 *	
	 *     &lt;uigfx:fill&gt;
	 *         &lt;s:SolidColor color="#222222" /&gt;
	 *     &lt;/uigfx:fill&gt;
	 * 
	 *     &lt;uigfx:filters&gt;
	 *         &lt;s:DropShadowFilter color="#000000" inner="true" distance="1" blurX="4" blurY="4" quality="3" alpha="0.8" /&gt;
	 *     &lt;/uigfx:filters&gt;
	 *		
	 * &lt;/uigfx:PointsPath&gt;
	 * </listing>
	 * <p>The following code draws a star with five branch, using points with constraints placement</p>
	 * <listing version="3.0" >
	 * &lt;uigfx:PointsPath 
	 *     radius="60" width="100%" height="100%" 
	 *     horizontalCenter="0" verticalCenter="0"&gt;
	 * 
	 *     &lt;uigfx:points&gt;
	 *         &lt;uigfx:ConstraintPoint top="0" horizontalCenter="0" /&gt;
	 *         &lt;uigfx:ConstraintPoint horizontalCenter="25" verticalCenter="-25"/&gt;
	 *         &lt;uigfx:ConstraintPoint right="0" verticalCenter="-25" /&gt;
	 *         &lt;uigfx:ConstraintPoint horizontalCenter="40" verticalCenter="25" /&gt;
	 *         &lt;uigfx:ConstraintPoint right="40" bottom="0" /&gt;
	 *         &lt;uigfx:ConstraintPoint horizontalCenter="0" verticalCenter="40" /&gt;
	 *         &lt;uigfx:ConstraintPoint left="40" bottom="0" /&gt;
	 *         &lt;uigfx:ConstraintPoint horizontalCenter="-40" verticalCenter="25" /&gt;
	 *         &lt;uigfx:ConstraintPoint left="0" verticalCenter="-25" /&gt;
	 *         &lt;uigfx:ConstraintPoint horizontalCenter="-25" verticalCenter="-25" /&gt;
	 *     &lt;/uigfx:points&gt;
	 * 
	 *     &lt;uigfx:fill&gt;
	 *         &lt;s:SolidColor color="#222222" /&gt;
	 *     &lt;/uigfx:fill&gt;
	 * 
	 *     &lt;uigfx:filters&gt;
	 *         &lt;s:DropShadowFilter color="#000000" inner="true" distance="1" blurX="4" blurY="4" quality="3" alpha="0.8" /&gt;
	 *     &lt;/uigfx:filters&gt;
	 * 
	 * &lt;/uigfx:PointsPath&gt;
	 * </listing>
	 * 
	 */
	public class PointsPath extends UigfxPath
	{
		/**
		 * Constructor
		 */
		public function PointsPath()
		{
			super();
		}
		/**
		 * @private
		 */
		private var _points : Vector.<ConstraintPoint>;
		/**
		 * @private
		 */
		private var _radius : Number = 0;
		
		/**
		 * the rounded corner of the path
		 */
		public function get radius():Number
		{
			return _radius;
		}

		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			_radius = value;
			invalidateDisplayList();
		}

		/**
		 * define the crossing points of the form. It's a vector of constraint point Vector.&lt;ConstraintPoint&gt;
		 * @see com.lafabrick.uigfx.geom.ConstraintPoint
		 */
		public function get points():Vector.<ConstraintPoint>
		{
			return _points;
		}
		
		/**
		 * @private
		 */
		public function set points(value:Vector.<ConstraintPoint>):void
		{
			_points = value;
			invalidateDisplayList();
			
		}
		
		/**
		 * Draw the path
		 * <p>Drawing method is static, in UigfxUtils</p>
		 * @see com.lafabrick.uigfx.utils.UigfxUtils
		 */
		override protected function draw(g:Graphics) : void
		{
			var point : ConstraintPoint;
			var allPoints : Array = new Array();
			for each(point in points ) {
				allPoints.push( point );
			}
			
			var rcBounds:Rectangle = getBoundingBox(allPoints);
			var sx:Number = width == 0 ? 1 : width / rcBounds.width;
			var sy:Number = height == 0 ? 1 : height / rcBounds.height;
			
			// replace points from local to global position
			var vectorPoint : Vector.<Point> = new Vector.<Point>();
			for each( point in points ) {
				
				var cspoint : Point = point.getConstraintPoint( this, sx, sy );
				vectorPoint.push( cspoint );
				
				//vectorPoint.push( point.getConstraintPoint( this ) );
			}
			// launch drawing method
			UigfxUtils.drawRoundPath( g, vectorPoint, radius, closedPath );
		}
	}
}