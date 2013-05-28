/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	
	import org.bytearray.display.ScaleBitmap;
	
	import spark.primitives.supportClasses.GraphicElement;
	
	/**
	 * Draw a Bitmap, following a scaled 9-slice, defined by <code>scaleTop</code>, <code>scaleBottom</code>, <code>scaleLeft</code>, <code>scaleRight</code> properties.
	 * @see org.bytearray.display.ScaleBitmap
	 */
	public class ScaleBitmapImage extends GraphicElement
	{
		public function ScaleBitmapImage()
		{
			super();
		}
		
		private var _bitmapData:BitmapData;
		
		private var _source:Object;
		private var _smooth:Boolean = false;
		
		private var _scaleTop : Number = 0;
		private var _scaleBottom : Number = 0;
		private var _scaleLeft : Number = 0;
		private var _scaleRight : Number = 0;
		
		private var _outerTop : Number = 0;
		private var _outerLeft : Number = 0;
		
		/**
		 * @private
		 */
		public function get scaleTop():Number
		{
			return _scaleTop;
		}
		/**
		 * Specifies the distance in pixels from the <b>TOP</b> of the image in a 9-slice scaling formatting system. <br />The distance is relative to the original, unscaled size of the image.
		 */
		public function set scaleTop(value:Number):void
		{
			_scaleTop = value;
		}
		/**
		 * @private
		 */
		public function get scaleBottom():Number
		{
			return _scaleBottom;
		}
		
		/**
		 * Specifies the distance in pixels from the <b>BOTTOM</b> of the image in a 9-slice scaling formatting system. The distance is relative to the original, unscaled size of the image.
		 */
		public function set scaleBottom(value:Number):void
		{
			_scaleBottom = value;
		}
		/**
		 * @private
		 */
		public function get scaleLeft():Number
		{
			return _scaleLeft;
		}
		/**
		 * Specifies the distance in pixels from the <b>LEFT</b> of the image in a 9-slice scaling formatting system. The distance is relative to the original, unscaled size of the image.
		 */
		public function set scaleLeft(value:Number):void
		{
			_scaleLeft = value;
		}
		/**
		 * @private
		 */
		public function get scaleRight():Number
		{
			return _scaleRight;
		}
		/**
		 * Specifies the distance in pixels from the <b>RIGHT</b> of the image in a 9-slice scaling formatting system. The distance is relative to the original, unscaled size of the image.
		 */
		public function set scaleRight(value:Number):void
		{
			_scaleRight = value;
		}
		/**
		 * @private
		 */
		public function get outerTop():Number
		{
			return _outerTop;
		}
		/**
		 * 
		 */
		public function set outerTop(value:Number):void
		{
			_outerTop = value;
		}
		/**
		 * @private
		 */
		public function get outerLeft():Number
		{
			return _outerLeft;
		}
		/**
		 * 
		 */
		public function set outerLeft(value:Number):void
		{
			_outerLeft = value;
		}
		
		/**
		 *  The source used for the bitmap fill. The fill can render from various graphical 
		 *  sources, including the following: 
		 *  <ul>
		 *   <li>A Bitmap or BitmapData instance.</li>
		 *   <li>A class representing a subclass of DisplayObject. The BitmapFill instantiates 
		 *       the class and creates a bitmap rendering of it.</li>
		 *   <li>An instance of a DisplayObject. The BitmapFill copies it into a Bitmap for filling.</li>
		 *  </ul>
		 *  
		 *  <p>If you use an image file for the source, it can be of type PNG, GIF, or JPG.</p>
		 *  
		 *  <p>To specify an image as a source, you must use the &#64;Embed directive, as the following example shows:
		 *  <pre>
		 *  source="&#64;Embed('<i>image_location</i>')"
		 *  </pre>
		 *  </p>
		 *  
		 *  <p>The image location can be a URL or file reference. If it is a file reference, its location is relative to
		 *  the location of the file that is being compiled.</p>
		 */
		public function set source(value:Object):void
		{ 
			if (value != _source) {
				_source = value;
				
				var tmpSprite:DisplayObject;
				
				if (value is Class) {
					var cls:Class = Class(value);
					value = new cls();
				}
				
				if (value is BitmapData) {
					_bitmapData = value as BitmapData;
				}
				else if (value is Bitmap) {
					_bitmapData = value.bitmapData;
				}
				else if (value is DisplayObject) {
					tmpSprite = value as DisplayObject;
				}
				else if (value == null) {
					// This will set source to null
				}   
				else {
					return;
				}
				
				if (!_bitmapData && tmpSprite) {
					_bitmapData = new BitmapData(tmpSprite.width, tmpSprite.height, true, 0);
					_bitmapData.draw(tmpSprite, new Matrix());
				}  
				
				invalidateDisplayList();

			}
		}
		/**
		 * @private
		 */
		public function get source():Object 
		{
			return _source;
		}
		
		[Inspectable(category="General", enumeration="true,false")]   
		
		/**
		 * If <code>false</code>, upscaled bitmap images are rendered by using a nearest-neighbor 
		 * algorithm and look pixelated. If <code>true</code>, upscaled bitmap images are rendered by using a 
		 * bilinear algorithm. Rendering by using the nearest neighbor algorithm is usually faster.
		 */
		public function set smooth(value:Boolean):void
		{
			if (value != _smooth) {
				_smooth = value;
				invalidateDisplayList();
			}
		}
		
		/**
		 *  @private
		 */
		public function get smooth():Boolean
		{
			return _smooth;
		} 
		/**
		 * @private
		 */
		protected function getInnerRect() : Rectangle
		{
			return new Rectangle( 	scaleLeft, scaleTop, 
				_bitmapData.width-scaleLeft-scaleRight, 
				_bitmapData.height-scaleTop-scaleBottom ); 
									
		}
		/**
		 * @private
		 */
		protected function getOuterRect() : Rectangle
		{
			return new Rectangle( -outerLeft-drawX, -outerTop-drawY, 0, 0 );
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var graphics:Graphics = Sprite(drawnDisplayObject).graphics;
			graphics.clear();
			if (!_bitmapData || !drawnDisplayObject || !(drawnDisplayObject is Sprite))
				return;
			
			ScaleBitmap.draw( _bitmapData, graphics, unscaledWidth, unscaledHeight, getInnerRect(), getOuterRect(), smooth );
		}
	}
}