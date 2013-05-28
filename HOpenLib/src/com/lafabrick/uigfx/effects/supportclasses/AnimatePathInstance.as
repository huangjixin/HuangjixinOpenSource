/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.effects.supportclasses
{
	import com.lafabrick.uigfx.effects.animation.ComplexAnimation;
	import com.lafabrick.uigfx.effects.animation.ComplexMotionPath;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.mx_internal;
	import mx.events.EffectEvent;
	
	import spark.effects.animation.Animation;
	import spark.effects.animation.Keyframe;
	import spark.effects.animation.MotionPath;
	import spark.effects.supportClasses.AnimateInstance;
	import spark.primitives.Path;
	
	use namespace mx_internal;
	
	public class AnimatePathInstance extends AnimateInstance
	{
		/**
		 *  Constructor. 
		 *
		 *  @param target The Object to animate with this effect.  
		 */
		public function AnimatePathInstance(target:Object)
		{
			super(target);
		}
		
		/**
		 * Define the target data path (SVG type, or UIGFX type under the AnimateComplexPathInstance class) of the aniation. 
		 */
		public var dataTo : String;
		
		/**
		 * @private
		 */
		protected var reverseAnimation : Boolean;
		/**
		 * @private
		 */
		protected var seekTime:Number = 0;
		/**
		 * @private
		 */
		protected var complexAnimation : ComplexAnimation;
		/**
		 * @private
		 */
		override public function reverse():void
		{
			super.reverse();
			
			if (complexAnimation)
				complexAnimation.reverse();
			
			reverseAnimation = !reverseAnimation;
		}
		/**
		 * @private
		 */
		override mx_internal function set playReversed(value:Boolean):void
		{
			super.playReversed = value;
			reverseAnimation = value;
		}
		/**
		 * @private
		 */
		override public function get playheadTime():Number 
		{
			return complexAnimation ? complexAnimation.playheadTime : seekTime;
		}
		/**
		 * @private
		 */
		override public function set playheadTime(value:Number):void
		{
			if (complexAnimation)
				complexAnimation.playheadTime = value;
			seekTime = value;
		} 

		/**
		 * @private
		 */
		override public function pause():void
		{
			super.pause();
			
			if (complexAnimation)
				complexAnimation.pause();
		}
		
		/**
		 *  @private
		 */
		override public function stop():void
		{
			super.stop();
			
			if (complexAnimation)
				complexAnimation.stop();
		}   
		
		/**
		 *  @private
		 */
		override public function resume():void
		{
			super.resume();
			
			if (complexAnimation)
				complexAnimation.resume();
		}
		/**
		 * @private
		 */
		override public function play():void
		{
			if( target is Path ) {
				
				motionPaths = new Vector.<MotionPath>();
				
				var pathArray : Array = (target as Path).data.split(" ");
				var toPathArray : Array = dataTo.split(" ");
				
				var pMotionPath : ComplexMotionPath;
				
				var counterC : Number = 0;
				var counterP : Number = 0;
				
				for ( ; counterP < pathArray.length; counterP++ ) {
					
					if( !isNaN( Number(pathArray[counterP]) ) ) {
						
						pMotionPath = new ComplexMotionPath( null, null, 0, counterP );
						pMotionPath.keyframes =  new <Keyframe>[	new Keyframe(0, pathArray[counterP]), 
																	new Keyframe(duration, toPathArray[counterP]) ];
					
						motionPaths.push( pMotionPath );
					}
				}
				
				startAnimation();
			}
		}
		/**
		 * @private
		 */
		protected function startAnimation() : void
		{
			playCount++;
			
			dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
			
			if (target && (target is IEventDispatcher)) {
				target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
			}
			
			complexAnimation = new ComplexAnimation(duration);
			complexAnimation.animationTarget = this;
			complexAnimation.motionPaths = motionPaths;
			
			if (seekTime > 0)
				complexAnimation.playheadTime = seekTime;
			if (reverseAnimation)
				complexAnimation.playReversed = true;
			complexAnimation.interpolator = interpolator;
			complexAnimation.repeatCount = repeatCount;
			complexAnimation.repeatDelay = repeatDelay;
			complexAnimation.repeatBehavior = repeatBehavior;
			complexAnimation.easer = easer;
			complexAnimation.startDelay = startDelay;
			
			complexAnimation.play();
		}
		/**
		 * @private
		 */
		override public function end():void
		{
			
			// Jump to the end of the animation.
			if (complexAnimation)
			{
				complexAnimation.end();
				complexAnimation = null;
			}
			
			super.end();
		}
		/**
		 * @private
		 */
		override public function animationStart(animation:Animation):void
		{
			// nothing??
		}
		/**
		 * @private
		 */
		protected function applyComplexValues(anim:ComplexAnimation):void
		{
			var pathArray : Array = (target as Path).data.split(" ");
			var countMotion : int = 0;
			var countPath : int = 0;
			
			for (; countMotion < motionPaths.length-1; ++countMotion) {
				pathArray[( motionPaths[countMotion] as ComplexMotionPath).pointIndex] = Math.round(anim.currentValue[countMotion].value);
			}
			var newPath : String = "";
			for (; countPath < pathArray.length; countPath++) {
				newPath += pathArray[countPath];
				if( countPath<pathArray.length-1 ) {
					newPath += " ";
				}
			}
			
			if( target is Path ) {
				target.data = newPath;
				(target as Path).invalidateDisplayList();
			}
			
			
		}
		/**
		 * 
		 */
		public function complexAnimationStart(animation:ComplexAnimation):void
		{
			// 
		}
		/**
		 * 
		 */
		public function complexAnimationUpdate(animation:ComplexAnimation):void
		{
			applyComplexValues(animation);
			var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_UPDATE);
			event.effectInstance = this;
			dispatchEvent(event);
			
		}
		/**
		 * 
		 */
		public function complexAnimationRepeat(animation:ComplexAnimation):void
		{
			var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_REPEAT);
			event.effectInstance = this;
			dispatchEvent(event);
		}    
		/**
		 * 
		 */
		public function complexAnimationEnd(animation:ComplexAnimation):void
		{
			finishEffect();
		}
		/**
		 * 
		 */
		public function complexAnimationStop(animation:ComplexAnimation):void
		{
			//
		}
		/**
		 * @private
		 */
		override protected function setValue(property:String, value:Object):void
		{
			// nothing : replace by setMotionValue
		}
		
		/**
		 * @private
		 */
		override protected function getCurrentValue(property:String):*
		{
			// nothing : replace by getCurrentMotionValue
		}
	}
}