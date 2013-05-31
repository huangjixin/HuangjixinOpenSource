/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.graphic
{
	/*******************************************
	 **** huangjixin,2013-3-29,上午9:27:15 **
	 **** 请一句话表述该类主要作用  **
	 *******************************************/
	import com.hjx.graphic.events.SubgraphEvent;
	import com.hjx.graphic.skin.SubGraphSkin;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	[SkinState("collapsed")]
	[SkinState("collapsedAndShowsCaret")]
	[SkinState("collapsedSelected")]
	[SkinState("collapsedSelectedAndShowsCaret")]
	[Event(name="collapseAnimationEnd", type="com.hjx.graphic.events.SubgraphEvent")]
	[Event(name="collapseAnimationStart", type="com.hjx.graphic.events.SubgraphEvent")]
	[Event(name="elementGeometryChange", type="com.hjx.graphic.events.GraphEvent")]
	[Event(name="expandAnimationEnd", type="com.hjx.graphic.events.SubgraphEvent")]
	[Event(name="expandAnimationStart", type="com.hjx.graphic.events.SubgraphEvent")]
	[Event(name="graphAdd", type="com.hjx.graphic.events.GraphEvent")]
	[Event(name="graphRemove", type="com.hjx.graphic.events.GraphEvent")]
	[Event(name="linkAdd", type="com.hjx.graphic.events.GraphEvent")]
	[Event(name="linkRemove", type="com.hjx.graphic.events.GraphEvent")]
	[Event(name="nodeAdd", type="com.hjx.graphic.events.GraphEvent")]
	[Event(name="nodeRemove", type="com.hjx.graphic.events.GraphEvent")]
	
	[DefaultProperty("mxmlContent")] 
	public class SubGraph extends Node implements IVisualElementContainer
	{
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// private 类私有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：private static const EXAMPLE:String = "example";
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 类公有静态变量和静态常量声明处。（全部大写，使用下划线进行分割）
		// 例如：public static const EXAMPLE:String = "example";
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// private 私有变量声明处，请以“_”开头定义变量
		// 例如：private var _example:String;
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		private var _collapsed:Boolean;
		
		private var _automaticGraphLayout:Boolean;
		
		private var mxmlContentChanged:Boolean = false;
		private var _mxmlContent:Array = [];
		
		private var defaultCSSStyles:Object = {
			skinClass:SubGraphSkin
		};
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		[SkinPart(required="true")]
		public var graph:Graph;
		
		private var _collapsedWidth :Number;
		private var _collapsedHeight :Number;
		private var _expandedWidth :Number;
		private var _expandedHeight :Number;
		
		[Bindable]
		public var graphMarginLeft:Number = 0;
		[Bindable]
		public var graphMarginRight:Number = 0;
		[Bindable]
		public var graphMarginTop:Number = 0;
		[Bindable]
		public var graphMarginBottom:Number = 0;
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 构造函数，初始化相关工作可以放在里面
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function SubGraph()
		{
			super();
			collapsedWidth = 100;
			collapsedHeight = 50;
		}
		//构造函数结束
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// getter和setter函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/		

		[Bindable]
		/**
		 * 张开状态高度 
		 */
		public function get expandedHeight():Number
		{
			return _expandedHeight;
		}

		/**
		 * @private
		 */
		public function set expandedHeight(value:Number):void
		{
			if (isNaN(value) && isNaN(this._expandedHeight)) 
			{
				return;
			}
			if (value != this._expandedHeight) 
			{
				this._expandedHeight = value;
				if (!this.collapsed) 
				{
					if (value != height) 
					{
						super.height = value;
					}
					if (value != explicitHeight) 
					{
						super.explicitHeight = value;
					}
				}
			}
		}

		[Bindable]
		/**
		 * 张开状态宽度 
		 */
		public function get expandedWidth():Number
		{
			return _expandedWidth;
		}

		/**
		 * @private
		 */
		public function set expandedWidth(value:Number):void
		{
			if (isNaN(value) && isNaN(this._expandedWidth)) 
			{
				return;
			}
			if (value != this._expandedWidth) 
			{
				this._expandedWidth = value;
				if (!this.collapsed) 
				{
					if (value != width) 
					{
						super.width = value;
					}
					if (value != explicitWidth) 
					{
						super.explicitWidth = value;
					}
				}
			}
		}

		[Bindable]
		/**
		 *收缩状态高度 
		 */
		public function get collapsedHeight():Number
		{
			return _collapsedHeight;
		}

		/**
		 * @private
		 */
		public function set collapsedHeight(value:Number):void
		{
			if (isNaN(value) && isNaN(this._collapsedHeight)) 
			{
				return;
			}
			if (value != this._collapsedHeight) 
			{
				this._collapsedHeight = value;
				if (this.collapsed) 
				{
					if (value != height) 
					{
						super.height = value;
					}
					if (value != explicitHeight) 
					{
						super.explicitHeight = value;
					}
				}
			}
		}

		[Bindable]
		/**
		 * 收缩状态宽度
		 */
		public function get collapsedWidth():Number
		{
			return _collapsedWidth;
		}

		/**
		 * @private
		 */
		public function set collapsedWidth(value:Number):void
		{
			if (isNaN(value) && isNaN(this._collapsedWidth)) 
			{
				return;
			}
			if (value != this._collapsedWidth) 
			{
				this._collapsedWidth = value;
				if (this.collapsed) 
				{
					if (value != width) 
					{
						super.width = value;
					}
					if (value != explicitWidth) 
					{
						super.explicitWidth = value;
					}
				}
			}
			return;
		}

		public function get mxmlContent():Array
		{
			return _mxmlContent;
		}

		[Bindable]
		public function get automaticGraphLayout():Boolean
		{
			return _automaticGraphLayout;
		}

		public function set automaticGraphLayout(value:Boolean):void
		{
			_automaticGraphLayout = value;
		}

		[Bindable]
		/**
		 * 收缩状态 
		 */
		public function get collapsed():Boolean
		{
			return _collapsed;
		}

		/**
		 * @private
		 */
		public function set collapsed(value:Boolean):void
		{
			if (this._collapsed != value) 
			{
				if (this._collapsed) 
				{
					this._collapsedWidth = explicitWidth;
					this._collapsedHeight = explicitHeight;
				}
				else 
				{
					this._expandedWidth = explicitWidth;
					this._expandedHeight = explicitHeight;
				}
				_collapsed = value;;
				if (this._collapsed) 
				{
					explicitWidth = this._collapsedWidth;
					explicitHeight = this._collapsedHeight;
				}
				else 
				{
					explicitWidth = this._expandedWidth;
					explicitHeight = this._expandedHeight;
				}
				invalidateSkinState();
				this.performLayoutOnParent();
			}
			return;
		}

		
		/**
		 * 该setter函数保证了可以在mxml里面进行组件声明。 
		 * @param value
		 * 
		 */
		public function set mxmlContent(value:Array):void
		{
			_mxmlContent = value;
			mxmlContentChanged = true;
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			if (this._collapsed) 
			{
				this.collapsedWidth = value;
			}
			else 
			{
				this.expandedWidth = value;
			}
		} 
		
		override public function set height(value:Number):void{
			super.height = value;
			if (this._collapsed) 
			{
				this.collapsedHeight = value;
			}
			else 
			{
				this.expandedHeight = value;
			}
		} 
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 相关事件响应函数和逻辑函数存放处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		//--------------------------------------------------------------------------
		//
		//  内容管理
		//
		//--------------------------------------------------------------------------
		public function get numElements():int
		{
			return graph.numElements;
		}
		
		public function getElementAt(index:int):IVisualElement
		{
			return graph.getElementAt(index);
		}
		
		/**
		 * 复写 addElement方法，当皮肤尚未被加载的时候，graph对象为null，此时调用方法callLater在后面一帧进行加载。
		 * @param element
		 * @return 
		 * 
		 */
		public function addElement(element:IVisualElement):IVisualElement
		{
			if(!graph){
				callLater(addElement,[element]);
				return element;
			}else{
				return graph.addElement(element);			
			}
		}
		
		/**
		 * 复写 addElementAt方法，当皮肤尚未被加载的时候，graph对象为null，此时调用方法callLater在后面一帧进行加载。
		 * @param element
		 * @param index
		 * @return 
		 * 
		 */
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			if(!graph){
				callLater(addElementAt,[element,index]);
				return element;
			}else{
				return graph.addElementAt(element, index);			
			}
		}
		
		/**
		 * 复写 removeElement方法，当皮肤尚未被加载的时候，graph对象为null，此时调用方法callLater在后面一帧进行加载。
		 * @param element
		 * @return 
		 * 
		 */
		public function removeElement(element:IVisualElement):IVisualElement
		{
			if(!graph){
				callLater(removeElement,[element]);
				return element;
			}else{
				return graph.removeElement(element);			
			}
		}
		
		/**
		 * 复写 removeElementAt方法，当皮肤尚未被加载的时候，graph对象为null，此时调用方法callLater在后面一帧进行加载。
		 * @param index
		 * @return 
		 * 
		 */
		public function removeElementAt(index:int):IVisualElement
		{
			return graph.removeElementAt(index);
		}
		
		public function removeAllElements():void
		{
			graph.removeAllElements();
		}
		
		public function getElementIndex(element:IVisualElement):int
		{
			return graph.getElementIndex(element);
		}
		
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			graph.setElementIndex(element,index);
		}
		
		public function swapElements(element1:IVisualElement, element2:IVisualElement):void
		{
			graph.swapElements(element1,element2);
		}
		
		public function swapElementsAt(index1:int, index2:int):void
		{
			graph.swapElementsAt(index1,index2);
		}
		
		
		/**
		 * 当开始收缩的时候，派发SubgraphEvent动画开始事件。
		 * 
		 */
		public function collapseAnimationStart():void{
//			collapseLinks(this,this);
//			refresh();
			dispatchEvent(new SubgraphEvent(SubgraphEvent.COLLAPSE_ANIMATION_START));
		}
		
		/**
		 * 当结束收缩的时候，派发SubgraphEvent动画开始事件。
		 * 
		 */
		public function collapseAnimationEnd():void{
			dispatchEvent(new SubgraphEvent(SubgraphEvent.COLLAPSE_ANIMATION_END));
		}
		
		/**
		 * 当开始扩展的时候，派发SubgraphEvent动画开始事件。
		 * 
		 */
		public function expandAnimationStart():void{
			dispatchEvent(new SubgraphEvent(SubgraphEvent.EXPAND_ANIMATION_START));
		}
		
		/**
		 * 当结束收缩的时候，派发SubgraphEvent动画开始事件。 
		 * 
		 */
		public function expandAnimationEnd():void{
			dispatchEvent(new SubgraphEvent(SubgraphEvent.EXPAND_ANIMATION_END));
		}
		
		
		public function performLayoutOnParent():void{
		
		}
		
		public function performGraphLayout(traverse:Boolean = false):void{
		
		}
		
		/**
		 * 收拢连线，把连线都附到第二个参数子图上面。 
		 * @param subGraph0 递归子图。
		 * @param subGraph 收拢子图。
		 * 
		 */
		private function collapseLinks(subGraph0:SubGraph,subGraph:SubGraph):void{
			var node:Node;
			var length:int = subGraph0.graph.numElements;
			for (var i:int = 0; i < length; i++) 
			{
				var element:IVisualElement = subGraph0.graph.getElementAt(i);
				if(element is Node){
					node = element as Node;
					var link:Link;
					for each(link in node.getLinks()){
						//要收拢的线必须不在当前子图，连线只能有一头在当前子图里面。
						if(!subGraph.contains(link)){
							if (subGraph.contains(link.startNode)){
								if(!link.fallbackStartPoint){
									link.fallbackStartPoint = new Point();
								}
								link.fallbackStartPoint.setTo(subGraph.centerX,subGraph.centerY);
								link.fallbackStartPoint = subGraph.parent.localToGlobal(link.fallbackStartPoint);
								link.fallbackStartPoint = link.parent.globalToLocal(link.fallbackStartPoint);
							}
							if (subGraph.contains(link.endNode)){
								if(!link.fallbackEndPoint){
									link.fallbackEndPoint = new Point();
								}
								link.fallbackEndPoint.setTo(subGraph.centerX,subGraph.centerY);
								link.fallbackEndPoint = subGraph.parent.localToGlobal(link.fallbackEndPoint);
								link.fallbackEndPoint = link.parent.globalToLocal(link.fallbackEndPoint);
							}
						}
					}
//					node.refresh();
				}
				//递归下去，收拢连线。
				if(node is SubGraph){
					SubGraph(node).collapseLinks(SubGraph(node),subGraph);
				}
			}
			
		}
		
		/**
		 * 在状态变成展开的时候，展开连线，主要是设置连线的开始和结束节点为Null值。 
		 * @param subGraph
		 * 
		 */
		private function expandLinks(subGraph:SubGraph):void{
			var node:Node;
			var length:int = graph.numElements;
			for (var i:int = 0; i < length; i++) 
			{
				var element:IVisualElement = graph.getElementAt(i);
				if(element is Node){
					node = element as Node;
					
					var link:Link;
					for each(link in node.getLinks()){
						//要收拢的线必须不在当前子图，连线只能有一头在当前子图里面。
						if(!subGraph.contains(link)){
							if (subGraph.contains(link.startNode)){
								link.fallbackStartPoint = null;
							}
							if (subGraph.contains(link.endNode)){
								link.fallbackEndPoint = null;
							}
						}
					}
					
//					node.refresh();
				}
				//递归下去，张开连线。
				if(node is SubGraph){
					var collapsed:Boolean = SubGraph(node).collapsed;
					if(!collapsed){
						SubGraph(node).expandLinks(this);
					}
				}
			}
		}
		
		/**
		 * 子图是能够嵌套，所以要刷新嵌套的子图。 
		 * @param subGraph
		 * 
		 */
		internal function refreshChildrens(subGraph:SubGraph):void{
			var node:Node;
			var length:int = subGraph.graph.numElements;
			for (var i:int = 0; i < length; i++) 
			{
				var element:IVisualElement = subGraph.graph.getElementAt(i);
				if(element is Node){
					node = element as Node;
//					node.refresh();
				}
				//递归下去，收拢连线。
				if(node is SubGraph){
					if(SubGraph(node).graph){
						/*if(!SubGraph(node).collapsed){
							SubGraph(node).refreshChildrens(SubGraph(node));
						}*/
						SubGraph(node).refreshChildrens(SubGraph(node));
					}
				}
			}
		}
		
		/**
		 * 刷新内部连线实现具体方法。 
		 * 
		 */
		internal function invalidateLinkOfHierarchechyImpl():void{
			var length:int = graph.numElements;
			var node:Node;
			for (var i:int = 0; i < length; i++) 
			{
				var element:IVisualElement = graph.getElementAt(i);
				if(element is Node){
					node = element as Node;
					node.invalidateLinkShape();
				}
				//递归下去，收拢连线。
				if(node is SubGraph){
					if(SubGraph(node).graph){
						SubGraph(node).invalidateLinkOfHierarchechy();
					}
				}
			}
		}
		
		/**
		 * 刷新内部连线。 
		 * 
		 */
		private function invalidateLinkOfHierarchechy():void{
			invalidateLinkOfHierarchechyImpl()
		}
		
		override public function invalidateLinkShape():void{
			super.invalidateLinkShape();
			invalidateLinkOfHierarchechy();
		}
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// override 覆盖函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//		override public function refresh():void{
//			super.refresh();
//			refreshChildrens(this);
			/*if(collapsed){
				collapseLinks(this,this);
			}else{
//				expandLinks(this);
			}*/
