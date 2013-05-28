/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.effects
{
	import com.lafabrick.uigfx.effects.supportclasses.AnimatePathInstance;
	
	import mx.effects.IEffectInstance;
	
	import spark.effects.Animate;

	/**
	 *  The AnimatePath effect animates the <code>data</code> property of a Path primitive.
	 *  
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:AnimatePath&gt;</code> tag
	 *  inherits the tag attributes of its superclass,
	 *  and adds the following tag attributes:</p>
	 *  
	 *  <pre>
	 *  &lt;s:AnimatePath 
	 *    id="ID"
	 *    dataTo="[SVG data path string]"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see com.lafabrick.uigfx.effects.supportclasses.AnimatePathInstance
	 */
	public class AnimatePath extends Animate
	{
		/**
		 *  Constructor. 
		 *
		 *  @param target The Object to animate with this effect.  
		 */
		public function AnimatePath(target:Object=null)
		{
			super(target);
			instanceClass = AnimatePathInstance;
		}
		
		/**
		 * Define the target data path (SVG type) of the aniation. 
		 */
		public var dataTo : String;
		/**
		 * @private
		 */
		override protected function initInstance(instance:IEffectInstance):void
		{
			super.initInstance(instance);
			
			var complexInstance:AnimatePathInstance = AnimatePathInstance(instance);
			
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