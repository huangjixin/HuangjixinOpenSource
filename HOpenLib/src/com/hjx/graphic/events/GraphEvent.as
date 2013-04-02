package com.hjx.graphic.events
{
	/**
	 * @author 黄记新, 下午3:07:11
	 */
	import flash.events.Event;
	
	public class GraphEvent extends Event
	{
		private var _element : Object;
		
		/**
		 * The GraphEvent.ELEMENT_GEOMETRY_CHANGE constant defines the value of the type property of the event object for an elementGeometryChange event. 
		 * This event is sent when an object is either moved or resized in the graph.
		 */
		public static const ELEMENT_GEOMETRY_CHANGE:String = "elementGeometryChange";
			
		/**
		 * The GraphEvent.GRAPH_ADD constant defines the value of the type property of the event object for a graphAdd event. 
		 * This event is dispatched when a graph is added to a graph. 
		 */
		public static const GRAPH_ADD:String = "graphAdd";
		
		/**
		 * The GraphEvent.GRAPH_LAYOUT_END constant defines the value of the type property of the event object for a graphLayoutEnd event. 
		 * This event is dispatched when the graph layout animation ends in the graph. 
		 */
		public static const GRAPH_LAYOUT_END:String = "graphLayoutEnd";
		
		/**
		 * The GraphEvent.GRAPH_LAYOUT_START constant defines the value of the type property of the event object for a graphLayoutStart event. 
		 * This event is dispatched when the graph layout animation starts in the graph. 
		 */
		public static const GRAPH_LAYOUT_START:String = "graphLayoutStart";
		
		/**
		 * The GraphEvent.GRAPH_REMOVE constant defines the value of the type property of the event object for a graphRemove event. 
		 * This event is dispatched when a graph is removed from a graph. 
		 */
		public static const GRAPH_REMOVE:String = "graphRemove";
		
		/**
		 * The GraphEvent.LINK_ADD constant defines the value of the type property of the event object for a linkAdd event. 
		 * This event is dispatched when a link is added to a graph. 
		 */
		public static const LINK_ADD:String = "linkAdd";
		
		/**
		 * The GraphEvent.LINK_REMOVE constant defines the value of the type property of the event object for a linkRemove event. 
		 * This event is dispatched when a link is removed from a graph. 
		 */
		public static const LINK_REMOVE:String = "linkRemove";
		
		/**
		 *The GraphEvent.NODE_ADD constant defines the value of the type property of the event object for a nodeAdd event. 
		 * This event is dispatched when an object is added to a graph. 
		 */
		public static const NODE_ADD:String = "nodeAdd";
		
		/**
		 * The GraphEvent.NODE_REMOVE constant defines the value of the type property of the event object for a nodeRemove event. 
		 * This event is dispatched when a node is removed from a graph. 
		 */
		public static const NODE_REMOVE:String = "nodeRemove";
		
		public function GraphEvent(type:String,element : Object= null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_element = element;
		}

		public function get element():Object
		{
			return _element;
		}

	}
}