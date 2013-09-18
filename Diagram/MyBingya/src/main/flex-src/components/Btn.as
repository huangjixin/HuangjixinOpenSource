package components
{
	import spark.components.Button;
	import spark.components.Image;
	
	public class Btn extends Button
	{
		[Bindable]
		public var iconSource:String;
		
		public function Btn()
		{
			super();
		}
	}
}