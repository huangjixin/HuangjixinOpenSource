package com.hjx.diagram.editor{

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.graphics.IFill;
import mx.graphics.IStroke;

import spark.primitives.supportClasses.GraphicElement;

/**
 * 绘制表格。
 * <br></br> 
 */
public class Grid extends GraphicElement {
	public function Grid() {
		super();
	}

	private var _tempDisplayObject:Sprite = new Sprite();
	private var _bitmapData : BitmapData;
	private var _bitmapRect : Rectangle;

	private var _stroke : IStroke;

	public function get stroke():IStroke {
		return _stroke;
	}

	public function set stroke(value:IStroke):void {
		weight = value.weight;
		_stroke = value;
		invalidateSize();
		invalidateBitmapData();
		invalidateDisplayList();
		invalidateParentSizeAndDisplayList();
	}

	private var _fill : IFill;

	public function get fill():IFill {
		return _fill;
	}

	public function set fill(value:IFill):void {
		_fill = value;
		invalidateSize();
		invalidateBitmapData();
		invalidateDisplayList();
		invalidateParentSizeAndDisplayList();
	}

	private var _step:Number=20;
	/**
	 *  Grid step
	 *  @default 20
	 */
	[Inspectable("General", minValue="2.0")]
	public function get step():Number
	{
		return _step;
	}
	public function set step(value:Number):void
	{
		if (value != _step)
		{
			_step = Math.max(2, value);

			invalidateSize();
			invalidateBitmapData();
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();
		}
	}

	private var _type : String = "line";

	[Inspectable(enumeration="dot,line,none")]
	public function get type():String {
		return _type;
	}

	public function set type(value:String):void {
		_type = value;
		invalidateSize();
		invalidateBitmapData();
		invalidateDisplayList();
		invalidateParentSizeAndDisplayList();
	}

	private var _weight : Number = .5;

	protected function get weight():Number {
		return _weight;
	}
	protected function set weight(value:Number):void {
		_weight = Math.max(value, Math.max(value, .5));
	}

	protected function invalidateBitmapData() : void
	{
		if(_bitmapData) {
			_bitmapData.dispose();
			_bitmapData = null;
		}
		_bitmapData = new BitmapData(Math.max(1,_step), Math.max(1,_step), true, 0xFF0000);
		_bitmapRect = new Rectangle(0, 0, _step, _step);

		_tempDisplayObject.graphics.clear();

		if(stroke) {
			stroke.apply(_tempDisplayObject.graphics, _bitmapRect, new Point());
		}
		if(fill) {
			fill.begin(_tempDisplayObject.graphics, _bitmapRect, new Point());
		}

		draw(_tempDisplayObject.graphics);

		_tempDisplayObject.graphics.endFill();
		_bitmapData.draw(_tempDisplayObject);
	}

	protected function draw(graphics : Graphics) : void
	{
		switch(type) {
			case "dot":
					graphics.drawCircle(_step-2*weight, _step-2*weight, weight);
				break;
			case "line":
					graphics.drawRect(step-weight, 0, weight, step);
					graphics.drawRect(0, step-weight, step, weight);
				break;
			case "none":
				break;
		}
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		var g:Graphics = Sprite(drawnDisplayObject).graphics;

		g.lineStyle();
		g.beginBitmapFill(_bitmapData, null, true, false);
		g.drawRect(drawX, drawY, unscaledWidth, unscaledHeight);
		g.endFill();
	}
}
}
