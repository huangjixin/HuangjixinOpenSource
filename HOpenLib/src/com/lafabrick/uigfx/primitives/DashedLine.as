/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{
	import flash.display.Graphics;
	
	import spark.primitives.Line;
	/**
	 * Draw an dashed line primitive
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @mxml
	 * <p>
	 * <pre>
	 * &lt;uigfx:DashedLine 
	 *     dashes="[dash structure]" 
	 *     left="10" right="10" 
	 *     verticalCenter="0"&gt;
	 *     ...
	 * </pre>
	 * </p>
	 * @example 
	 * <p>The following code draws a dashed line primitive, with [20, 5, 30, 10] for dash definition</p>
	 * <listing version="3.0" >
	 * &lt;uigfx:DashedLine 
	 *     dashes="[20, 5, 30, 10]" 
	 *     left="10" right="10" 
	 *     verticalCenter="0"&gt;
	 *	
	 *     &lt;uigfx:stroke&gt;
	 *         &lt;s:SolidColorStroke color="#222222" /&gt;
	 *     &lt;/uigfx:stroke&gt;
	 *		
	 * &lt;/uigfx:DashedLine&gt;
	 * </listing>
	 * 
	 */
	public class DashedLine extends Line
	{
		/**
		 * Constructor
		 */
		public function DashedLine()
		{
			super();
		}
		/**
		 * defines the dashes construction
		 * The odd locations of the table defines the length of dashes.
		 * The pair locations of the table defines the length of spaces.
		 * By default [10, 10]
		 */
		private var _dashes : Array = [10, 10];

		public function get dashes():Array
		{
			return _dashes;
		}
		/**
		 * @private
		 */
		public function set dashes(value:Array):void
		{
			_dashes = value;
			invalidateSize();
			invalidateDisplayList();
		}

		/**
		 * Draw the primitive
		 */
		override protected function draw(g:Graphics):void
		{
			if( dashes && dashes.length>0 ) {
				
				var x1:Number = measuredX + drawX;
				var y1:Number = measuredY + drawY;
				var x2:Number = measuredX + drawX + width;
				var y2:Number = measuredY + drawY + height;    
				
				var angle : Number = Math.atan( (x2-x1) / (y2-y1) );
				var distance : Number = Math.sqrt( Math.pow( x2-x1, 2) + Math.pow(y2-y1, 2) );
				
				var dashsCounter : Number = 0;
				var sectionLength : Number = 0;
				
				for(; dashsCounter<dashes.length; dashsCounter++) {
					sectionLength += dashes[dashsCounter];
				}
				
				var numPasse : Number = Math.abs(distance/(sectionLength));
				
				var startX : Number = 0;
				var startY : Number = 0;
				
				if ((xFrom <= xTo) == (yFrom <= yTo)) { 
					startX = x1,
					startY = y1;
				}
				else {
					startX = x1,
					startY = y2;
				}
				
				var currentX : Number = startX;
				var currentY : Number = startY;
				
				g.moveTo( currentX, currentY );
				
				var currentDistance : Number = 0;
				var counter : Number = 0;
				
				dashsCounter = 0;
				
				for(; counter<numPasse; counter++) {
					for(; dashsCounter<dashes.length; dashsCounter++) {
						
						currentX+= Math.abs(dashes[dashsCounter]*Math.sin(angle));
						currentY+= Math.abs(dashes[dashsCounter]*Math.cos(angle));
						
						currentDistance = Math.sqrt( Math.pow(currentX-startX, 2) + Math.pow(currentY-startY, 2) );
						
						if( currentDistance > distance ) {
							
							if ((xFrom <= xTo) == (yFrom <= yTo)) { 
								currentX = x2,
								currentY = y2;
							}
							else {
								currentX = x2,
								currentY = y1;
							}
						}
						
						if( dashsCounter%2 == 0 ) {
							g.lineTo( currentX, currentY );
						}
						else {
							g.moveTo( currentX, currentY );
						}
						
					}
					dashsCounter = 0;
				}
			}
		}
	}
}