package com.hjx.diagram.editor
{
	import spark.components.supportClasses.SkinnableComponent;

	public class LinkGhost extends SkinnableComponent
	{
		private var _xFrom:Number;
		
		private var _xTo:Number;
		
		private var _yFrom:Number;
		
		private var _yTo:Number;
		
		public function LinkGhost()
		{
			mouseEnabled = false;
			mouseChildren = false;
		}

		[Bindable]
		public function get yTo():Number
		{
			return _yTo;
		}

		public function set yTo(value:Number):void
		{
			_yTo = value;
		}

		[Bindable]
		public function get yFrom():Number
		{
			return _yFrom;
		}

		public function set yFrom(value:Number):void
		{
			_yFrom = value;
		}

		[Bindable]
		public function get xTo():Number
		{
			return _xTo;
		}

		public function set xTo(value:Number):void
		{
			_xTo = value;
		}

		[Bindable]
		public function get xFrom():Number
		{
			return _xFrom;
		}

		public function set xFrom(value:Number):void
		{
			_xFrom = value;
		}

	}
}