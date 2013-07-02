package com.hjx.jbpm
{
	public class Action extends JbpmBase
	{
		private var _className:String;
		
		private var _ref_name:String;
		
		private var _expression:String;
		
		private var _accept_propagated_events:Boolean = true;
		
		private var _async:Boolean = false;
		
		private var _config_type:String;
		
		//////////// 因项目需要而加入的属性。
		
		private var _sendName:String="";
		
		private var _execType:String = "";
		
		private var _operationList:Vector.<Element> = new Vector.<Element>();
		
		private var _formFieldList:Vector.<Element> = new Vector.<Element>();
					
		public function Action()
		{
			super();
			className="";
			ref_name="";
			expression="";
			accept_propagated_events = true;
			async = false;
			_config_type="";
		}
		
		public function get formFieldList():Vector.<Element>
		{
			return _formFieldList;
		}

		public function set formFieldList(value:Vector.<Element>):void
		{
			_formFieldList = value;
		}

		public function get operationList():Vector.<Element>
		{
			return _operationList;
		}

		public function set operationList(value:Vector.<Element>):void
		{
			_operationList = value;
		}

		public function get execType():String
		{
			return _execType;
		}

		public function set execType(value:String):void
		{
			_execType = value;
		}

		public function get sendName():String
		{
			return _sendName;
		}

		public function set sendName(value:String):void
		{
			_sendName = value;
		}

		public function get async():Boolean
		{
			return _async;
		}

		public function set async(value:Boolean):void
		{
			_async = value;
		}

		[Inspectable(enumeration="field,bean,constructor,configuration-property")]
		public function get config_type():String
		{
			return _config_type;
		}

		public function set config_type(value:String):void
		{
			_config_type = value;
		}

		public function get accept_propagated_events():Boolean
		{
			return _accept_propagated_events;
		}

		public function set accept_propagated_events(value:Boolean):void
		{
			_accept_propagated_events = value;
		}

		public function get expression():String
		{
			return _expression;
		}

		public function set expression(value:String):void
		{
			_expression = value;
		}

		public function get ref_name():String
		{
			return _ref_name;
		}

		public function set ref_name(value:String):void
		{
			_ref_name = value;
		}

		/**
		 * 转换为描述文件的时候，要把该属性改成“class” 
		 * @return 
		 * 
		 */
		public function get className():String
		{
			return _className;
		}
		
		public function set className(value:String):void
		{
			_className = value;
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			if(this.className && this.className!=""){
				xml.@["class"] = className;			
			}
			if(this.expression && this.expression!=""){
				xml.@["expression"] = expression;			
			}
			if(this.ref_name && this.ref_name!=""){
				xml.@["ref-name"] = ref_name;		
			}
			if(this.accept_propagated_events && !this.accept_propagated_events){
				xml.@["accept-propagated-events"] = accept_propagated_events;	
			}
			if(this.config_type && this.config_type!=""){
				xml.@["config-type"] = config_type;			
			}
			
			if(this.sendName && this.sendName!=""){
				var sendNamexml:XML = new XML("<sendName"+">"+this.sendName+"</sendName>");
				xml.appendChild(sendNamexml);			
			}
			
			if(this.execType && this.execType!=""){
				var execTypexml:XML = new XML("<execType"+">"+this.execType+"</execType>");
				xml.appendChild(execTypexml);			
			}
			
			if(operationList.length>0){
				var operationListxml:XML = new XML("<operationList/>");
				for each (var ele:Element in operationList) 
				{
					operationListxml.appendChild(ele.toXml());
				}
				
				xml.appendChild(operationListxml);
			}
			
			if(formFieldList.length>0){
				var formFieldListxml:XML = new XML("<formFieldList/>");
				for each (ele in formFieldList) 
				{
					formFieldListxml.appendChild(ele.toXml());
				}
				
				xml.appendChild(formFieldListxml);
			}
			
			if(async){
				xml.@["async"] = async;
			}
			
			return xml;
		}
	}
}