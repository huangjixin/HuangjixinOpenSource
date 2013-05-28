/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{
	import flash.display.Graphics;
	
	import spark.primitives.Graphic;
	import spark.primitives.supportClasses.FilledElement;

	/**
	 * Draw an Arc primitive
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * 
	 * @example 
	 * <p>The following code draws an Arc primitive</p>
	 * <listing version="3.0" >
	 * &lt;uigfx:Arc 
	 *     angle="60" startAngle="20" 
	 *     gap="5" width="300" height="120" 
	 *     horizontalCenter="0" verticalCenter="0"&gt;
	 *	
	 *     &lt;uigfx:stroke&gt;
	 *         &lt;s:SolidColorStroke color="#222222" /&gt;
	 *     &lt;/uigfx:stroke&gt;
	 *		
	 * &lt;/uigfx:Arc&gt;
	 * </listing>
	 * 
	 */
	public class Arc extends FilledElement
	{
		/**
		 * Constructor
		 */
		public function Arc()
		{
			super();
		}

		private var _startAngle : Number = 0;
		private var _angle : Number = 0;
		private var _gap : Number = 0;
		
		/**
		 * Defines the start angle (in degree) of the primitive
		 */
		public function get startAngle():Number
		{
			return _startAngle;
		}
		/**
		 * @private
		 */
		public function set startAngle(value:Number):void
		{
			_startAngle = value;
			invalidateDisplayList();
		}
		
		/**
		 * Defines the angle in degree of the primitive
		 */
		public function get angle():Number
		{
			return _angle;
		}
		/**
		 * @private
		 */
		public function set angle(value:Number):void
		{
			if( Math.abs( value ) > 360 ) value = 360;
			_angle = value;
			invalidateDisplayList();
		}
		
		/**
		 * Defines the gap of the Pie. Value is expressed as a degree angle
		 */
		public function get gap():Number
		{
			return _gap;
		}
		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			_gap = value;
			invalidateDisplayList();
		}
		
		/**
		 * Draw the primitive
		 */
		override protected function draw(g:Graphics) : void
		{

			var nangle : Number = Math.max( angle-gap, 0) / 180 * Math.PI;	
			var numSegments:Number = Math.ceil(Math.abs(nangle)/ (Math.PI/4) );
			var angleSegment:Number = nangle/numSegments;
			
			var theta:Number = -angleSegment;
			var radAngle : Number = -startAngle / 180 * Math.PI;
			
			if (numSegments > 0){
				drawArc( g, radAngle, theta, numSegments );
			}
		}
		
		protected function drawArc( g:Graphics, angle : Number, theta : Number, numSegments : Number) : void {
			
			var controlx:Number;
			var controly:Number;
			var posx:Number;
			var posy:Number;
			
			var midRadAngle : Number;
			
			var segCount : Number = 0;
			
			posx = drawX+width/2 + Math.cos(-angle) * (width/2);
			posy = drawY+height/2 + Math.sin(angle) * (height/2);
			
			g.moveTo(posx, posy);
			
			for (; segCount<numSegments; segCount++) {
				
				angle += theta;
				midRadAngle = angle - theta / 2;
				
				posx = drawX+width/2 + Math.cos(angle) * (width/2);
				posy = drawY+height/2 + Math.sin(angle) * (height/2);
				
				controlx = drawX+width/2 + Math.cos(midRadAngle) * ((width/2) / Math.cos(theta / 2));
				controly = drawY+height/2 + Math.sin(midRadAngle) * ((height/2) / Math.cos(theta / 2));
				
				g.curveTo(controlx, controly, posx, posy);
			}
		}
		
	}
}