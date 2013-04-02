package com.hjx.graphic
{
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.ClassFactory;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * 该类为所有可视化图形的基类。
	 * @author huangjixin
	 * 
	 */
	[Style(name="adornerClass", inherit="yes", type="Class")]
	
	[SkinState("normal")]
	[SkinState("normalAndShowsCaret")]
	[SkinState("selected")]
	[SkinState("selectedAndShowsCaret")]
	public class Renderer extends SkinnableComponent
	{
		
		private var _data:Object = null;
		private var _resizable : Boolean = true;
		private var _selectable : Boolean = true;
		private var _selected : Boolean = false;
		private var _showsCaret : Boolean = false;
		
		public function Renderer()
		{
			super();
			
			addEventListener("skinChanged",onSkinChanged);
		}
		
		[Bindable]
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		[Bindable]
		/**
		 *  
		 */
		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}

		/**
		 * @private
		 */
		public function set showsCaret(value:Boolean):void
		{
			_showsCaret = value;
			invalidateSkinState();
		}

		[Bindable]
		/**
		 * 是否被选中。 
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			invalidateSkinState();
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
			_selectable = value;
			invalidateSkinState();
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
		
		override protected function getCurrentSkinState():String
		{
			if(selectable){
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
			}else{
				if(showsCaret){
					return "normalAndShowsCaret";
				}else{
					return "normal";
				}
			}
			return super.getCurrentSkinState();
		}
		
		
		public function clone():Renderer{
			var object:Object = this.descriptor.properties;
			var className:String=getQualifiedClassName(this);
			var ClassName:Class=getDefinitionByName(className) as Class;
			
			var classFactory:ClassFactory = new ClassFactory(ClassName);
			
			var render:Renderer = classFactory.newInstance();
			
			var skinClass:* = this.getStyle("skinClass");
			render.setStyle("skinClass",this.getStyle("skinClass"));
			return render;
		}
		
		
	}
}