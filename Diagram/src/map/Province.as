package map
{
	import com.hjx.graphic.SubGraph;
	
	public class Province extends SubGraph
	{
		private var _provinceName:String;
		
		public function Province()
		{
			super();
		}

		[Bindable]
		public function get provinceName():String
		{
			return _provinceName;
		}

		public function set provinceName(value:String):void
		{
			_provinceName = value;
		}

	}
}