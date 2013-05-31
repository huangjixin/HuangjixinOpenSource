package bpm.editor
{
	import bpm.graphic.Renderer;
	
	import mx.utils.ObjectUtil;

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
//			cloneChildrenStatic(arg1, loc1, null);
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
				if ((rendererClass = flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName(renderer)) as Class) != null) 
				{
					cloneRenderer = Renderer(new rendererClass());
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