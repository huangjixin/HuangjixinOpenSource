/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.effects
{
	import com.lafabrick.uigfx.effects.supportclasses.AnimateComplexPathInstance;
	
	import mx.effects.IEffectInstance;
	
	import spark.effects.Animate;

	/**
	 *  The AnimateComplePath effect animates the <code>data</code> property of a UIGFX ComplexPath primitive.
	 *  
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:AnimateComplexPath&gt;</code> tag
	 *  inherits the tag attributes of its superclass,
	 *  and adds the following tag attributes:</p>
	 *  
	 *  <pre>
	 *  &lt;s:AnimateComplexPath 
	 *    id="ID"
	 *    dataTo="[UIGFX data path string]"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see com.lafabrick.uigfx.effects.supportclasses.AnimateComplexPathInstance
	 */
	public class AnimateComplexPath extends Animate
	{
		/**
		 *  Constructor. 
		 *
		 *  @param target The Object to animate with this effect.  
		 */
		public function AnimateComplexPath(target:Object=null)
		{
			super(target);
			instanceClass = AnimateComplexPathInstance;
		}
		
		/**
		 * Define the target data path (UIGFX type) of the aniation. 
		 * @see com.lafabrick.uigfx.primitives.ComplexPath#data
		 */
		public var dataTo : String;
		
		/**
		 * @private
		 */
		override protected function initInstance(instance:IEffectInstance):void
		{
			super.initInstance(instance);
			
			var complexInstance:AnimateComplexPathInstance = AnimateComplexPathInstance(instance);
			
			complexInstance.dataTo = dataTo;
		}
		/**
		 * @private
		 */
		override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object):void
		{			
			// Nothing : in Instance
		}
		/**
		 * @private
		 */
		override protected function getValueFromTarget(target:Object, property:String):*
		{
			// Nothing : in Instance
		}
		
	}
}