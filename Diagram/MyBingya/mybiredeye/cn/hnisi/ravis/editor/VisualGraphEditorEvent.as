package cn.hnisi.ravis.editor
{
	import flash.events.Event;
	
	public class VisualGraphEditorEvent extends Event
	{
		public static const EDGE_DOUBLE_CLICK:String = "edgeDoubleClick";
		public var item:Object;
		
		public function VisualGraphEditorEvent(type:String,item:Object,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.item = item;
		}
	}
}