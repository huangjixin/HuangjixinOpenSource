package com.hjx.bpmn.graphic
{
	import com.hjx.graphic.Renderer;
	
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;
	
	import spark.layouts.VerticalAlign;
	import spark.layouts.VerticalLayout;

	/**
	 * 横甬道池，用于放置甬道。 
	 * @author huangjixin
	 * 
	 */
	public class HorizontalPool extends HorizontalLane
	{
		public function HorizontalPool()
		{
			super();
			this.addEventListener(ResizeEvent.RESIZE,onResize);
		}
		
		override public  function addElement(element:IVisualElement):IVisualElement{
			if(element is HorizontalLane){
				super.addElement(element)
			}
			return element;
		}
		
		protected function onResize(event:ResizeEvent):void
		{
			
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
				/*var length:int = mxmlContent.length;
				for (var i:int = 0; i < length; i++) 
				{
					var laneBase:LaneBase = mxmlContent[i] as LaneBase;
					if(laneBase){
						if(i!=0){
							laneBase.y = (mxmlContent[i-1] as LaneBase).y+(mxmlContent[i-1] as LaneBase).height-2;
						}
					}
				}*/
				/*graph.mxmlContent = _mxmlContent;
				graph.owningSubGraph = this;*/
				
				var vLayout:VerticalLayout= new VerticalLayout();vLayout.verticalAlign= VerticalAlign.MIDDLE;
				vLayout.gap = -2;
				this.graph.layout =vLayout;
			}
		}
	}
}