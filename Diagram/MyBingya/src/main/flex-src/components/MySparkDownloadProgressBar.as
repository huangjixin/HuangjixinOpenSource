package components
{
	/**
	 * @author 黄记新, 下午12:14:16
	 */
	import flash.events.ProgressEvent;
	
	import mx.preloaders.DownloadProgressBar;
	
	public class MySparkDownloadProgressBar extends DownloadProgressBar
	{
		public function MySparkDownloadProgressBar()
		{
			this.showPercentage = true;
			super();
		}
		
		override protected function showDisplayForDownloading(elapsedTime:int, event:ProgressEvent):Boolean {
			/*/
			trace("showDisplayForDownloading: elapsedTime = " + elapsedTime);
			trace("showDisplayForDownloading:" + event.bytesLoaded + " " +
			event.bytesTotal + " " + (event.bytesLoaded < event.bytesTotal / 2));
			//*/
			
			return elapsedTime > 100;
			// return elapsedTime > 700 && event.bytesLoaded < event.bytesTotal / 2;
		}
	}
}