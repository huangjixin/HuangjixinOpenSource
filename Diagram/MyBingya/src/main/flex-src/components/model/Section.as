package components.model
{
	/**
	 * @author 黄记新, 下午7:38:42
	 */
	public class Section
	{
		public var title:String;
		public var start:Number;
		public var end:Number;
		public var source:String;
		
		public function Section(title:String,start:Number,end:Number,source:String)
		{
			this.title = title;
			this.start = start;
			this.end = end;
			this.source = source;
		}
	}
}