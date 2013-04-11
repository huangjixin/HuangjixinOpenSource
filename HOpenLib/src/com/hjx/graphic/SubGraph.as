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
	import com.hjx.graphic.skin.SubGraphSkin;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import spark.components.Group;
	
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
		private var _mxmlContent:Array;
		
		private var defaultCSSStyles:Object = {
			skinClass:SubGraphSkin
		};
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		[SkinPart(required="true")]
		public var graph:Graph;
		
		/**
		 * 收缩状态宽度
		 */
		[Bindable]
		public var collapsedWidth :Number;
		/**
		 *收缩状态高度 
		 */
		[Bindable]
		public var collapsedHeight :Number;
		/**
		 * 张开状态宽度 
		 */
		[Bindable]
		public var expandedWidth :Number;
		/**
		 * 张开状态高度 
		 */
		[Bindable]
		public var expandedHeight :Number;
		
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
			_collapsed = value;
			invalidateSkinState();
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
		
		public function addElement(element:IVisualElement):IVisualElement
		{
			return graph.addElement(element);
		}
		
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			return graph.addElementAt(element, index);
		}
		
		public function removeElement(element:IVisualElement):IVisualElement
		{
			return graph.removeElement(element);
		}
		
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
		
		
		public function collapseAnimationStart():void{
		
		}
		
		public function collapseAnimationEnd():void{
		
		}
		
		public function expandAnimationStart():void{
		
		}
		
		public function expandAnimationEnd():void{
		
		}
		
		/**
		 *Performs the graph layout on the parent of the subgraph if graph layout is automatic. This method is called automatically when the subgraph is expanded or collapsed. It is public so that it can be called from custom subgraph skins, at the end of an expand/collapse animation. 
		 * 
		 */
		public function performLayoutOnParent():void{
		
		}
		
		/**
		 *Performs the graph layouts attached to the subgraph content. Note that the graph layout is actually performed during a later screen update.

The method actually only executes the layouts if the graph layout is invalid. The graph layout can be invalid either because the content of the graph has changed, or because the parameters of the layout have changed, or because the layout has been explicitely triggered by a call to performGraphLayout().

If the layout is configured to be performed automatically, there is no need to call this method. The layout will be performed whenever there is a change in the graph model. 
		 * @param traverse - 遍历
		 * 
		 */
		public function performGraphLayout(traverse:Boolean = false):void{
		
		}
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// override 覆盖函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
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
		override protected function partRemoved(partName:String, instance:Object):void{
			super.partRemoved(partName, instance);
			if(instance == graph){
				if(mxmlContentChanged){
					graph.mxmlContent = [];
				}
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
		} 
		override public function stylesInitialized():void{
			super.stylesInitialized();
			for (var i:String in defaultCSSStyles) {
				setStyle (i, defaultCSSStyles [i]);
			}
		}
	}//类结束
}//包结束