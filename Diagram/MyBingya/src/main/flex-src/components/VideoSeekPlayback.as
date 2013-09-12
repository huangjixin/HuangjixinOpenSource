package components
{
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.controls.HSlider;
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.SliderEvent;
	
	[Event(name="videoStop")]
	[Event(name="showSeekChanged")]
	[Event(name="data", type="flash.events.DataEvent")]
	
	public class VideoSeekPlayback extends UIComponent
	{
		private static const VIDEO_STOP_EVENT:String = "videoStop";
		private static const SHOW_SEEK_CHANGED:String = "showSeekChanged";
		
		private static const BUFFER_EMPTY:String = "Data is not being received quickly enough to fill the buffer. Data flow will be interrupted until the buffer refills, at which time a NetStream.Buffer.Full message will be sent and the stream will begin playing again.";
		private static const BUFFER_FULL:String = "The buffer is full and the stream will begin playing.";
		private static const BUFFER_FLUSH:String = "Data has finished streaming, and the remaining buffer will be emptied.";
		private static const SEEK_TRACE:String = "Seeking to : ";
		
		private static const SLIDER_HEIGHT:Number = 23;
		
		private var _showSeekChanged:Boolean = false;
		private var _showSeek:Boolean = true;
		
		[Inspectable]
		[Bindable('showSeekChanged')]
		public function get showSeek():Boolean {
			return _showSeek;
		}
		
		public function set showSeek( value:Boolean ):void {
			if ( _showSeek != value ) {
				_showSeek = value;
				_showSeekChanged = true;
				dispatchEvent( new Event( SHOW_SEEK_CHANGED, true ) );
				invalidateProperties();
			}
		}
		
		private var _time:Number;
		private var _totalTime:Number;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _videoObj:Video;
		private var _sliderBar:HSlider;
		private var _isDragging:Boolean;
		private var _timeInterval:Number;
		private var _fade:Fade;
		
		public var isFullScreen:Boolean = false;
		
		public function VideoSeekPlayback()
		{
			super();
		}
		
		override protected function commitProperties() : void
		{
			super.commitProperties();
			_isDragging = false;
			
			if ( _sliderBar && _showSeekChanged ) 
			{
				_showSeekChanged = false;
				_sliderBar.visible = _showSeek;
				_sliderBar.includeInLayout = _showSeek;
			}
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			
			_videoObj = new Video();
			
			_sliderBar = new HSlider();
			_sliderBar.snapInterval = 1;
			_sliderBar.allowTrackClick = false;
			_sliderBar.enabled = false;
			_sliderBar.visible = _showSeek;
			_sliderBar.includeInLayout = _showSeek;
			_sliderBar.styleName = 'videoSlider';
			
			
			this.addChild(_videoObj);
			this.addChild(_sliderBar);
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			_sliderBar.setActualSize( unscaledWidth, SLIDER_HEIGHT );
			_sliderBar.move(0,unscaledHeight-_sliderBar.height);
			
			_videoObj.x = 0;
			_videoObj.y = 0;
			_videoObj.width = unscaledWidth;
			_videoObj.height = unscaledHeight - _sliderBar.height;
			
		}
		
		public function createNetStream( nc_:NetConnection ) : NetStream
		{
			_nc = nc_;
			
			_ns = new NetStream( _nc );
			_ns.addEventListener( NetStatusEvent.NET_STATUS, handlerNetStatus );
			
			var customClient:Object = new Object();
			customClient.onPlayStatus = handleOnPlayStatus;
			_ns.client = customClient;
			
			_videoObj.attachNetStream( _ns );
			
			_sliderBar.addEventListener( SliderEvent.THUMB_PRESS, handlerOnThumbPress );
			_sliderBar.addEventListener( SliderEvent.THUMB_RELEASE, handlerOnThumbRelease );
			
			return _ns;
		}
		
		private function handleOnPlayStatus( event:Object ) : void
		{
			trace( 'in handleOnPlayStatus' );
			
			dispatchEvent( new Event( VIDEO_STOP_EVENT, true ) );
		}
		
		public function play( source:String, startingPoint:Number=0 ) : void
		{
			_sliderBar.enabled = true;
			
			if ( showSeek )
			{
				var myResponder:Responder = new Responder( onResultGetVideoLength, onFaultGetVideoLength );
				_nc.call( "getStreamLength", myResponder, source );
			}
			
			if ( startingPoint > 0 )
			{
				_ns.play( source, startingPoint );
			}
			else
			{
				_ns.play( source );
			}
			
			_timeInterval = setInterval(getNetStreamTime, 500);
		}
		
		public function stop() : void
		{
			_sliderBar.enabled = false;
			
			_ns.close();
			
			//_videoObj.clear();
			_fade = new Fade( _videoObj );
			_fade.alphaFrom = 1;
			_fade.alphaTo = 0;
			_fade.duration = 750;
			_fade.play();
			
			_sliderBar.value = 0;
			clearInterval( _timeInterval );
		}
		
		private function getNetStreamTime() : void
		{
			if( !_isDragging )
				_sliderBar.value = _ns.time;
		}
		
		public function onResultGetVideoLength( data:Object ) : void
		{
			_totalTime = data as Number;
			_sliderBar.maximum = _totalTime;
			this.invalidateSize();
		}
		
		public function onFaultGetVideoLength( data:Object ) : void
		{
			var msg:String = "The method Client.getStreamLength ";
			msg += "doesn't exist in your SSAS, are you using VOD?";
		}
		
		private function handlerNetStatus(event:NetStatusEvent) : void
		{
			var info:Object = event.info;
			
			switch ( info.code )
			{
				case "NetStream.Play.Start":
					this.invalidateSize();
					_sliderBar.enabled = true;
					
					_fade = new Fade( _videoObj );
					_fade.alphaFrom = 0;
					_fade.alphaTo = 1;
					_fade.duration = 750;
					_fade.play();
					break;
				
				case "NetStream.Buffer.Empty":
					dispatchEvent( new DataEvent( DataEvent.DATA, true, false, BUFFER_EMPTY ) );
					break;
				
				case "NetStream.Buffer.Full":
					dispatchEvent( new DataEvent( DataEvent.DATA, true, false, BUFFER_FULL ) );
					break;
				
				case "NetStream.Buffer.Flush":
					dispatchEvent( new DataEvent( DataEvent.DATA, true, false, BUFFER_FLUSH ) );
					break;	
				
				case "NetStream.Play.Stop":
					_sliderBar.enabled = false;
					
					clear();
					dispatchEvent( new Event( VIDEO_STOP_EVENT, true ) );
					break;
			}
		}
		
		
		//remove the videoObj from the display list and return it
		public function getVideoObject() : Video
		{
			removeChild( _videoObj );
			isFullScreen = true;
			return _videoObj;
		}
		
		//add the videoObj back to the display list
		public function setVideoObject( video:Video ) : void
		{
			addChild( video );
			isFullScreen = false;
		}
		
		//handler for mouseDown on the seek slider
		private function handlerOnThumbPress( event:SliderEvent ) : void 
		{
			_isDragging = true;
		}
		
		private function handlerOnThumbRelease( event:SliderEvent ) : void 
		{
			_ns.seek( _sliderBar.value );
			
			dispatchEvent( new DataEvent( DataEvent.DATA, true, false, SEEK_TRACE + _sliderBar.value.toString() ) );
			
			_isDragging = false;
		}
		
		public function get time() : Number
		{
			return _ns.time;
		}	
		
		public function get totalTime() : Number
		{
			return _totalTime;
		}
		
		public function attachNetStream ( ns:NetStream ) : void
		{
			_videoObj.attachNetStream(ns);
		}
		
		public function clear() : void
		{
			_videoObj.clear();
		}
		
		public function get videoObj():Video
		{
			return _videoObj;
		}
		
	}
}