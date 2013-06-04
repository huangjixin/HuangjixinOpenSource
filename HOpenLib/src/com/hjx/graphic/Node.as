package com.hjx.graphic
{
	import com.hjx.graphic.skin.NodeSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.core.EventPriority;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;

	[Style(name="backgroundColor", inherit="no", type="uint",format="Color")]
	[Style(name="borderColor", inherit="no", type="uint",format="Color")]
	[Style(name="caretColor", inherit="no", type="uint",format="Color")]
	[Style(name="color", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedColor", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedTextColor", inherit="yes", type="uint",format="Color")]
	/**
	 * 节点类基类，该节点继承自Renderer，组件可分为两大类，节点和连线。 
	 * @author huangjixin
	 * 
	 */
	public class Node extends Renderer
	{
		//--------------------------------------------------------
		// private 类私有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：private static const EXAMPLE:String = "example";
		//--------------------------------------------------------
		private static const DEFAULT_NODE_LABEL:String = "节点";
		//--------------------------------------------------------
		// public 类公有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：public static const EXAMPLE:String = "example";
		//--------------------------------------------------------
		
		
		//--------------------------------------------------------
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//--------------------------------------------------------
		private var _label:String;
		
		private var _movable : Boolean = true;
		
		private var _centerX : Number = NaN;
		private var _centerY : Number = NaN;
		
		private var _links:Vector.<Link> = new Vector.<Link>();
		private var _incomingLinks:Vector.<Link> = new Vector.<Link>();
		private var _outgoingLinks:Vector.<Link> = new Vector.<Link>();
		
		private var defaultCSSStyles:Object = {
			backgroundColor : 0xD1CE9C,
			borderColor : 0x0,
			skinClass:NodeSkin
		};
		
		//--------------------------------------------------------
		// public 公有变量声明处
		//--------------------------------------------------------
		[SkinPart(required="true")]
		/**
		 * 存放label标签等元素。 
		 */
		public var labelElement:DisplayObject;
		
		[SkinPart(required="true")]
		public var base:UIComponent;

		[SkinPart(required="false")]
		public var overviewDisplay:IFactory;
		//--------------------------------------------------------
		// 构造函数，初始化相关工作可以放在里面
		//--------------------------------------------------------
		public function Node()
		{
			super();
			label = DEFAULT_NODE_LABEL;
			
			/*for (var i:String in defaultCSSStyles) {
				setStyle (i, defaultCSSStyles [i]);
			}*/
			
			addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown,false,EventPriority.DEFAULT);
		}
		
		protected function handleMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		
		//--------------------------------------------------------
		// getter和setter函数
		//--------------------------------------------------------

		[Bindable]
		public function get outgoingLinks():Vector.<Link>
		{
			return _outgoingLinks;
		}

		public function set outgoingLinks(value:Vector.<Link>):void
		{
			_outgoingLinks = value;
		}

		[Bindable]
		public function get incomingLinks():Vector.<Link>
		{
			return _incomingLinks;
		}

		public function set incomingLinks(value:Vector.<Link>):void
		{
			_incomingLinks = value;
		}

		[Bindable]
		public function get links():Vector.<Link>
		{
			return _links;
		}

		public function set links(value:Vector.<Link>):void
		{
			_links = value;
		}

		public function get centerY():Number
		{
			return y+this.height/2;
		}
		
		public function set centerY(value:Number):void
		{
			_centerY = value;
		}
		
		public function get centerX():Number
		{
			return x+this.width/2;
		}
		
		public function set centerX(value:Number):void
		{
			_centerX = value;
		}
		
		[Bindable]
		/**
		 * 是否可以移动 
		 */
		public function get movable():Boolean
		{
			return _movable;
		}
		
		public function set movable(value:Boolean):void
		{
			_movable = value;
		}
		
		[Bindable]
		/**
		 * 元素上面的字符串。 
		 */
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			_label = value;
		}
		
		//--------------------------------------------------------
		// 相关事件响应函数和逻辑函数存放处
		//--------------------------------------------------------
		
		
		public function getIncomingLinks():Vector.<Link>{
			return null;
		}
		
		public function getIncomingLinksCount():int{
			return 0;
		}
		
		public function getLinks():Vector.<Link>{
			return this.incomingLinks.concat(outgoingLinks);
		}
		
		public function getLinksCount():int{
			return 0;
		}
		
		public function getNodeOrBaseBounds(targetCoordinateSpace:DisplayObject):Rectangle{
			return this.getBounds(targetCoordinateSpace);
		}
		
		public function getOutgoingLinks():Vector.<Link>{
			return null;
		}
		
		public function getOutgoingLinksCount():int{
			return 0;
		}
		
		public function resumeGraphLayoutInvalidationOnMoveResize():void{
		}
		
		public function suspendGraphLayoutInvalidationOnMoveResize():void{
		}

		public function invalidateLinkShape():void{
			for each (var incomingLink:Link in incomingLinks) 
			{
				incomingLink.invalidateShape();	
			}
			for each (var outgoingLink:Link in outgoingLinks) 
			{
				outgoingLink.invalidateShape();	
			}
		}
		
		/**
		 * 当位置变化或者大小变化的时候，重绘连线。 
		 * @param event
		 * 
		 */
		protected function baseGeometryChanged(event:Event):void
		{
			invalidateLinkShape();
		}
		
		//--------------------------------------------------------
		// override 覆盖函数
		//--------------------------------------------------------
		/**
		 * 监控移动缩放，刷新连线。 
		 * @param partName
		 * @param instance
		 * 
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			if(instance == base){
				base.addEventListener(MoveEvent.MOVE,baseGeometryChanged);
				base.addEventListener(ResizeEvent.RESIZE,baseGeometryChanged);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partRemoved(partName, instance);
			if(instance == base){
				base.removeEventListener(MoveEvent.MOVE,baseGeometryChanged);
				base.removeEventListener(ResizeEvent.RESIZE,baseGeometryChanged);
			}
		}
		/*		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
//			refresh();
		} 
		override public function stylesInitialized():void{
			super.stylesInitialized();
		}*/
	}
}