/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.effects.animation
{
	import com.lafabrick.uigfx.geom.ComplexPoint;
	
	import spark.effects.animation.MotionPath;
	
	public class ComplexMotionPath extends MotionPath
	{
		public function ComplexMotionPath(property:String=null, point : ComplexPoint=null, indexContour : Number = NaN, indexPoint : Number = NaN)
		{
			targetPoint = point;
			contourIndex = indexContour;
			pointIndex = indexPoint
				
			super(property);
		}
		
		private var _targetPoint : Object;
		
		public function get targetPoint():Object
		{
			return _targetPoint;
		}
		
		public function set targetPoint(value:Object):void
		{
			_targetPoint = value;
		}
		
		
		private var _contourIndex : Number;
		
		private var _pointIndex : Number;

		public function get contourIndex():Number
		{
			return _contourIndex;
		}

		public function set contourIndex(value:Number):void
		{
			_contourIndex = value;
		}

		public function get pointIndex():Number
		{
			return _pointIndex;
		}

		public function set pointIndex(value:Number):void
		{
			_pointIndex = value;
		}

	}
}