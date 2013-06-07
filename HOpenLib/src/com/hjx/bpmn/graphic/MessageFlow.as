package com.hjx.bpmn.graphic
{
	import com.hjx.graphic.Node;

	public class MessageFlow extends ConnectingObject
	{
		public function MessageFlow(startNode:Node=null, endNode:Node=null)
		{
			super(startNode, endNode);
		}
	}
}