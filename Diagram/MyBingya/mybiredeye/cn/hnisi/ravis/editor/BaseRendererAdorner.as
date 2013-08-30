package cn.hnisi.ravis.editor
{
	import cn.hnisi.ravis.editor.skin.BaseRendererAdornerSkin;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.SandboxMouseEvent;
	
	import org.un.cava.birdeye.ravis.components.renderers.BaseRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.VisualNode;
	
	import spark.components.Group;
	
	public class BaseRendererAdorner extends Adorner
	{
		[SkinPart(required="false")]
		public var addArrowBtn:UIComponent;
		[SkinPart(required="false")]
		public var deleteBtn:UIComponent;
		[SkinPart(required="false")]
		public var detailBtn:UIComponent;
		
		private var startX:Number;  
		private var startY:Number; 

		private var adornerGroup:Group;
		
		private var _data:Object;
		public function BaseRendererAdorner(adornedObject:UIComponent)
		{
			super(adornedObject);
			setStyle("skinClass",BaseRendererAdornerSkin);
		}
		

		protected function onAddArrowBtnMouseDown(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var adornerGroup:Group = getAdornerGroup(event.target);
			if(!adornerGroup){
				return;
			}
			this.adornerGroup = adornerGroup;
			this.startX = adornerGroup.mouseX;  
			this.startY = adornerGroup.mouseY; 

			var rectangle:Rectangle=null;
			if (parent != null) 
			{
				var displayObject:DisplayObject = systemManager.getSandboxRoot();  
				displayObject.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);  
				displayObject.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);  
				displayObject.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);  
				displayObject.addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);  
				systemManager.deployMouseShields(true); 

			}
		}
		
		
		protected function ondeleteBtnMouseDown(event:MouseEvent):void
		{
			var vgeditor:VisualGraphEditor = getVisualGraphEditor(this);
			vgeditor.deleteRenderer(this.adornedObject);
		}	
		
		public function getAdornerGroup(object:Object):Group
		{
			if (object == null || (object.hasOwnProperty("id")&&object["id"] == "adornersGroup")) 
			{
				return object as Group;
			}
			return getAdornerGroup(object.parent);
		}
		
		public function getHitrenderer(object:Object):BaseRenderer
		{
			if(object is UIComponent){
				var array:Array = (object as UIComponent).stage.getObjectsUnderPoint(new Point((object as UIComponent).stage.mouseX,(object as UIComponent).stage.mouseY));
				for (var i:int = array.length-1; i >= 0; i--) 
				{
					var obj:Object = array[i];
					var renderer:BaseRenderer = getRenderer(obj);
					if(renderer){
						return renderer as BaseRenderer;
					}
				}
			}
			return null;
		}
		
		public function getRenderer(object:Object):BaseRenderer
		{
			if (object == null || (object is BaseRenderer) )
			{
				return object as BaseRenderer;
			}
			return getRenderer(object.parent);
		}
		
		public function getVisualGraphEditor(object:Object):VisualGraphEditor
		{
			if (object == null || (object is VisualGraphEditor) )
			{
				return object as VisualGraphEditor;
			}
			return getVisualGraphEditor(object.parent);
		}
		
		protected function mouseDragHandler(event:Event):void  
		{
			if(this.adornerGroup){
				var g:Graphics = this.adornerGroup.graphics;
				g.clear();
				g.lineStyle(1,0);
				g.moveTo(this.startX,this.startY);
				g.lineTo(this.adornerGroup.mouseX,this.adornerGroup.mouseY);
			}
		}  

		protected function mouseUpHandler(event:Event):void  
		{  
			var g:Graphics = this.adornerGroup.graphics;
			g.clear();
			this.adornerGroup = null;
			var renderer:BaseRenderer = getHitrenderer(event.target);
			var vgEditor:VisualGraphEditor = getVisualGraphEditor(event.target);
			if(vgEditor){
				if(renderer){
					if(renderer != this.adornedObject){
						if(vgEditor.contains(renderer)){
							if(this.adornedObject is BaseRenderer){
								var vnode1:IVisualNode = (this.adornedObject as BaseRenderer).data as IVisualNode;
								var vnode2:IVisualNode = renderer.data as IVisualNode;
								var iVisualEdge:IVisualEdge = vgEditor.linkNodes(vnode1,vnode2);
								var vnodeXml1:XML;
								if(vnode1.data is XML){
									vnodeXml1 = vnode1.data as XML;
								}
								var vnodeXml2:XML;
								if(vnode2.data is XML){
									vnodeXml2 = vnode2.data as XML;
								}
								if(!vnodeXml1 || !vnodeXml2){
									return;
								}
								var xmlString:String = "<Edge fromID=\""+vnodeXml1.@id+"\" toID=\""+vnodeXml2.@id+"\" color=\"0x00ff00\""+"/>";
								var xml:XML =  new XML(xmlString);
								iVisualEdge.data = xml;
							}
						}
					}
					
				}
			}
			var displayObject:DisplayObject=systemManager.getSandboxRoot();  
			displayObject.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);  
			displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseDragHandler, true);  
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, this.mouseUpHandler, true);  
			displayObject.removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, this.mouseDragHandler, true);  
			systemManager.deployMouseShields(false);  
			 
		}  

		
		protected function ondetailBtnMouseDown(event:MouseEvent):void
		{
			event.stopPropagation();
			BaseRendererAdornerSkin(this.skin).data = BaseRenderer(this.adornedObject).data.data;
		}
		
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			if(instance == addArrowBtn){
				addArrowBtn.addEventListener(MouseEvent.MOUSE_DOWN,onAddArrowBtnMouseDown);
			}
			if(instance == deleteBtn){
				deleteBtn.addEventListener(MouseEvent.MOUSE_DOWN,ondeleteBtnMouseDown);
			}
			if(instance == detailBtn){
				detailBtn.addEventListener(MouseEvent.MOUSE_DOWN,ondetailBtnMouseDown);
			}
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			if(instance == addArrowBtn){
				addArrowBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onAddArrowBtnMouseDown);
			}
			if(instance == deleteBtn){
				deleteBtn.removeEventListener(MouseEvent.MOUSE_DOWN,ondeleteBtnMouseDown);
			}
			if(instance == detailBtn){
				detailBtn.removeEventListener(MouseEvent.MOUSE_DOWN,ondetailBtnMouseDown);
			}
		}
	}
}