/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.element
{
	import com.lafabrick.uigfx.geom.ComplexPoint;
	
	/**
	 * Define a part's path of a complex primitives
	 */
	public class Contour
	{
		public function Contour()
		{
		}
		
		private var _closedContour : Boolean = true;

		/**
		 * Define if this contour is closed or not
		 */
		public function get closedContour():Boolean
		{
			return _closedContour;
		}
		/**
		 * @private
		 */
		public function set closedContour(value:Boolean):void
		{
			_closedContour = value;
		}


		private var _points : Vector.<ComplexPoint>;

		/**
		 * The collection (Vector) of all points
		 * @see com.lafabrick.uigfx.geom.ComplexPoint
		 */
		public function get points():Vector.<ComplexPoint>
		{
			return _points;
		}

		/**
		 * @private
		 */
		public function set points(value:Vector.<ComplexPoint>):void
		{
			_points = value;
		}

	}
}