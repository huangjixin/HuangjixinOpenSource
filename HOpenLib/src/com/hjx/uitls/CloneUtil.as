package  com.hjx.uitls
{
	
	import com.hjx.graphic.Renderer;
	import com.hjx.graphic.SubGraph;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.UIComponent;
	import mx.utils.ObjectUtil;
	
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;

	/**
	 * 克隆组件函数。 
	 * @author huangjixin
	 * 
	 */
	public class CloneUtil
	{
		internal static var rendererProperties:Array=null;
		
		public function CloneUtil()
		{
		}
		
		public static function cloneInternal(renderer:Renderer):Renderer
		{
			var cloneRenderer:Renderer = cloneRendererStatic(renderer);
			cloneChildrenStatic(renderer, cloneRenderer);
//			setX(loc1, 0);
//			setY(loc1, 0);
			return cloneRenderer;
		}
		
		internal static function cloneRendererStatic(renderer:Renderer):Renderer
		{
			var rendererClass:Object=null;
			var cloneRenderer:Renderer=null;
			try 
			{
				var className:String = getQualifiedClassName(renderer);
				rendererClass = getDefinitionByName(className);
				if(rendererClass) 
				{
					cloneRenderer = new rendererClass() as Renderer;
					cloneProperties(renderer, cloneRenderer);
					return cloneRenderer;
				}
			}
			catch (err:Error)
			{
			};
			return null;
		}
		
		internal static function cloneProperties(renderer:Renderer, cloneRenderer:Renderer):void
		{
			var prop:QName;
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
				var properties:Array = ObjectUtil.getClassInfo(new SkinnableComponent())["properties"];
				
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
				trace(prop.localName);
				var p:Object = renderer[prop.localName];
				cloneRenderer[prop.localName] = p;
			}
			return;
		}
		
		internal static function cloneChildrenStatic(renderer:Renderer, cloneRenderer:Renderer):void
		{
			var length:int=0;
			var ele:Renderer=null;
			var clone:Renderer=null;
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
						clone = cloneRendererStatic(ele);
						SubGraph(cloneRenderer).addElement(clone);
						cloneChildrenStatic(ele, clone);
					}
					i++;
				}
			}
			return;
		}
		
		static function getX(renderer:Renderer):Number
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
		
		static function setX(renderer:Renderer, x:Number):void
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
		
		static function getY(renderer:Renderer):Number
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
		
		static function setY(renderer:Renderer, y:Number):void
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
	}
}