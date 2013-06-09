package com.hjx.bpmn.graphic.icons
{
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 *  
	 * @author huangjixin
	 * 
	 */
	public class BPMNIcon extends SkinnableComponent
	{
		[Bindable]
		public var filled:Boolean = false;
		
		[Bindable]
		public var fillColor:uint = 0xffffff;
		
		[Bindable]
		public var closedStrokeColor:uint = 0x000000;
		
		[Bindable]
		public var openStrokeColor:uint = 0x000000;
		
		public function BPMNIcon()
		{
			super();
		}
	}
}