package ws.tink.graphics.utils
{
	
	import flash.display.Graphics;
	
	import ws.tink.graphics.IGraphicsCreator;
	
	
	public class EllipseUtil
	{

		
		
		
		public static function drawCircle( graphics:IGraphicsCreator, x:Number, y:Number, 
										   radius:Number, accuracy:Number = 10 ):void
		{
			EllipseUtil.drawEllipse( graphics,x, y, radius, radius, accuracy );
		}
		
	
		public static function drawEllipse( graphics:IGraphicsCreator, x:Number, y:Number,
										   radiusX:Number, radiusY:Number, accuracy:Number = 10 ):void
		{
			
			if( accuracy < 4 ) accuracy = 4;
			
			var span:Number = Math.PI / accuracy;
			
			var controlRadiusX:Number = radiusX / Math.cos( span );
			var controlRadiusY:Number = radiusY / Math.cos( span );
			var anchorAngle:Number = 0;
			var controlAngle:Number = 0;
			
			graphics.moveTo( x + Math.cos( anchorAngle ) * radiusX, y + Math.sin( anchorAngle ) * radiusY );
			
			for( var i:int = 0; i < accuracy; ++i )
			{
				controlAngle = anchorAngle+span;
				anchorAngle = controlAngle+span;
				graphics.curveTo( x + Math.cos(controlAngle)*controlRadiusX,
					y + Math.sin(controlAngle)*controlRadiusY,
					x + Math.cos(anchorAngle)*radiusX,
					y + Math.sin(anchorAngle)*radiusY );
			}
		}
	}
	
}
