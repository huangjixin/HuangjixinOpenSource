/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.effects.animation
{
	import com.lafabrick.uigfx.effects.supportclasses.AnimatePathInstance;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.mx_internal;
	import mx.events.EffectEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import spark.effects.animation.Keyframe;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.RepeatBehavior;
	import spark.effects.easing.IEaser;
	import spark.effects.easing.Linear;
	import spark.effects.easing.Sine;
	import spark.effects.interpolation.IInterpolator;
	
	use namespace mx_internal;
	
	[DefaultProperty("motionPaths")]
	
	[ResourceBundle("sparkEffects")]
	
	public final class ComplexAnimation
	{
		private static const TIMER_RESOLUTION:Number = 10;
		
		public function ComplexAnimation(duration:Number = 500)
		{
			this.duration = duration;
		}
		
		private static var intervalTime:Number = NaN;
		
		private static var activeAnimations:Vector.<ComplexAnimation> = new Vector.<ComplexAnimation>;
		private static var timer:Timer = null;
		
		private static var linearEaser:IEaser;
		
		private var id:int = -1;
		private var _doSeek:Boolean = false;
		private var _isPlaying:Boolean = false;
		private var _doReverse:Boolean = false;
		private var _invertValues:Boolean = false;
		
		private var startTime:Number;
		private var started:Boolean = false;
		
		private var cycleStartTime:Number;
		
		private var delayTime:Number = -1;
		private static var defaultEaser:IEaser = new Sine(.5); 
		private static var delayedStartAnims:Vector.<ComplexAnimation> = new Vector.<ComplexAnimation>();
		private static var delayedStartTimes:Dictionary = new Dictionary();
		
		private var resourceManager:IResourceManager = ResourceManager.getInstance();
		
		public var currentValue:Array = new Array();
		
		public var motionPaths:Vector.<MotionPath>;
		
		private var _animationTarget:AnimatePathInstance = null;
		
		public function get animationTarget():AnimatePathInstance
		{
			return _animationTarget;
		}
		public function set animationTarget(value:AnimatePathInstance):void
		{
			_animationTarget = value;
		}
		
		private var _playheadTime:Number;
		
		[Inspectable(minValue="0.0")]
		
		public function get playheadTime():Number
		{
			return _playheadTime + startDelay;
		}
		public function set playheadTime(value:Number):void
		{
			seek(value, true);
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		[Inspectable(minValue="0.0")]
		
		public var duration:Number = 500;
		
		private var _repeatBehavior:String = RepeatBehavior.LOOP;
		
		public function get repeatBehavior():String
		{
			return _repeatBehavior;
		}
		public function set repeatBehavior(value:String):void
		{
			_repeatBehavior = value;
		}
		
		private var _repeatCount:int = 1;
		
		[Inspectable(minValue="0")]
		
		public function set repeatCount(value:int):void
		{
			_repeatCount = value;
		}
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		private var _repeatDelay:Number = 0;
		
		[Inspectable(minValue="0.0")]
		
		public function set repeatDelay(value:Number):void
		{
			_repeatDelay = value;
		}
		public function get repeatDelay():Number
		{
			return _repeatDelay;
		}
		
		private var _startDelay:Number = 0;
		
		[Inspectable(minValue="0.0")]
		
		public function set startDelay(value:Number):void
		{
			_startDelay = value;
		}
		public function get startDelay():Number
		{
			return _startDelay;
		}
		
		public var interpolator:IInterpolator = null;
		
		private var _cycleTime:Number = 0;

		public function get cycleTime():Number
		{
			return _cycleTime;
		}
		
		private var _cycleFraction:Number;
		
		public function get cycleFraction():Number
		{
			return _cycleFraction;
		}
		
		private var _easer:IEaser = defaultEaser;
		
		public function get easer():IEaser
		{
			return _easer;
		}
		/**
		 *  @private
		 */
		public function set easer(value:IEaser):void
		{
			if (!value) {
				if (!linearEaser)
					linearEaser = new Linear();
				value = linearEaser;
			}
			_easer = value;
		}
		
		public function get playReversed():Boolean
		{
			return _invertValues;
		}
		/**
		 *  @private
		 */
		public function set playReversed(value:Boolean):void
		{
			if (_isPlaying) {
				if (_invertValues != value) {
					_invertValues = value;
					seek(duration - _cycleTime, true);
				}
			}
			_doReverse = value;
		}
		
		private static function addAnimation(animation:ComplexAnimation):void
		{
			if (animation.motionPaths && animation.motionPaths.length > 0 &&
				animation.motionPaths[0] &&
				(animation.motionPaths[0].property == "width" ||
					animation.motionPaths[0].property == "height")) {
				activeAnimations.splice(0, 0, animation);
				animation.id = 0;
				for (var i:int = 1; i < activeAnimations.length; ++i)
					ComplexAnimation(activeAnimations[i]).id = i;
			}
			else {
				animation.id = activeAnimations.length;
				activeAnimations.push(animation);
			}
			
			if (!timer) {
				Timeline.pulse();
				timer = new Timer(TIMER_RESOLUTION);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
			}
			
			intervalTime = Timeline.currentTime;
			
			animation.cycleStartTime = intervalTime;
		}
		
		private static function removeAnimationAt(index:int):void
		{
			if (index >= 0 && index < activeAnimations.length) {
				activeAnimations.splice(index, 1);
				
				var n:int = activeAnimations.length;
				for (var i:int = index; i < n; i++) {
					var curAnimation:ComplexAnimation = ComplexAnimation(activeAnimations[i]);
					curAnimation.id--;
				}
			}
			if (timer && activeAnimations.length == 0 && delayedStartAnims.length == 0) {
				intervalTime = NaN;
				timer.reset();
				timer = null;
			}
		}
		
		/**
		 *  @private
		 */
		private static function removeAnimation(animation:ComplexAnimation):void
		{
			removeAnimationAt(animation.id);
		}
		
		private static function timerHandler(event:TimerEvent):void
		{
			var oldTime:Number = intervalTime;
			intervalTime = Timeline.pulse();
			
			var n:int = activeAnimations.length;
			var i:int = 0;
			
			while (i < activeAnimations.length) {
				var incrementIndex:Boolean = true;
				var animation:ComplexAnimation = ComplexAnimation(activeAnimations[i]);
				if (animation)
					incrementIndex = !animation.doInterval();
				if (incrementIndex)
					++i;
			}
			
			while (delayedStartAnims.length > 0) {
				var anim:ComplexAnimation = ComplexAnimation(delayedStartAnims[0]);
				var animStartTime:Number = delayedStartTimes[anim];
				if (animStartTime < Timeline.currentTime)
					anim.start();
				else
					break;
			}
			event.updateAfterEvent();
		}
		
		private function doInterval():Boolean
		{
			var animationEnded:Boolean = false;
			var repeated:Boolean = false;
			
			if (_isPlaying || _doSeek) {
				
				var currentTime:Number = intervalTime - cycleStartTime;
				_playheadTime = intervalTime - startTime;
				if (currentTime >= duration) { 
					var numRepeats:int = 2;
					if ((duration + repeatDelay) > 0)
						numRepeats += (_playheadTime - duration) / (duration + repeatDelay);
					if (repeatCount == 0 || numRepeats <= repeatCount) {
						if (repeatDelay == 0) {
							_cycleTime = currentTime % duration;
							cycleStartTime = intervalTime - _cycleTime;
							currentTime = _cycleTime;                        
							if (repeatBehavior == RepeatBehavior.REVERSE)
								_invertValues = !_invertValues;
							repeated = true;
						}
						else {
							if (_doSeek) {
								_cycleTime = currentTime % (duration + repeatDelay);
								if (_cycleTime > duration)
									_cycleTime = duration; // must be in repeatDelay phase
								calculateValue(_cycleTime);
								sendUpdateEvent();
								return false;
							}
							else {
								_cycleTime = duration;
								calculateValue(_cycleTime);
								sendUpdateEvent();
								removeAnimation(this);
								var delayTimer:Timer = new Timer(repeatDelay, 1);
								delayTimer.addEventListener(TimerEvent.TIMER, repeat);
								delayTimer.start();
								return false;
							}
						}
					}
				}
				_cycleTime = currentTime;
				
				calculateValue(currentTime);
				
				if (currentTime >= duration) {
					end();
					animationEnded = true;
				}
				else {
					if (repeated)
						sendAnimationEvent(EffectEvent.EFFECT_REPEAT);
					sendUpdateEvent();
				}
			}
			return animationEnded;
		}
		
		private function sendUpdateEvent():void
		{
			if (_animationTarget)
				_animationTarget.complexAnimationUpdate(this);
		}
		
		private function sendAnimationEvent(eventType:String):void
		{
			if (_animationTarget)
				switch (eventType) {
					case EffectEvent.EFFECT_START:
						_animationTarget.complexAnimationStart(this);
						break;
					case EffectEvent.EFFECT_END:
						_animationTarget.complexAnimationEnd(this);
						break;
					case EffectEvent.EFFECT_STOP:
						_animationTarget.complexAnimationStop(this);
						break;
					case EffectEvent.EFFECT_REPEAT:
						_animationTarget.complexAnimationRepeat(this);
						break;
					case EffectEvent.EFFECT_UPDATE:
						_animationTarget.complexAnimationUpdate(this);
						break;
				}
		}
		
		private function calculateValue(currentTime:Number):void
		{
			var i:int;
			
			currentValue = new Array();
			if (duration == 0) {
				for (i = 0; i < motionPaths.length; ++i)
					currentValue[(motionPaths[i] as ComplexMotionPath).contourIndex][(motionPaths[i] as ComplexMotionPath).pointIndex][motionPaths[i].property] = motionPaths[i].
						keyframes[motionPaths[i].keyframes.length - 1].value;
				return;
			}
			
			if (_invertValues)
				currentTime = duration - currentTime;
			
			_cycleFraction = easer.ease(currentTime/duration);
			
			if (motionPaths)
				for (i = 0; i < motionPaths.length; ++i)
					currentValue[i] = {contourIndex:(motionPaths[i] as ComplexMotionPath).contourIndex, pointIndex:(motionPaths[i] as ComplexMotionPath).pointIndex, value: motionPaths[i].getValue(_cycleFraction) };
		}
		
		private function removeFromDelayedAnimations():void
		{
			if (delayedStartTimes[this]) {
				var animPendingTime:int = delayedStartTimes[this];
				for (var i:int = 0; i < delayedStartAnims.length; ++i) {
					if (delayedStartAnims[i] == this) {
						delayedStartAnims.splice(i, 1);
						break;
					}
				}
				delete delayedStartTimes[this];
			}
		}
		
		public function end():void
		{
			if (!started)
				sendAnimationEvent(EffectEvent.EFFECT_START);
			if (repeatCount > 1 && repeatBehavior == "reverse" && (repeatCount % 2 == 0))
				_invertValues = true;
			calculateValue(duration);
			
			sendUpdateEvent();
			sendAnimationEvent(EffectEvent.EFFECT_END);
			
			stopAnimation();
		}
		
		private function addToDelayedAnimations(timeToDelay:Number):void
		{
			if (!timer) {
				Timeline.pulse();
				timer = new Timer(TIMER_RESOLUTION);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
			}
			var animStartTime:int = Timeline.currentTime + timeToDelay;
			var insertIndex:int = -1;
			for (var i:int = 0; i < delayedStartAnims.length; ++i) {
				var timeAtIndex:int = 
					delayedStartTimes[delayedStartAnims[i]];
				if (animStartTime < timeAtIndex) {
					insertIndex = i;
					break;
				}
			}
			if (insertIndex >= 0)
				delayedStartAnims.splice(insertIndex, 0, this);
			else
				delayedStartAnims.push(this);
			delayedStartTimes[this] = animStartTime;
		}
		
		public function play():void
		{
			stopAnimation();
			
			var i:int;
			var j:int;
			for (i = 0; i < motionPaths.length; ++i) {
				var keyframes:Vector.<Keyframe> = motionPaths[i].keyframes;
				if (isNaN(keyframes[0].time))
					keyframes[0].time = 0;
				
				else if (keyframes[0].time > 0) {
					var startTime:Number = keyframes[0].time;
					keyframes.splice(0, 0, new Keyframe(0, null));
					keyframes.splice(1, 0, new Keyframe(startTime-1, null));
				}
				for (j = 1; j < keyframes.length; ++j) {
					if (isNaN(keyframes[j].time))
						keyframes[j].time = duration;
				}
			}
			for (i = 0; i < motionPaths.length; ++i)
				motionPaths[i].scaleKeyframes(duration);
			
			if (_doReverse)
				_invertValues = true;
			
			if (startDelay > 0)
				addToDelayedAnimations(startDelay);
			else
				start();
		}
		
		private function seek(playheadTime:Number, includeStartDelay:Boolean = false):void
		{
			startTime = cycleStartTime = intervalTime - playheadTime;
			_doSeek = true;
			
			if (!_isPlaying) {
				intervalTime = Timeline.currentTime;
				if (includeStartDelay && startDelay > 0) {
					if (delayedStartTimes[this]) {
						var animPendingTime:int = delayedStartTimes[this];
						for (var i:int = 0; i < delayedStartAnims.length; ++i) {
							if (delayedStartAnims[i] == this) {
								delayedStartAnims.splice(i, 1);
								break;
							}
						}
						delete delayedStartTimes[this];
						var postDelaySeekTime:Number = playheadTime - startDelay;
						if (postDelaySeekTime < 0) {
							animPendingTime = intervalTime + (startDelay - playheadTime);
							// add it back into the array in the proper order
							var insertIndex:int = -1;
							for (i = 0; i < delayedStartAnims.length; ++i) {
								if (animPendingTime < delayedStartTimes[delayedStartAnims[i]]) {
									insertIndex = i;
									break;
								}
							}
							if (insertIndex >= 0)
								delayedStartAnims.splice(insertIndex, 0, this);
							else
								delayedStartAnims.push(this);
							delayedStartTimes[this] = animPendingTime;
							return;
						}
						else {
							playheadTime -= startDelay;
							start();
							startTime = cycleStartTime = intervalTime - playheadTime;
							doInterval();
							_doSeek = false;
							return;
						}
					}
				}
				sendAnimationEvent(EffectEvent.EFFECT_START);
				setupInterpolation();
				startTime = cycleStartTime = intervalTime - playheadTime;
			}
			doInterval();
			_doSeek = false;
		}
		
		private function setupInterpolation():void
		{
			if (interpolator && motionPaths)
				for (var i:int = 0; i < motionPaths.length; ++i)
					motionPaths[i].interpolator = interpolator;
		}
		
		mx_internal function reverse():void
		{
			if (_isPlaying) {
				_doReverse = false;
				seek(duration - _cycleTime);
				_invertValues = !_invertValues;
			}
			else {
				_doReverse = !_doReverse;
			}
		}
		
		public function pause():void
		{
			var animPendingTime:Number = delayedStartTimes[this];
			if (!isNaN(animPendingTime)) {
				delayTime = animPendingTime - Timeline.currentTime;
				removeFromDelayedAnimations();
			}
			_isPlaying = false;
		}
		
		private function stopAnimation():void
		{
			removeFromDelayedAnimations();
			if (id >= 0) {
				ComplexAnimation.removeAnimationAt(id);
				id = -1;
				_invertValues = false;
				_isPlaying = false;
			}
		}
		
		public function stop():void
		{
			stopAnimation();
			sendAnimationEvent(EffectEvent.EFFECT_STOP);
		}
		
		public function resume():void
		{
			_isPlaying = true;
			
			if (delayTime >= 0)
			{
				addToDelayedAnimations(delayTime);
			}
			else
			{
				cycleStartTime = intervalTime - _cycleTime;
				startTime = intervalTime - _playheadTime;
				if (_doReverse)
				{
					reverse();
					_doReverse = false;
				}
			}
		}
		
		private function repeat(event:TimerEvent = null):void
		{
			if (repeatBehavior == RepeatBehavior.REVERSE)
				_invertValues = !_invertValues;
			calculateValue(0);
			sendAnimationEvent(EffectEvent.EFFECT_REPEAT);
			sendUpdateEvent();
			ComplexAnimation.addAnimation(this);
		}
		
		private function start(event:TimerEvent = null):void
		{
			var actualStartTime:int = 0;
			
			for (var i:int = 0; i < delayedStartAnims.length; ++i) {
				if (this == delayedStartAnims[i]) {
					var animStartTime:int = int(delayedStartTimes[this]);
					var overrun:int = Timeline.currentTime - animStartTime;
					if (overrun > 0)
						actualStartTime = Math.min(overrun, duration);
					delete delayedStartTimes[this];
					delayedStartAnims.splice(i, 1);
					break;
				}
			}
			sendAnimationEvent(EffectEvent.EFFECT_START);
			
			setupInterpolation();
			
			calculateValue(0);
			
			if (duration == 0) {
				id = -1;
				end();
			}
			else {
				sendUpdateEvent();
				ComplexAnimation.addAnimation(this);
				startTime = cycleStartTime;
				_isPlaying = true;
				if (actualStartTime > 0)
					seek(actualStartTime);
			}
			started = true;
		}
		
	}
}

internal class Timeline
{
	import flash.utils.getTimer;
	
	private static var startTime:int = -1;
	private static var _currentTime:int = -1;
	
	public function Timeline()
	{
	}
	
	public static function pulse():int
	{
		if (startTime < 0)
		{
			startTime = getTimer();
			_currentTime = 0;
			return _currentTime;
		}
		_currentTime = getTimer() - startTime;
		return _currentTime;
	}
	
	public static function get currentTime():int
	{
		if (_currentTime < 0)
		{
			var retVal:int = pulse();
			return pulse();
		}
		return _currentTime;
	}
	
}
