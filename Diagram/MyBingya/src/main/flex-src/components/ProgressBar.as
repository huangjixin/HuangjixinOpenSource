package components
{
	/**
	 * @author 黄记新, 下午5:50:35
	 */
	import spark.components.supportClasses.SkinnableComponent;
	import flash.events.Event;
	
	public class ProgressBar extends SkinnableComponent
	{
		private var _value:Number = 0;
		
		public function ProgressBar()
		{
			super();
		}

		[Bindable(event="valueChange")]
		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			if( _value !== value)
			{
				if(value>100){
					value = 100;
				}else if(value<0){
					value = 0;
				}
				_value = value;
				dispatchEvent(new Event("valueChange"));
			}
		}

	}
}