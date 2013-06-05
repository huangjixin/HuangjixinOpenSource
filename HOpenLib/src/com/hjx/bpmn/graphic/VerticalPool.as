package com.hjx.bpmn.graphic
{
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;
	
	import spark.layouts.HorizontalAlign;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalAlign;
	import spark.layouts.VerticalLayout;
	
	/**
	 * 竖甬道池，用于放置甬道。 
	 * @author huangjixin
	 * 
	 */
	public class VerticalPool extends HorizontalLane
	{
		public function VerticalPool()
		{
			super();
		}
		
		override public  function addElement(element:IVisualElement):IVisualElement{
			var ele:IVisualElement = super.addElement(element);
			ele.percentWidth = 100;
			ele.addEventListener(ResizeEvent.RESIZE,onEleResize);
			return ele;
		}
		
		override protected function onEleResize(event:ResizeEvent):void
		{
			(this.graph.layout as HorizontalLayout).target.invalidateDisplayList();
		}
		
		/**
		 * 更改布局为横布局。 
		 * @param partName
		 * @param instance
		 * 
		 */
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (partName == "graph") 
			{
				var hLayout:HorizontalLayout= new HorizontalLayout();hLayout.horizontalAlign= HorizontalAlign.CENTER;
				hLayout.gap = -2;
				this.graph.layout =hLayout;
			}
		}
	}
}