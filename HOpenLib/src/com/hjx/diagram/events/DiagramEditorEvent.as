package com.hjx.diagram.events
{
	import flash.events.Event;
	
	public class DiagramEditorEvent extends Event
	{
		public static const EDITOR_DOUBLE_CLICK:String = "editor_double_click";
		
		public var object:Object;
		public function DiagramEditorEvent(type:String,object:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.object = object;
		}
	}
}