package cn.hnisi.ravis.editor
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.graphics.ImageSnapshot;
	import mx.managers.DragManager;
	
	import org.un.cava.birdeye.ravis.components.renderers.BaseRenderer;
	import org.un.cava.birdeye.ravis.components.renderers.nodes.BaseNodeRenderer;
	
	import spark.components.Group;
	import spark.components.Image;
	
	public class Palette extends Group
	{
		/**
		 * 定义一个用于拖拽格式的常量：bpmDragDataFormat。 
		 */
		public static const DATA_FORMAT:String = "bpmDragDataFormat";
		private var _draggedRenderer:BaseRenderer;
		
		public function Palette()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		/**
		 * 移动处理函数。 
		 * @param event
		 * 
		 */
		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		/**
		 * 鼠标按下处理函数，为拖拽做准备。 
		 * @param event
		 * 
		 */
		protected function onMouseDown(event:MouseEvent):void
		{
			this._draggedRenderer = getBaseRender(event.target);
			
			if (this._draggedRenderer) 
			{
				//--------------------------
				// 先获得拖拽事件源，再生成图像作为拖拽代理；
				//--------------------------
				var dragSrc:UIComponent = this._draggedRenderer as UIComponent;
				
				//--------------------------
				// 确定好目标偏移量
				//--------------------------
				var hDistance:Number=0;
				var vDistance:Number=0;
				var node:BaseNodeRenderer = BaseNodeRenderer(this._draggedRenderer);
				hDistance=mouseX - node.x;
				vDistance=mouseY - node.y;
				
				var dragSource:DragSource = new DragSource();
				var object:Object={};
				object.hDistance=hDistance;
				object.vDistance=vDistance;
				dragSource.addData(object, Palette.DATA_FORMAT);
				
				var cloneRenderer:BaseRenderer = VisualGraphEditor.cloneRendererStatic(node);
				object.cloneRenderer = cloneRenderer;
				//生成拖拽图片
				var image:Image=new Image();
				image.source=new Bitmap(ImageSnapshot.captureBitmapData(this._draggedRenderer as UIComponent));
				//--------------------------
				// 拖拽开始
				//--------------------------
				var point:Point = new Point(mouseX,mouseY);
				point = localToGlobal(point);
//				DragManager.doDrag(node, dragSource, event,cloneRenderer,node.x,node.y,1);
				DragManager.doDrag(node, dragSource, event,image);
			}
		}
		
		private function getBaseRender(object:Object):BaseRenderer
		{
			while (object is DisplayObject) 
			{
				if (object is BaseRenderer) 
				{
					return BaseRenderer(object);
				}
				object = object.parent;
			}
			return null;	
		}
	}
}