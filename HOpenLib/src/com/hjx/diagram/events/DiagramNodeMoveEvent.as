package com.hjx.diagram.events
{
	import com.hjx.graphic.Node;
	
	import flash.events.Event;
	
	/**
	 * 
	 * @author 黄记新, 下午3:31:34
	 * 节点移动事件。
	 */
	public class DiagramNodeMoveEvent extends Event
	{
		/**
		 * 节点移动常量。 
		 */
		public static const NODE_MOVE:String = "nodeMove";
		
		private var _isInteractionEnd:Boolean;
		private var _item:Object;
		private var _node:Node;
		private var _veto:Boolean = false;
		private var _x:Number = NaN;
		private var _y:Number = NaN;
		
		public function DiagramNodeMoveEvent(type:String,_item:Object=null,node:Node= null, _isInteractionEnd:Boolean = true,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._item = item;
			this._node = node;
			this._isInteractionEnd = isInteractionEnd;
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

		/**
		 * 移动的节点。 
		 * @return 
		 * 
		 */
		public function get node():Node
		{
			return _node;
		}

		/**
		 * 数据模型里面的数据。 
		 * @return 
		 * 
		 */
		public function get item():Object
		{
			return _item;
		}

		/**
		 * 当为真的时候，表示节点移动已经结束了。 
		 * @return 
		 * 
		 */
		public function get isInteractionEnd():Boolean
		{
			return _isInteractionEnd;
		}

	}
}