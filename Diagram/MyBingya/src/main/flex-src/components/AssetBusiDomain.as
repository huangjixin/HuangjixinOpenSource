package components
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class AssetBusiDomain
	{
		public var titleXmlString:String;
		
		public var paths:ArrayCollection;
		
		public function AssetBusiDomain(titleXmlString:String,paths:ArrayCollection)
		{
			this.titleXmlString = titleXmlString;
			this.paths = paths;
		}
	}
}