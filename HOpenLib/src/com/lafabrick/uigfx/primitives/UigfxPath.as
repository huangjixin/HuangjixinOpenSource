/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.MatrixUtil;
	
	import spark.primitives.supportClasses.FilledElement;
	
	[ExcludeClass]
	/**
	 * Base for all uigfx path primitives
	 */
	public class UigfxPath extends FilledElement
	{
		/**
		 * Constructor
		 */
		public function UigfxPath()
		{
			super();
		}
		/**
		 * @private
		 */
		private var _closedPath : Boolean = true;
		/**
		 * Define if the primitive has a closed path
		 */
		public function get closedPath():Boolean
		{
			return _closedPath;
		}
		
		/**
		 * @private
		 */
		public function set closedPath(value:Boolean):void
		{
			_closedPath = value;
		}

		protected function getBoundingBox(vectorPoints:Array):Rectangle
		{
			var prevPoint:Point;
			var boundBox:Rectangle;
			var constraintPoint : Point;
			var prevConstraintPoint : Point = new Point();

			for (var i:int = 0; i < vectorPoints.length; i++)
			{
				constraintPoint = vectorPoints[i].getConstraintPoint( this );
				
				if( prevPoint) {
					prevConstraintPoint.x = prevPoint.x;
					prevConstraintPoint.y = prevPoint.y;
				}
				//constraintPoint2 = prevPoint ? npoint.new Point(prevPoint.x, prevPoint.y ) : new Point(0, 0);
				
				boundBox = MatrixUtil.rectUnion(Math.min(constraintPoint.x, prevConstraintPoint.x), Math.min(constraintPoint.y, prevConstraintPoint.y), 
					Math.max(constraintPoint.x, prevConstraintPoint.x), Math.max(constraintPoint.y, prevConstraintPoint.y), boundBox);
				
				prevPoint = constraintPoint;
			}
			
			return boundBox;
		}
		
	}
}