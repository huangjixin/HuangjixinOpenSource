package com.hjx.graphic
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.utils.ObjectUtil;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 *  边饰类，可以继承。
	 */
	[Style(name="adornerClass", inherit="yes", type="Class")]
	
	
	/**
	 * 
	 */
	[SkinState("normal")]
	[SkinState("normalAndShowsCaret")]
	[SkinState("selected")]
	[SkinState("selectedAndShowsCaret")]
	/**
	 * 该类为所有可视化图形的基类，它继承自SkinnableComponent，所有显示在其上面的组件都必须继承自该类。
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Renderer extends SkinnableComponent
	{
		private var _data:Object = {};
		private var _resizable : Boolean = true;
		private var _selectable : Boolean = true;
		private var _selected : Boolean = false;
		private var _showsCaret : Boolean = false;
		private var _geometryChangedByLayout:Boolean = false;
		
		private var cloneRenderer:Renderer;
		
		public static var rendererProperties:Array;
		
		/**
		 * 构造函数结束。 
		 * 
		 */
		public function Renderer()
		{
			super();
		}
		
		[Bindable]
		public function get geometryChangedByLayout():Boolean
		{
			return _geometryChangedByLayout;
		}

		public function set geometryChangedByLayout(value:Boolean):void
		{
			if(_geometryChangedByLayout != value){
				_geometryChangedByLayout = value;
				if(value)
					invalidateProperties();
			}
		}

		[Bindable]
		final public function get data():Object
		{
			return _data;
		}

		final public function set data(value:Object):void
		{
			if(this._data != value){
				_data = value;
				
				dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
			}
		}

		[Bindable]
		/**
		 * 是否可选。 
		 */
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		/**
		 * @private
		 */
		public function set selectable(value:Boolean):void
		{
			if(this._selectable != value){
				_selectable = value;
			}
		}
		
		[Bindable]
		/**
		 *  
		 */
		final public function get showsCaret():Boolean
		{
			return _showsCaret;
		}

		/**
		 * @private
		 */
		final public function set showsCaret(value:Boolean):void
		{
			var oldVal:Boolean;
			var newVal:Boolean;
			if(this._showsCaret != value){
				oldVal = this._showsCaret;
				this._showsCaret = value;
				newVal = this._showsCaret;
				invalidateSkinState();
				if(oldVal != newVal){
					dispatchPropertyChangeEvent("showCaret",oldVal,newVal);
				}
			}
		}

		[Bindable]
		/**
		 * 是否被选中。 
		 */
		final public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * 加上selectable进行判断,此处的处理在判断皮肤的时候容易多了。
		 * @private
		 */
		final public function set selected(value:Boolean):void
		{
			var flag:Boolean;
			
			if(this._selected != value){
				flag = this._selected;
				if (!this.selectable){
					this._selected = false;
				}else{
					this._selected = value;
				}
				
				if(flag != this._selected){
					invalidateSkinState();
					dispatchPropertyChangeEvent("selected",flag,this._selected);
				}
			}
		}

		[Bindable]
		/**
		 * 是否可以放大缩小。 
		 */
		public function get resizable():Boolean
		{
			return _resizable;
		}

		/**
		 * @private
		 */
		public function set resizable(value:Boolean):void
		{
			_resizable = value;
			invalidateSkinState();
		}
		
		protected function onSkinChanged(event:Event):void
		{
			if(this.skin){
				this.skin.invalidateDisplayList();
			}
		}
		
		/**
		 * 根据ID获得皮肤元素。
		 * @param id 参数id为字符串，将通过id查询皮肤元素。
		 * @return 
		 * 
		 */
		protected function getSkinElementById(id:String):IVisualElement
		{
			if(!skin)
				return null;
			if(skin is IVisualElementContainer)
				return getSkinElementByIdImpl(IVisualElementContainer(skin),id);
			return null;
		}//getSkinElementById结束
		
		/**
		 * 根据ID获得皮肤元素的具体实现方法,遍历皮肤容器（请注意学习相关技巧）。 
		 * @param id
		 * @return 
		 * 
		 */
		private function getSkinElementByIdImpl(iVisualContainer:IVisualElementContainer,id:String):IVisualElement
		{
			var ele:IVisualElement;
			var eleNum:int = 0;
			var length:int = iVisualContainer.numElements;
			while(eleNum < length){
				ele = iVisualContainer.getElementAt(eleNum);
				if(ele["id"] && ele["id"]==id)
					return ele;
				
				if(ele is IVisualElementContainer)
					return getSkinElementByIdImpl(IVisualElementContainer(ele),id);
				
			}
			return null;
		}
		
		/**
		 * 该函数提供了克隆一个Renderer组件。克隆属性，克隆孩子。<br>克隆属性的时候，不克隆属性组件引用，克隆基本类型，以及数组。</br> 
		 * @return 
		 * 
		 */
		public function clone():Renderer{
			var className:String = getQualifiedClassName(this);
			var RendererObject:Object = getDefinitionByName(className);
			var cloneRenderer:Renderer  = new RendererObject();
			
			cloneProperties(this,cloneRenderer);
			cloneStyle(this,cloneRenderer);
			this.cloneRenderer = cloneRenderer;
			return cloneRenderer;
		}
		
		protected function cloneStyle(renderer:Renderer, cloneRenderer:Renderer):void
		{
			cloneRenderer.setStyle("adornerClass",renderer.getStyle("adornerClass"));
		}
		/**
		 * 克隆属性。 
		 * @param renderer
		 * @param cloneRenderer
		 * 
		 */
		protected function cloneProperties(renderer:Renderer, cloneRenderer:Renderer):void
		{
			var prop:Object;
			if (!(renderer == null) && !(cloneRenderer == null)) 
			{
				//克隆x和y坐标。
				setX(cloneRenderer, getX(renderer));
				setY(cloneRenderer, getY(renderer));
				
				cloneRenderer.explicitWidth = renderer.explicitWidth;
				cloneRenderer.explicitHeight = renderer.explicitHeight;
				cloneRenderer.percentWidth = renderer.percentWidth;
				cloneRenderer.percentHeight = renderer.percentHeight;
				cloneRenderer.explicitMinWidth = renderer.explicitMinWidth;
				cloneRenderer.explicitMinHeight = renderer.explicitMinHeight;
				cloneRenderer.explicitMaxWidth = renderer.explicitMaxWidth;
				cloneRenderer.explicitMaxHeight = renderer.explicitMaxHeight;
			}
			
			if (rendererProperties == null) 
			{
				rendererProperties = new Array();
				var properties:Array = ObjectUtil.getClassInfo(new Renderer())["properties"];
				
				for each ( prop in properties) 
				{
					rendererProperties.push(prop.localName);
				}
			}
			var options:Object;
			(options = new Object())["includeReadOnly"] = false;
			var classInfo:Object = ObjectUtil.getClassInfo(renderer, rendererProperties, options);
			var cloneProperties:Array = classInfo["properties"];
			
			for each (prop in cloneProperties) 
			{
				var p:Object = renderer[prop.localName];
				if(p is int || p is Number || p is String || p is Boolean ){
					cloneRenderer[prop.localName] = p;
				}else if(p is Point){
					cloneRenderer[prop.localName] = Point(p).clone();
				}/*else if(p is Object){
					cloneRenderer[prop.localName] = ObjectUtil.clone(p);
				}*/
			}
			
		}
		
		public function getX(renderer:Renderer):Number
		{
			var result:Number=NaN;
			if (renderer.left is Number) 
			{
				result = Number(renderer.left);
				if (!isNaN(result)) 
				{
					return result;
				}
			}
			return renderer.x;
		}
		
		public function setX(renderer:Renderer, x:Number):void
		{
			if (renderer.left is Number && !isNaN(Number(renderer.left))) 
			{
				renderer.left = x;
			}
			else 
			{
				renderer.x = x;
			}
			return;
		}
		
		public function getY(renderer:Renderer):Number
		{
			var result:Number=NaN;
			if (renderer.top is Number) 
			{
				result = Number(renderer.top);
				if (!isNaN(result)) 
				{
					return result;
				}
			}
			return renderer.y;
		}
		
		public function setY(renderer:Renderer, y:Number):void
		{
			if (renderer.top is Number && !isNaN(Number(renderer.top))) 
			{
				renderer.top = y;
			}
			else 
			{
				renderer.y = y;
			}
			return;
		}
		/**
		 * 获取当前的皮肤状态。 
		 * @return 
		 * 
		 */
		override protected function getCurrentSkinState():String
		{
			if(selected){
				if(showsCaret){
					return "selectedAndShowsCaret";
				}else{
					return "selected";
				}
			}else{
				if(showsCaret){
					return "normalAndShowsCaret";
				}else{
					return "normal";
				}
			}
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
			this.geometryChangedByLayout = false;
		}
	}
}