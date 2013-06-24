package com.hjx.bpmn.graphic
{
	import com.hjx.graphic.SubGraph;
	import com.hjx.jbpm.Swim_lane;
	
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;
	
	/**
	 * 甬道基类。 
	 * @author huangjixin
	 * 
	 */
	public class LaneBase extends SubGraph
	{
		public var poolMarginLeft:Number=5;
		
		public var poolMarginTop:Number=5;
		
		public var poolMarginRight:Number=5;
		
		public var poolMarginBottom:Number=5;
		
		internal var _gap:int=-1
			
		private var _swimlane:Swim_lane;
		
		public function LaneBase()
		{
			super();
			swimlane = new Swim_lane();
			swimlane.assignment.className="org.wbase.framework.jbpm.extend.RoleBasedAssignmentHandler";
			swimlane.assignment.config_type="bean";
			swimlane.name = label;
		}
		
		public function get swimlane():Swim_lane
		{
			return _swimlane;
		}

		public function set swimlane(value:Swim_lane):void
		{
			_swimlane = value;
		}

		public function isHorizontal():Boolean
		{
			return false;
		}
		
		public function isLeaf():Boolean
		{
			if (graph && graph.numElements > 0 && graph.getElementAt(0) is LaneBase) 
			{
				return false;
			}
			return true;
		}
		
		override public function set label(value:String):void{
			super.label = value;
			if(swimlane)
				swimlane.name = value;
		}
		
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
		}
	}
}