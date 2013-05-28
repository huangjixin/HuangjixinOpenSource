/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{
	import com.lafabrick.uigfx.element.Contour;
	import com.lafabrick.uigfx.geom.ComplexPoint;
	import com.lafabrick.uigfx.utils.DataParser;
	import com.lafabrick.uigfx.utils.UigfxUtils;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	/**
	 * Draw a form, using a vector of points, and quadratic bezier curve
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @see com.lafabrick.uigfx.geom.ComplexPoint
	 * 
	 * @example 
	 * <p>The following code draws a path with multiple contours</p>
	 * <listing version="3.0">
	 * &lt;uigfx:ComplexPath top="0" bottom="0" left="0" right="0" &gt;
     *     &lt;uigfx:contours&gt;
     *         &lt;uigfx:Contour&gt;
     *             &lt;uigfx:points&gt;
     *                 &lt;uigfx:ComplexPoint left="0" prevAnchorOffsetX="4.59" top="36" prevAnchorOffsetY="5.36" /&gt;
     *                 &lt;uigfx:ComplexPoint left="0" bottom="0" /&gt;
     *                 &lt;uigfx:ComplexPoint horizontalCenter="-35" bottom="0" /&gt;
     *                 &lt;uigfx:ComplexPoint horizontalCenter="-23" bottom="18" /&gt;
     *                 &lt;uigfx:ComplexPoint horizontalCenter="3" bottom="2" /&gt;
     *                 &lt;uigfx:ComplexPoint horizontalCenter="2" bottom="0" /&gt;
     *                 &lt;uigfx:ComplexPoint right="0" bottom="0" /&gt;
     *                 &lt;uigfx:ComplexPoint right="0" top="0" /&gt;
     *                 &lt;uigfx:ComplexPoint left="34" nextAnchorOffsetX="6.07" top="0" nextAnchorOffsetY="4.56" /&gt;
     *                 &lt;uigfx:ComplexPoint left="44" top="20" nextAnchorOffsetY="13.81" prevAnchorOffsetY="-8.18" /&gt;
     *                 &lt;uigfx:ComplexPoint left="19" nextAnchorOffsetX="-7.6" prevAnchorOffsetX="13.81" top="45" /&gt;
     *             &lt;/uigfx:points&gt;
     *         &lt;/uigfx:Contour&gt;
     *         &lt;uigfx:Contour&gt;
     *             &lt;uigfx:points&gt;
     *                 &lt;uigfx:ComplexPoint right="96" top="18" /&gt;
     *                 &lt;uigfx:ComplexPoint right="68" top="9" /&gt;
     *                 &lt;uigfx:ComplexPoint right="59" top="37" /&gt;
     *                 &lt;uigfx:ComplexPoint right="87" top="46" /&gt;
     *             &lt;/uigfx:points&gt;
     *         &lt;/uigfx:Contour&gt;
     *         &lt;uigfx:Contour&gt;
     *             &lt;uigfx:points&gt;
     *                 &lt;uigfx:ComplexPoint right="49" bottom="28" nextAnchorOffsetY="-11.87" prevAnchorOffsetY="11.87" /&gt;
     *                 &lt;uigfx:ComplexPoint right="28" nextAnchorOffsetX="11.87" prevAnchorOffsetX="-11.87" bottom="49" /&gt;
     *                 &lt;uigfx:ComplexPoint right="6" bottom="28" nextAnchorOffsetY="11.87" prevAnchorOffsetY="-11.87" /&gt;
     *                 &lt;uigfx:ComplexPoint right="28" nextAnchorOffsetX="-11.87" prevAnchorOffsetX="11.87" bottom="6" /&gt;
     *             &lt;/uigfx:points&gt;
     *         &lt;/uigfx:Contour&gt;
   	 *     &lt;/uigfx:contours&gt;
	 * 
     *     &lt;uigfx:stroke&gt;
     *         &lt;s:SolidColorStroke color="#ffffff" weight="2" /&gt;
     *     &lt;/uigfx:stroke&gt;
     * 
     *     &lt;uigfx:fill&gt;
     *         &lt;s:LinearGradient rotation="90"&gt;
     *             &lt;s:GradientEntry color="#333333" ratio="0" alpha="1"/&gt;
     *             &lt;s:GradientEntry color="#212121" ratio="1" alpha="1"/&gt;
     *         &lt;/s:LinearGradient&gt;
     *     &lt;/uigfx:fill&gt;
	 * 
     *     &lt;uigfx:filters&gt;
     *         &lt;s:GlowFilter color="#000000" blurX="12" blurY="12" alpha="0.65"/&gt;
	 *     &lt;/uigfx:filters&gt;
	 * &lt;/uigfx:ComplexPath&gt;
	 * </listing>
	 * <p>primitive using compact data representation : </p>
	 * <listing version="3.0">
	 * &lt;uigfx:ComplexPath top="0" bottom="0" left="0" right="0" 
	 *     data=" C D L 0 T 0 D L 0 B 0 D R 56 B 0 D R 77 B 32 D R 12 B 74 D R 0 B 56 D R 0 T 0 
	 * C D L 11 T 41 S 0 -15.74 P 0 15.74 D L 40 T 12 S 15.74 0 P -15.74 0 D L 68 T 41 S 0 15.74 P 0 -15.74 D L 40 T 69 S -15.74 0 P 15.74 0"&gt;
	 * 
     *     &lt;uigfx:stroke&gt;
     *         &lt;s:SolidColorStroke color="#ffffff" weight="2" /&gt;
     *     &lt;/uigfx:stroke&gt;
     * 
     *     &lt;uigfx:fill&gt;
     *         &lt;s:LinearGradient rotation="90"&gt;
     *             &lt;s:GradientEntry color="#333333" ratio="0" alpha="1"/&gt;
     *             &lt;s:GradientEntry color="#212121" ratio="1" alpha="1"/&gt;
     *         &lt;/s:LinearGradient&gt;
     *     &lt;/uigfx:fill&gt;
	 * 
     *     &lt;uigfx:filters&gt;
     *         &lt;s:GlowFilter color="#000000" blurX="12" blurY="12" alpha="0.65"/&gt;
	 *     &lt;/uigfx:filters&gt;
	 * &lt;/uigfx:ComplexPath&gt;
	 * </listing>
	 */
	public class ComplexPath extends UigfxPath
	{
		/**
		 * Constructor
		 */
		public function ComplexPath()
		{
			super();
		}
		
		private var _contours : Vector.<Contour>;
		
		private var _data : String;

		/**
		 * Compact representation of path
		 * 
		 * <p>Syntax for the compact representation :</p>
		 * <p><b>C</b> : Define a Contour. A path can have one or more C command. The compact representation need to start with this code.</p>
		 * <p>C command is followed by :</p>
		 * <ul>
		 * <li><b>O</b> [optionaly] : define if the contour is open. If you don't insert an "0", the Contour object is automatically closed.</li>
		 * <li><b>D</b> [one or more] : define the beginning of a point's declaration.
		 * <p>Its followed by :
		 * <ul>
		 *  <li>
		 * horizontal constraints :
		 *   <ul>
		 *    <li><b>X</b> : position on x axe</li>
		 *   </ul>
		 * OR
		 *   <ul>
		 *    <li><b>L</b> : follow by a number, define the position of point at left</li>
		 *    <li><b>H</b> : follow by a number, define the position of point at horizontalCenter</li>
		 *    <li><b>R</b> : follow by a number, define the position of point at right</li>
		 *   </ul>
		 *  </li>
		 *  <li>
		 * vertical constraints :
		 *   <ul>
		 *    <li><b>Y</b> : position on y axe</li>
		 *   </ul>
		 * OR
		 *   <ul>
		 *    <li><b>T</b> : follow by a number, define the position of point at top</li>
		 *    <li><b>V</b> : follow by a number, define the position of point at verticalCenter</li>
		 *    <li><b>B</b> : follow by a number, define the position of point at bottom</li>
		 *   </ul>
		 *  </li>
		 *  <li><b>P</b> : predecessor bezier with one or two numbers for x and y offset position</li>
		 *  <li><b>S</b> : successor bezier with one or two numbers for x and y offset position</li>
		 * </ul>
		 * </p>
		 * </li>
		 * </ul>
		 */
		public function get data():String
		{
			return DataParser.obtainComplexData( contours );
		}
		/**
		 * @private
		 */
		public function set data(value:String):void
		{
			_data = value;
			contours = DataParser.parseComplexData( _data );
		}

		/**
		 * collection of all contours of the form
		 * <p>This property has priority over the collection "points" : if it's not null, the points collection is ignored.</p>
		 */
		public function get contours():Vector.<Contour>
		{
			return _contours;
		}
		/**
		 * @private
		 */
		public function set contours(value:Vector.<Contour>):void
		{
			_contours = value;
			invalidateDisplayList();
		}

		
		/**
		 * @private
		 */
		private var _points : Vector.<ComplexPoint>;
		
		/**
		 * define the crossing points of the form. It's a vector of constraint point Vector.&lt;ComplexPoint&gt;
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
			invalidateDisplayList();
			
		}
		
		override protected function getBoundingBox(vectorPoints:Array):Rectangle
		{
			
			return super.getBoundingBox( vectorPoints );
		}
		
		
		/**
		 * Draw the path
		 * <p>Drawing method is static, in UigfxUtils</p>
		 * @see com.lafabrick.uigfx.utils.UigfxUtils
		 */
		override protected function draw(g:Graphics) : void
		{
			var contour : Contour;
			var point : ComplexPoint;
			
			var rcBounds:Rectangle;
			var allPoints : Array = new Array();
			
			if( contours && contours.length > 0 ) {
				for each(contour in contours) {
					for each(point in contour.points ) {
						allPoints.push( point );
					}
				}
			}
			else {
				for each(point in points ) {
					allPoints.push( point );
				}
			}
			rcBounds = getBoundingBox( allPoints );
			
			if( rcBounds ) {
				var sx:Number = width == 0 ? 1 : width / rcBounds.width;
				var sy:Number = height == 0 ? 1 : height / rcBounds.height;
			}
			
			if( contours && contours.length > 0 ) {
				for each(contour in contours) {
					UigfxUtils.drawComplexPath(this, g, contour.points, contour.closedContour, sx, sy );
				}
			}
			else if( points ) {
				UigfxUtils.drawComplexPath(this, g, points, closedPath, sx, sy );
			}
		}
	}
}