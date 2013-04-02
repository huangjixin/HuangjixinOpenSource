package com.hjx.diagram
{
	/**
	 * @author 黄记新, 下午3:31:34
	 */
	import com.hjx.graphic.Node;
	
	import flash.events.Event;
	
	public class DiagramNodeMoveEvent extends Event
	{
		private var _isInteractionEnd:Boolean;
		private var _item:Object;
		private var _node:Node;
		private var _veto:Boolean = false;
		private var _x:Number = NaN;
		private var _y:Number = NaN;
		
		public function DiagramNodeMoveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get veto():Boolean
		{
			return _veto;
		}

		public function set veto(value:Boolean):void
		{
			_veto = value;
		}

		public function get node():Node
		{
			return _node;
		}

		public function get item():Object
		{
			return _item;
		}

		public function get isInteractionEnd():Boolean
		{
			return _isInteractionEnd;
		}

	}
}