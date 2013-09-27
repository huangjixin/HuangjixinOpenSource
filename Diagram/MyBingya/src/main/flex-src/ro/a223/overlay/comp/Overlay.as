package ro.a223.overlay.comp
{
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	import spark.primitives.supportClasses.FilledElement;
	
	[Style(name="cornerRadius", type="Number", format="Length", inherit="no")]
	[Style(name="filledElementColor", type="uint", format="Color", inherit="yes")]
	public class Overlay extends SkinnableComponent
	{
		private var _info:String;
		
		[SkinPart(required="true")]
		public var filledElementOne:FilledElement;

		[SkinPart(required="true")]
		public var filledElementTwo:FilledElement;
		
		[SkinPart(required="true")]
		public var filledElementThree:FilledElement;

		[SkinPart(required="true")] 
		public var descriptionLabel:TextBase; 
		
		public function Overlay()
		{
			super();
		}

		public function set info(value:String):void 
		{ 
			if (_info != value)
			{
				_info = value; 
				if (descriptionLabel)
				{
					descriptionLabel.text = value;
				}
			}
		}
		
		override protected function partAdded(partName:String, instance:Object) : void 
		{ 
			super.partAdded(partName, instance); 
			
			if (instance == descriptionLabel) 
			{	
				descriptionLabel.text = _info; 
			}
		}
	}
}