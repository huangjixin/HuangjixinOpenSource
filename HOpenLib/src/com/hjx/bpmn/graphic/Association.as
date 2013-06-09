package com.hjx.bpmn.graphic
{
	import com.hjx.graphic.DashStyle;
	import com.hjx.graphic.Node;
	
	public class Association extends ConnectingObject
	{
		public function Association(startNode:Node=null, endNode:Node=null)
		{
			super(startNode, endNode);
			this.setStyle("dash",4);
			setStyle("dashStyle",DashStyle.DASH);
		}
	}
}