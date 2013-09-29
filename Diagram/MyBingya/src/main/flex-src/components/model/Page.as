package components.model
{
	/**
	 * @author 黄记新, 上午10:15:03
	 */
	public class Page
	{
		
		public var Id:String;
		public var Title:String;
		public var Content:String;
		public var start:String;
		public var end:String;
		public function Page(Id:String,Title:String,Content:String, start:String,end:String)
		{
			this.Id = Id;
			this.Title = Title;
			this.Content = Content;
			this.start = start;
			this.end = end;
		}
	}
}