//		}
		override public function clone():Renderer{
			var cloneRenderer:Renderer = super.clone();
			cloneChildren(this, cloneRenderer);
			return cloneRenderer;
		}
		
		/**
		 * 克隆孩子。 
		 * @param renderer
		 * @param cloneRenderer
		 * 
		 */
		internal function cloneChildren(renderer:Renderer, cloneRenderer:Renderer):void{
			var length:int=0;
			var ele:Renderer=null;
			var clo:Renderer=null;
			var subGraph:SubGraph = renderer as SubGraph;
			if (subGraph != null) 
			{
				var i:int = 0;
				length = subGraph.numElements;
				while (i < length) 
				{
					ele = subGraph.getElementAt(i) as Renderer;
					if (ele) 
					{
						clo = ele.clone();
						SubGraph(cloneRenderer).addElement(clo);
						cloneChildren(ele, clo);
					}
					i++;
				}
			}
			return;
		}
		
		/**
		 * 当位置变化或者大小变化的时候，重绘连线。 
		 * @param event
		 * 
		 */
		override protected function baseGeometryChanged(event:Event):void
		{
			super.baseGeometryChanged(event);
			invalidateLinkOfHierarchechy();
		}
		/**
		 * 添加状态的判断。 
		 * @return 
		 * 
		 */
		override protected function getCurrentSkinState():String{
			if(collapsed && showsCaret){
				return "collapsedAndShowsCaret";
			}else if(collapsed && !showsCaret){
				return "collapsed";
			}else if(collapsed && selected){
				return "collapsedSelected";
			}else if(collapsed && selected && showsCaret){
				return "collapsedSelectedAndShowsCaret";
			}
			return super.getCurrentSkinState();
		}
		/**
		 * 当graph被实例化的时候，赋值mxml内容。 
		 * @param partName
		 * @param instance
		 * 
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			if(instance == graph){
				if(mxmlContentChanged){
					graph.mxmlContent = _mxmlContent;
				}
			}
		}
		/**
		 * 当graph被实例化的时候，移除mxml内容。
		 * @param partName
		 * @param instance
		 * 
		 */
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partRemoved(partName, instance);
			if(instance == graph){
				if(mxmlContentChanged){
					graph.mxmlContent = [];
				}
			}
		}
	}//类结束
}//包结束