/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.effects.supportclasses
{
	import com.lafabrick.uigfx.effects.animation.ComplexAnimation;
	import com.lafabrick.uigfx.effects.animation.ComplexMotionPath;
	import com.lafabrick.uigfx.element.Contour;
	import com.lafabrick.uigfx.geom.ComplexPoint;
	import com.lafabrick.uigfx.primitives.ComplexPath;
	import com.lafabrick.uigfx.utils.DataParser;
	
	import mx.core.mx_internal;
	
	import spark.effects.animation.Keyframe;
	import spark.effects.animation.MotionPath;
	
	use namespace mx_internal;
	
	public class AnimateComplexPathInstance extends AnimatePathInstance
	{
		/**
		 *  Constructor. 
		 *
		 *  @param target The Object to animate with this effect.  
		 */
		public function AnimateComplexPathInstance(target:Object)
		{
			super(target);
		}
		/**
		 * @private
		 */
		override public function play():void
		{
			if( target is ComplexPath ) {
				
				motionPaths = new Vector.<MotionPath>();
				
				var toVector : Vector.<Contour> = DataParser.parseComplexData( dataTo );
				
				var targetPoint : ComplexPoint;
				
				var hTargetConstraint : String;
				var vTargetConstraint : String;
				
				var hMotionPath : ComplexMotionPath;
				var vMotionPath : ComplexMotionPath;
				
				var hKeyframes : Vector.<Keyframe>;
				var vKeyframes : Vector.<Keyframe>;
				
				var offsetMotionPath : ComplexMotionPath;
				
				var offsetKeyframes : Vector.<Keyframe>;
				
				var counterC : Number = 0;
				var counterP : Number = 0;
				
				for ( ; counterC < (target as ComplexPath).contours.length; counterC++ ) {
					counterP = 0;
					for ( ; counterP < (target as ComplexPath).contours[counterC].points.length; counterP++ ) {
					
						targetPoint = (target as ComplexPath).contours[counterC].points[counterP];
						
						hTargetConstraint = targetPoint.getHorizontalConstraint();
						vTargetConstraint = targetPoint.getVerticalConstraint();
						
						hMotionPath = new ComplexMotionPath( hTargetConstraint, targetPoint, counterC, counterP );
						vMotionPath = new ComplexMotionPath( vTargetConstraint, targetPoint, counterC, counterP );
						
						hKeyframes =  new <Keyframe>[	new Keyframe(0, targetPoint[hTargetConstraint]), 
														new Keyframe(duration, toVector[counterC].points[counterP][hTargetConstraint] | 0) ]; 
						
						vKeyframes =  new <Keyframe>[	new Keyframe(0, targetPoint[vTargetConstraint]), 
														new Keyframe(duration, toVector[counterC].points[counterP][vTargetConstraint] | 0) ]; 
						
						hMotionPath.keyframes = hKeyframes;
						vMotionPath.keyframes = vKeyframes;
						
						motionPaths.push( hMotionPath );
						motionPaths.push( vMotionPath );
						
						offsetMotionPath = new ComplexMotionPath( "nextAnchorOffsetX", targetPoint, counterC, counterP );
						offsetKeyframes =  new <Keyframe>[	new Keyframe(0, targetPoint.nextAnchorOffsetX), 
															new Keyframe(duration, toVector[counterC].points[counterP]["nextAnchorOffsetX"] | 0) ]; 
						offsetMotionPath.keyframes = offsetKeyframes;
						motionPaths.push( offsetMotionPath );
					
						offsetMotionPath = new ComplexMotionPath( "nextAnchorOffsetY", targetPoint, counterC, counterP );
						offsetKeyframes =  new <Keyframe>[	new Keyframe(0, targetPoint.nextAnchorOffsetY), 
															new Keyframe(duration, toVector[counterC].points[counterP]["nextAnchorOffsetY"] | 0) ]; 
						offsetMotionPath.keyframes = offsetKeyframes;
						motionPaths.push( offsetMotionPath );
					
						offsetMotionPath = new ComplexMotionPath( "prevAnchorOffsetX", targetPoint, counterC, counterP );
						offsetKeyframes =  new <Keyframe>[	new Keyframe(0, targetPoint.prevAnchorOffsetX), 
															new Keyframe(duration, toVector[counterC].points[counterP]["prevAnchorOffsetX"] | 0) ]; 
						offsetMotionPath.keyframes = offsetKeyframes;
						motionPaths.push( offsetMotionPath );
					
						offsetMotionPath = new ComplexMotionPath( "prevAnchorOffsetY", targetPoint, counterC, counterP );
						offsetKeyframes =  new <Keyframe>[	new Keyframe(0, targetPoint.prevAnchorOffsetY), 
															new Keyframe(duration, toVector[counterC].points[counterP]["prevAnchorOffsetY"] | 0) ];
						offsetMotionPath.keyframes = offsetKeyframes;
						motionPaths.push( offsetMotionPath );
					}
				}
				
				startAnimation();
			}
		}
		
		override protected function applyComplexValues(anim:ComplexAnimation):void
		{
			for (var i:int = 0; i < motionPaths.length; ++i) {
				var potarget : Object = (motionPaths[i] as ComplexMotionPath).targetPoint;
				var prop:String = motionPaths[i].property;
				
				setMotionValue(potarget, prop, anim.currentValue[i].value);
			}
			
			if( target is ComplexPath ) {
				(target as ComplexPath).invalidateDisplayList();
			}
		}
		
		protected function setMotionValue( targetPoint : Object, property:String, value:Object ) : void
		{
			targetPoint[property] = value;
		}
	}
}