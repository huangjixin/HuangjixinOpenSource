package com.hjx.bpmn.graphic
{
	/**
	 * @author 黄记新, 下午09:45:08
	 */
	import com.hjx.graphic.LinkShapeType;
	import com.hjx.graphic.Node;
	
	public class SequenceFlow extends ConnectingObject
	{
		public function SequenceFlow(startNode:Node=null, endNode:Node=null)
		{
			super(startNode, endNode);
		}
	}
}