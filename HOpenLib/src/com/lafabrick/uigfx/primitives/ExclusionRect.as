/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{
	import com.lafabrick.uigfx.utils.UigfxUtils;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import spark.primitives.supportClasses.FilledElement;
	
	/**
	 * Draw a rectangle with a rectangle inside excluded
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 * 
	 * @example 
	 * <p>The following code draws a rectangle, with a radius of 20; and an inner excluded rectangle, with a innerRadius of 20, and some specific constraints</p>
	 * <listing version="3.0" >
	 * &lt;uigfx:ExclusionRect 
	 *     radius="20"
	 *     innerRadius="20" 
	 *     top="0" left="0" right="0" bottom="0" 
	 *     innerTop="20" innerBottom="20" innerLeft="20" innerRight="20"&gt;
	 * 
	 *     &lt;uigfx:fill&gt;
	 *         &lt;s:LinearGradient rotation="90"&gt;
	 *             &lt;s:GradientEntry color="#212121" ratio="0" /&gt;
	 *             &lt;s:GradientEntry color="#313131" ratio="1"/&gt;
	 *         &lt;/s:LinearGradient&gt;
	 *     &lt;/uigfx:fill&gt;
	 * 
	 *     &lt;uigfx:filters&gt;
	 *         &lt;s:DropShadowFilter color="#000000" inner="true" distance="1" blurX="4" blurY="4" quality="3" alpha="0.8" /&gt;
	 *     &lt;/uigfx:filters&gt;
	 * 
	 * &lt;/uigfx:ExclusionRect&gt;
	 * </listing>
	 * <p>You can play with inner constraints and inner radius, for different type of form :</p>
	 * <listing version="3.0" >
	 * &lt;uigfx:ExclusionRect 
	 *     radius="10"
	 *     innerRadius="30" 
	 *     top="0" left="0" right="0" bottom="0" 
	 *     innerTop="0" innerBottom="20" innerLeft="0" innerRight="20"&gt;
	 * 
	 *     &lt;uigfx:fill&gt;
	 *         &lt;s:LinearGradient rotation="90"&gt;
	 *             &lt;s:GradientEntry color="#212121" ratio="0" /&gt;
	 *             &lt;s:GradientEntry color="#313131" ratio="1"/&gt;
	 *         &lt;/s:LinearGradient&gt;
	 *     &lt;/uigfx:fill&gt;
	 * 
	 *     &lt;uigfx:filters&gt;
	 *         &lt;s:DropShadowFilter color="#000000" inner="true" distance="1" blurX="4" blurY="4" quality="3" alpha="0.8" /&gt;
	 *     &lt;/uigfx:filters&gt;
	 * 
	 * &lt;/uigfx:ExclusionRect&gt;
	 * </listing>
	 * 
	 */
	public class ExclusionRect extends FilledElement
	{
		/**
		 * Constructor
		 */
		public function ExclusionRect()
		{
			super();
		}
		
		/**
		 * @private
		 */
		private var _radius : Number = 0;
		
		/**
		 * @private
		 */
		private var _innerRadius : Number = 0;
		
		/**
		 * @private
		 */
		private var _enableExclusion : Boolean = true;
		
		/**
		 * @private
		 */
		private var _innerTop : Number = 0;
		
		/**
		 * @private
		 */
		private var _innerBottom : Number = 0;
		
		/**
		 * @private
		 */
		private var _innerLeft : Number = 0;
		
		/**
		 * @private
		 */
		private var _innerRight : Number = 0;
		
		/**
		 * @private
		 */
		public function get enableExclusion():Boolean
		{
			return _enableExclusion;
		}
		
		/**
		 * Defines if the inner rectangle exclusion in enabled (true) or not
		 * <p>default is "true"</p>
		 */
		public function set enableExclusion(value:Boolean):void
		{
			_enableExclusion = value;
			invalidateDisplayList();
		}
		/**
		 * the rounded corner of the rectangle
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
			if( value != _radius ) {
				_radius = value;
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
	
		/**
		 * the rounded corner of the INNER rectangle
		 */
		public function get innerRadius():Number
		{
			return _innerRadius;
		}
		/**
		 * @private
		 */
		public function set innerRadius(value:Number):void
		{
			if( value != _innerRadius ) {
				_innerRadius = value;
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * Top constraint value for the inner rectangle
		 */
		public function get innerTop():Number
		{
			return _innerTop;
		}
		/**
		 * @private
		 */
		public function set innerTop(value:Number):void
		{
			if( value != _innerTop ) {
				_innerTop = value;
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * Bottom constraint value for the inner rectangle
		 */
		public function get innerBottom():Number
		{
			return _innerBottom;
		}
		/**
		 * @private
		 */
		public function set innerBottom(value:Number):void
		{
			if( value != _innerBottom ) {
				_innerBottom = value;
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * Left constraint value for the inner rectangle
		 */
		public function get innerLeft():Number
		{
			return _innerLeft;
		}
		/**
		 * @private
		 */
		public function set innerLeft(value:Number):void
		{
			if( value != _innerLeft ) {
				_innerLeft = value;
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * Right constraint value for the inner rectangle
		 */
		public function get innerRight():Number
		{
			return _innerRight;
		}
		/**
		 * @private
		 */
		public function set innerRight(value:Number):void
		{
			if( value != _innerRight ) {
				_innerRight = value;
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}	
		
		/**
		 * Return the Vector of Point for the rectangle
		 */
		protected function getOutterVectorPoint() : Vector.<Point>
		{
			var vector : Vector.<Point> = new Vector.<Point>();
			vector.push( new Point( drawX, drawY ) );
			vector.push( new Point( drawX+width, drawY ) );
			vector.push( new Point( drawX+width, drawY+height ) );
			vector.push( new Point( drawX, drawY+height ) );
			return vector;
		}
		/**
		 * Return the Vector of Point for the inner rectangle
		 */
		protected function getInnerVectorPoint() : Vector.<Point>
		{
			var vector : Vector.<Point> = new Vector.<Point>();
			vector.push( new Point( drawX+innerLeft, drawY+innerTop ) );
			vector.push( new Point( drawX+width-innerRight, drawY+innerTop ) );
			vector.push( new Point( drawX+width-innerRight, drawY+height-innerBottom) );
			vector.push( new Point( drawX+innerLeft, drawY+height-innerBottom ) );
			return vector;			
		}
		
		/**
		 * Draw the rectangle
		 * @see com.lafabrick.uigfx.utils.UigfxUtils
		 */
		override protected function draw(g:Graphics) : void
		{	
			UigfxUtils.drawRoundPath( g, getOutterVectorPoint(), radius, true );
			
			if( enableExclusion ) {
				UigfxUtils.drawRoundPath( g, getInnerVectorPoint(), innerRadius, true );
			}
		}
	}
}