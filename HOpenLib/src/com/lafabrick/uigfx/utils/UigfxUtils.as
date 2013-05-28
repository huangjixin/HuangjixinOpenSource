/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.utils
{
	import com.lafabrick.uigfx.geom.ComplexPoint;
	import com.lafabrick.uigfx.primitives.ComplexPath;
	
	import flash.display.Graphics;
	import flash.geom.Point;

	/**
	 * Utils for drawing primitives
	 * 
	 * <p>Original drawing method (drawRoundPath) by <b>Philippe Elsass</b></p>
	 * @author Philippe Elsass
	 * @see http://philippe.elsass.me
	 */
	public class UigfxUtils
	{
		/**
		 * Draw a path, using a Vector of Point
		 * 
		 * @author Philippe Elsass
		 * @see http://philippe.elsass.me/2009/05/as3-rounding-corners/
		 */
		static public function drawRoundPath(g:Graphics, points:Vector.<Point>, radius:Number = 20, closePath:Boolean = false):void
		{
			// code by Philippe / http://philippe.elsass.me
			
			var count:int = points.length;
			if (count < 2) return;
			if (closePath && count < 3) return;
			
			var point0:Point = points[0];
			var point1:Point = points[1];
			var point2:Point;
			
			var pp0:Point;
			var pp2:Point;
			
			var calcuatedRadius:Number;
			
			var last:Point;
			if (!closePath)
			{
				g.moveTo(point0.x, point0.y);
				last = points[count - 1];
			}
			
			var num:int = (closePath) ? count + 1 : count - 1;
			var iter:int = 1;
			for (; iter < num; iter++)
			{
				point2 = points[(iter + 1) % count];
				
				var vector0:Point = point0.subtract(point1);
				var vector2:Point = point2.subtract(point1);
				
				calcuatedRadius = Math.max(1, Math.min(radius, Math.min(vector0.length / 2, vector2.length / 2)));
				
				vector0.normalize(calcuatedRadius);
				vector2.normalize(calcuatedRadius);
				pp0 = point1.add(vector0);
				pp2 = point1.add(vector2);
				
				if (iter == 1 && closePath)
				{
					g.moveTo(pp0.x, pp0.y);
					last = pp0;
				}
				else g.lineTo(pp0.x, pp0.y);
				
				g.curveTo(point1.x, point1.y, pp2.x, pp2.y);
				point0 = point1;
				point1 = point2;
			}
			
			g.lineTo(last.x, last.y);
		}
		
		/**
		 * Draw a complex path, using a Vector of ComplexPoint
		 * @see com.lafabrick.uigfx.primitives.ComplexPath
		 * @see com.lafabrick.uigfx.geom.ComplexPoint
		 */
		// Tim Groleau's method : based on getQuadraticPoints on Path.as class in Fx4 SDK
		public static function drawComplexPath(graphicElement : ComplexPath, g:Graphics, points:Vector.<ComplexPoint>, closePath:Boolean = true, sx:Number=1, sy:Number=1) : void
		{
			var count:int = points.length;
			if (count < 2) return;
			
			var startPoint : Point;
			var point0 : Point;
			var control0 : Point;
			
			var point1 : Point;
			var control1 : Point;
			
			var pointA : Point;
			var pointB : Point;
			
			var offsetx : Number;
			var offsety : Number;
			
			var pc1 : Point;
			var pc2 : Point;
			var pc3 : Point;
			var pc4 : Point;
			
			var pa1 : Point;
			var pa2 : Point;
			var pa3 : Point;
			
			point0 = points[0].getConstraintPoint(graphicElement, sx, sy);
			startPoint = point0;
			g.moveTo(point0.x, point0.y);
			var iter:int = 0;
			for (; iter < count; iter++)
			{
				// PO, P3 : start , end
				// P1, P2 : controls points
				point0 = points[iter % count].getConstraintPoint(graphicElement, sx, sy);
				//control0 = new Point(point0.x+points[i % count].nextAnchorOffsetX, point0.y+points[i % count].nextAnchorOffsetY);
				control0 = points[iter % count].getSuccessorBezier(graphicElement, sx, sy);
					
				point1 = points[(iter+1) % count].getConstraintPoint(graphicElement, sx, sy);
				//control1 = new Point(point1.x+points[(i+1) % count].prevAnchorOffsetX, point1.y+points[(i+1) % count].prevAnchorOffsetY);
				control1 = points[(iter+1) % count].getPredecessorBezier(graphicElement, sx, sy);
				
				// calculates the useful base points
				pointA = Point.interpolate(control0, point0, 3/4);
				pointB = Point.interpolate(control1, point1, 3/4);
				
				// get 1/16 of the [point1, point0] segment
				offsetx = (point1.x - point0.x)/16;
				offsety = (point1.y - point0.y)/16;
				
				// calculates control point 1
				pc1 = Point.interpolate(control0, point0, 3/8);
				
				// calculates control point 2
				pc2 = Point.interpolate(pointB, pointA, 3/8);
				pc2.x -= offsetx;
				pc2.y -= offsety;
				
				// calculates control point 3
				pc3 = Point.interpolate(pointA, pointB, 3/8);
				pc3.x += offsetx;
				pc3.y += offsety;
				
				// calculates control point 4
				pc4 = Point.interpolate(control1, point1, 3/8);
				
				// calculates the 3 anchor points
				pa1 = Point.interpolate(pc1, pc2, 0.5);
				pa2 = Point.interpolate(pointA, pointB, 0.5);
				pa3 = Point.interpolate(pc3, pc4, 0.5);
				
				if( !(iter==count-1 && closePath == false) ) {
					
					// draw the four quadratic subsegments
					g.curveTo(pc1.x, pc1.y, pa1.x, pa1.y);
					g.curveTo(pc2.x, pc2.y, pa2.x, pa2.y);
					g.curveTo(pc3.x, pc3.y, pa3.x, pa3.y);
					g.curveTo(pc4.x, pc4.y, point1.x, point1.y);
				}
				
				if (iter == count-1 && closePath == true )
				{
					g.moveTo(startPoint.x, startPoint.y);
				}
			}

		}
	}
}