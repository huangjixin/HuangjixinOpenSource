/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.primitives
{

import flash.display.Graphics;

import spark.primitives.supportClasses.FilledElement;

/**
 * Draw an dashed Rect primitive
 * <p>DashedRect primitive by Volodymyr Styranivskyy - http://vstyran-flex.blogspot.com/</p>
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
 * <p>The following code draws a dashed Rect primitive, with 3 pixels dash size</p>
 * <listing version="3.0" >
 * &lt;uigfx:DashedRect
 *     dasheSize="3"
 *     left="10" right="10"
 *     verticalCenter="0"&gt;
 *
 *     &lt;uigfx:stroke&gt;
 *         &lt;s:SolidColorStroke color="#222222" /&gt;
 *     &lt;/uigfx:stroke&gt;
 *
 * &lt;/uigfx:DashedRect&gt;
 * </listing>
 *
 */
public class DashedRect extends FilledElement
    {
        public function DashedRect()
        {
            super();
        }

        private var _dashSize:Number=4;

        [Inspectable("General", minValue="1.0")]

        /**
         *  Define the dash size
         *  @default 4
         */
        public function get dashSize():Number
        {
            return _dashSize;
        }

        /**
         * @private
         */
        public function set dashSize(value:Number):void
        {
            if (value != _dashSize)
            {
                _dashSize = value > 0 ? value : 1;

                invalidateSize();
                invalidateDisplayList();
                invalidateParentSizeAndDisplayList();
            }
        }
        /**
         * Draw the primitive
         */
        override protected function draw(g:Graphics):void
        {
            drawVerticalLine(0, g);
            drawVerticalLine(width, g);
            drawHorizontalLine(0, g);
            drawHorizontalLine(height, g);
        }
        /**
         * Draw vertical dash line
         */
        private function  drawVerticalLine(x:Number, g:Graphics):void
        {
            var count:Number = Math.floor(height/_dashSize);

            for (var i:int = 0; i <= count; i+=2)
            {
                g.moveTo(x, i*_dashSize);
                g.lineTo(x, (i+1)*dashSize);
            }
        }
        /**
         * Draw horizontal dash line
         */
        private function  drawHorizontalLine(y:Number, g:Graphics):void
        {
            var count:Number = Math.floor(width/_dashSize);

            for (var i:int = 0; i <= count; i+=2)
            {
                g.moveTo(i*_dashSize, y);
                g.lineTo((i+1)*dashSize, y);
            }
        }
    }
}