/***********************************************
 **** 版权声明处 **
 ****  为了方便阅读和维护，请严格遵守相关代码规范，谢谢   ****
 *******************************************/
package com.hjx.diagram
{
	/*******************************************
	 **** huangjixin,2013-3-29,上午8:44:56 **
	 **** 图形绘制，包括节点和连线。  **
	 *******************************************/
	import com.hjx.diagram.skin.DiagramSkin;
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.GraphScroller;
	import com.hjx.graphic.Node;
	import com.hjx.graphic.SubGraph;
	import com.hjx.graphic.graphlayout.GraphLayout;
	
	import flash.events.Event;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.HierarchicalData;
	import mx.collections.ICollectionView;
	import mx.collections.IHierarchicalData;
	import mx.collections.IViewCursor;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * 当渲染器焦点改变的时候派发。
	 * 
	 */
	[Event(name="caretChange", type="mx.events.PropertyChangeEvent")]
	/**
	 * 当渲染节点位移或者形变的时候派发。 
	 */
	[Event(name="elementGeometryChange", type="com.hjx.graphic.events.GraphEvent")]
	/**
	 * 当一个graph或者subGraph被添加到另外的一个graph的时候派发。 
	 */
	[Event(name="graphAdd", type="com.hjx.graphic.events.GraphEvent")]
	/**
	 * 当布局动画结束的时候派发。 
	 */
	[Event(name="graphLayoutEnd", type="com.hjx.graphic.events.GraphEvent")]
	/**
	 * 当布局动画开始的时候派发。 
	 */
	[Event(name="graphLayoutStart", type="com.hjx.graphic.events.GraphEvent")]
	/**
	 * 当一个graph或者subGraph被另外的一个graph移除的时候派发。 
	 */
	[Event(name="graphRemove", type="com.hjx.graphic.events.GraphEvent")]
	/**
	 * 当一个连线被添加到一个graph的时候派发。 
	 */
	[Event(name="linkAdd", type="com.hjx.graphic.events.GraphEvent")]
	/**
	 * 当一个连线被移除的时候派发。 
	 */
	[Event(name="linkRemove", type="com.hjx.graphic.events.GraphEvent")]
	/**
	 * 当一个节点被添加到一个graph的时候派发。 
	 */
	[Event(name="nodeAdd", type="com.hjx.graphic.events.GraphEvent")]
	/**
	 * 当一个分支关闭的时候派发。 
	 */
	[Event(name="nodeClose", type="com.hjx.diagram.events.DiagramEvent")]
	/**
	 * 当一个分支关闭的时候派发。 
	 */
	[Event(name="nodeOpen", type="com.hjx.diagram.events.DiagramEvent")]
	/**
	 * 当一个分支在打开或者关闭前派发。 
	 */
	[Event(name="nodeOpening", type="com.hjx.diagram.events.DiagramEvent")]
	/**
	 * 用户交互选择结果。 
	 */
	[Event(name="selectionChange", type="com.hjx.diagram.events.DiagramEvent")]
	/**
	 * 当一个节点的时候派发。 
	 */
	[Event(name="nodeMove", type="com.hjx.diagram.events.DiagramNodeMoveEvent")]
	/**
	 * 当滚动条缩放的时候派发。 
	 */
	[Event(name="zoomCommit", type="com.hjx.graphic.events.GraphScrollerEvent")]
	public class Diagram extends SkinnableComponent
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
		private var _selectionMode:String = "multiple";
		
		/**
		 * 默认css风格。 
		 */
		private var defaultCSSStyles:Object = {
			skinClass:DiagramSkin
		};
		
		private var _nodeLayout:GraphLayout;
		
		private var _automaticGraphLayout:Boolean = false;
		
		private var nodeDataProviderChanged:Boolean;
		
		private var _nodeDataProvider:Object;
		
		private var _nodeRenderer:IFactory;
		
		private var _nodeRendererFunction:Function;
		
		private var displayNodesOpen:Boolean;                     
		private var _xLocationField:String ="@x";
		private var _yLocationField:String ="@y"; 
		private var _labelField:String ="@label";
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// public 公有变量声明处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		[SkinPart(required="true")]
		public var graph:Graph;
		
		[SkinPart(required="true")]
		public var graphScroller:GraphScroller;
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 构造函数，初始化相关工作可以放在里面
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		public function Diagram()
		{
			super();
		}//构造函数结束
		
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// getter和setter函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		/**
		 * 显示字段，默认为@label,为xml设置. 
		 * @return 
		 * 
		 */
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		
		[Bindable]
		/**
		 * 横坐标字段，默认为@x 
		 */
		public function get xLocationField():String
		{
			return _xLocationField;
		}
		
		public function set xLocationField(value:String):void
		{
			_xLocationField = value;
		}
		/**
		 * 纵坐标字段，默认为@y。 
		 * @return 
		 * 
		 */
		public function get yLocationField():String
		{
			return _yLocationField;
		}
		
		public function set yLocationField(value:String):void
		{
			_yLocationField = value;
		}
		
		[Bindable(event="nodeDataProviderChange")]
		/**
		 * 节点数据源。
		 */
		public function get nodeDataProvider():Object
		{
			return _nodeDataProvider;
		}
		
		/**
		 * @private
		 */
		public function set nodeDataProvider(value:Object):void
		{
			if( _nodeDataProvider !== value)
			{
				_nodeDataProvider = value;
				dispatchEvent(new Event("nodeDataProviderChange"));
				if(!value is HierarchicalCollectionView){
					throw new Error("数据源有误，必须是HierarchicalCollectionView类型。");
				}
				
				nodeDataProviderChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * 从数据模型当中创建节点.
		 * 该函数有以下语法:<br>function rendererFunction(diagram:Diagram, item:Object):Node</br>
		 * <br>该函数优先级高于工厂属性</br>
		 */
		public function get nodeRendererFunction():Function
		{
			return _nodeRendererFunction;
		}
		
		/**
		 * @private
		 */
		public function set nodeRendererFunction(value:Function):void
		{
			_nodeRendererFunction = value;
		}
		
		[Bindable]
		/**
		 * 节点渲染器。 
		 */
		public function get nodeRenderer():IFactory
		{
			return _nodeRenderer;
		}
		
		/**
		 * @private
		 */
		public function set nodeRenderer(value:IFactory):void
		{
			_nodeRenderer = value;
		}
		
		
		[Bindable]
		/**
		 * 是否自动布局。
		 * @return 
		 * 
		 */
		public function get automaticGraphLayout():Boolean
		{
			return _automaticGraphLayout;
		}
		
		public function set automaticGraphLayout(value:Boolean):void
		{
			_automaticGraphLayout = value;
		}
		
		[Bindable]
		[Inspectable(enumeration="multiple,single",defaultValue="multiple")]
		/**
		 * 选中模式。 
		 */
		public function get selectionMode():String
		{
			return _selectionMode;
		}
		
		/**
		 * @private
		 */
		public function set selectionMode(value:String):void
		{
			_selectionMode = value;
		}
		
		[Bindable]
		/**
		 * 节点布局。 
		 */
		public function get nodeLayout():GraphLayout
		{
			return _nodeLayout;
		}
		
		/**
		 * @private
		 */
		public function set nodeLayout(value:GraphLayout):void
		{
			_nodeLayout = value;
		}
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// 相关事件响应函数和逻辑函数存放处
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		/**
		 * 创建节点 
		 * @return 
		 * 
		 */
		private function installNodes(nodeRoot:HierarchicalCollectionView,container:IVisualElementContainer):void{
			var cursor:IViewCursor= nodeRoot.createCursor();
			
			while (!cursor.afterLast)
			{
				var label:* = cursor.current[this.labelField];
				var x:* = cursor.current[this.xLocationField];
				var y:* = cursor.current[this.yLocationField];
				var node:Node;
				var subGraph:SubGraph;
				var hierarchicalCollectionView :HierarchicalCollectionView;
				if(cursor.current is XML){
					var xml:XML = cursor.current as XML;
					var localName:Object = XML(cursor.current).localName();
					var className:String = xml.localName();
					var ns:Namespace = xml.namespace();
					if(ns != null)
						className = ns.uri + "::" + className;
					
					if(localName){
						var objclass:Class = getDefinitionByName(className) as Class;
						var object:Object = new objclass();
						for each(var att:Object in xml.attributes()){
							try {
								var name:String = att.name();
								var defaultValue:Object = object[name];
								var value:Object = xml.attribute(name);
								if(value != null)
									object[name] = value;
							} catch(err:Error){}
						}
						
						container.addElement(object as IVisualElement);
						if(object is SubGraph){
							hierarchicalCollectionView = new HierarchicalCollectionView(new HierarchicalData(cursor.current));
							hierarchicalCollectionView.showRoot = nodeRoot.showRoot;
							installNodes(hierarchicalCollectionView,object as SubGraph);
						}
					}
				}else if(cursor.current is Object){
					var nodeType:Object = cursor.current["nodeType"];
					if(localName){
						if(localName == "node"){
							nodeRenderer = new ClassFactory(Node);
							node = nodeRenderer.newInstance() as Node;
							container.addElement(node);
							node.label = label;
							node.x = x;
							node.y = y;
						}else if(localName == "graph"){
							nodeRenderer = new ClassFactory(SubGraph);
							subGraph = nodeRenderer.newInstance() as SubGraph;
							container.addElement(subGraph);
							subGraph.label = label;
							subGraph.x = x;
							subGraph.y = y;
							
							hierarchicalCollectionView = new HierarchicalCollectionView(new HierarchicalData(cursor.current));
							hierarchicalCollectionView.showRoot = nodeRoot.showRoot;
							installNodes(hierarchicalCollectionView,subGraph.graph);
						}
					}
				}
				
				cursor.moveNext();
				/**/
			}
		}
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		// override 覆盖函数
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		
		override protected function commitProperties():void{
			super.commitProperties();
			if(nodeDataProviderChanged){
				nodeDataProviderChanged = false;
				if(graph){
					graph.removeAllElements();
				}
				installNodes(nodeDataProvider as HierarchicalCollectionView,this.graph);
			}
		}
		override public function stylesInitialized():void{
			super.stylesInitialized();
			for (var i:String in defaultCSSStyles) {
				if (getStyle (i) == undefined) {
					setStyle (i, defaultCSSStyles [i]);
				}
			}
		}
	}//类结束
}//包结束