package com.hjx.graphic
{
	import com.hjx.graphic.skin.LinkSkin;
	import com.hjx.uitls.Geometry;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import spark.primitives.Path;

	/**
	 * 所有连线的基类，用于连接节点。一条线可以没有节点，或者一个节点，或者两个节点，所以其必须有两个Node的引用。 
	 * @author huangjixin
	 * 
	 */
	[Style(name="caps", inherit="yes", type="String",enumeration="round,square,none")]
	[Style(name="caretColor", inherit="no", type="uint",format="Color")]
	[Style(name="dashArray", inherit="no", type="Array")]
	[Style(name="dashStyle", inherit="no", type="String",enumeration="none,dash,dot,dashDot")]
	[Style(name="endArrowType", inherit="yes", type="String",enumeration="triangle,open,sunken,curved,square,diamond,circle,star")]
	[Style(name="endArrowVisible", inherit="yes", type="Boolean",format="Boolean")]
	[Style(name="joints", inherit="yes", type="String",enumeration="round,miter,bevel")]
	[Style(name="miterLimit", inherit="yes", type="uint",format="Number")]
	[Style(name="orthogonalSpacing", inherit="no", type="Number")]
	[Style(name="pixelHinting", inherit="yes", type="Boolean",format="Boolean")]
	[Style(name="radius", inherit="no", type="Number")]
	[Style(name="selectedColor", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedStrokeWidth", inherit="yes", type="uint",format="Number")]
	[Style(name="startArrowType", inherit="yes", type="String",enumeration="triangle,open,sunken,curved,square,diamond,circle,star")]
	[Style(name="startArrowVisible", inherit="yes", type="Boolean",format="Boolean")]
	[Style(name="strokeColor", inherit="yes", type="uint",format="Color")]
	[Style(name="strokeWidth", inherit="yes", type="uint",format="Number")]
	public class Link extends Renderer
	{
		private var _startNode:Node;
		private var _endNode:Node;
		
		private var _shapeType:String = LinkShapeType.STRAIGHT;
		
		private var linkTypeOrthogonal:String;
		private var _fallbackEndPoint:Point = new Point();
		private var _fallbackStartPoint:Point = new Point();
		
		private var _startConnectionArea:String = LinkConnectionArea.RIGHT;
		private var _endConnectionArea:String = LinkConnectionArea.LEFT;
		
		private static const EXTEND_LENGTH:Number = 20;
		/**
		 * 默认css风格。
		 * 
		 */
		private var defaultCSSStyles:Object = {
			dashStyle: "none", 
			endArrowType: "triangle", 
			endArrowVisible: true, 
			orthogonalSpacing: 20, 
			radius: 0, 
			strokeWidth: 1, 
			strokeColor: 0x0, 
			startArrowType: "triangle", 
			startArrowVisible: false,
			skinClass:LinkSkin
		};
		
		[SkinPart(required="false")]
		public var endArrow:Path;
		[SkinPart(required="true")]
		public var path:Path;
		[SkinPart(required="false")]
		public var startArrow:Path;
		
		public function Link(startNode:Node=null,endNode:Node=null)
		{
			super();
			this.startNode = startNode;
			this.endNode = endNode;
		}
		
		/**
		 * 结束节点的连接区域。 
		 * @return 
		 * 
		 */
		public function get endConnectionArea():String
		{
			return _endConnectionArea;
		}

		public function set endConnectionArea(value:String):void
		{
			_endConnectionArea = value;
		}

		/**
		 * 开始节点的连接区域。 
		 * @return 
		 * 
		 */
		[Bindable]
		[Inspectable(enumeration="left,right,top,bottom")]
		public function get startConnectionArea():String
		{
			return _startConnectionArea;
		}

		public function set startConnectionArea(value:String):void
		{
			_startConnectionArea = value;
		}

		[Bindable]
		public function get fallbackStartPoint():Point
		{
			return _fallbackStartPoint;
		}

		public function set fallbackStartPoint(value:Point):void
		{
			_fallbackStartPoint = value;
		}

		[Bindable]
		public function get fallbackEndPoint():Point
		{
			return _fallbackEndPoint;
		}

		public function set fallbackEndPoint(value:Point):void
		{
			_fallbackEndPoint = value;
		}

		[Bindable]
		[Inspectable(enumeration="straight,free,orthogonal,oblique")]
		public function get shapeType():String
		{
			return _shapeType;
		}

		public function set shapeType(value:String):void
		{
			_shapeType = value;
		}

		[Bindable(event="endNodeChange")]
		/**
		 * 终止节点。 
		 */
		public function get endNode():Node
		{
			return _endNode;
		}

		/**
		 * @private
		 */
		public function set endNode(value:Node):void
		{
			if( _endNode !== value)
			{
				_endNode = value;
				dispatchEvent(new Event("endNodeChange"));
				if(_endNode){
					var index:int = _endNode.links.indexOf(this);
					if(index==-1){
						_endNode.links.push(this);
					}
				}
			}
		}

		/**
		 * 起始节点。 
		 */
		[Bindable(event="startNodeChange")]
		public function get startNode():Node
		{
			return _startNode;
		}

		public function set startNode(value:Node):void
		{
			if( _startNode !== value)
			{
				_startNode = value;
				dispatchEvent(new Event("startNodeChange"));
				if(_startNode){
					var index:int = _startNode.links.indexOf(this);
					if(index ==-1){
						_startNode.links.push(this);
					}
				}
			}
		}
		
		
		/**
		 * 绘制图形。 
		 * 
		 */
		public function draw():void{
			if(startNode){
				fallbackStartPoint = new Point(startNode.centerX,startNode.centerY);
				fallbackStartPoint = startNode.parent.localToGlobal(fallbackStartPoint);
				fallbackStartPoint = this.parent.globalToLocal(fallbackStartPoint);
			}
			
			if(endNode){
				fallbackEndPoint = new Point(endNode.centerX,endNode.centerY);
				fallbackEndPoint = endNode.parent.localToGlobal(fallbackEndPoint);
				fallbackEndPoint = this.parent.globalToLocal(fallbackEndPoint);
			}
			
			var fP:Point = fallbackStartPoint;
			var tP:Point = fallbackEndPoint;
			// 确定连线风格。
			var dashStyle:String = this.getStyle("dashStyle");
			// path绘图数据。
			var data:String = "";
			
			var endArrowVisible:Boolean = getStyle("endArrowVisible");
			if(shapeType == LinkShapeType.STRAIGHT){
				//计算偏移角度。
				var angle:Number = Math.atan2(endNode.height,endNode.width);
				var linkAngle:Number = Math.atan2(tP.y - fP.y,tP.x - fP.x);
				var linkDegree:Number = Geometry.rad2deg(linkAngle);
				var degree:Number = Geometry.rad2deg(angle);
				
				var endNodeWidthOffset:Number = endNode.width/2/ Math.cos(linkAngle);
				var endNodeHeightOffset:Number = endNode.height/2/ Math.sin(linkAngle);
				var startNodeWidthOffset:Number = startNode.width/2/ Math.cos(linkAngle);
				var startNodeHeightOffset:Number = startNode.height/2/ Math.sin(linkAngle);
				var distance:Number = Point.distance(tP,fP);
				var startPoint:Point = new Point();
				if(-angle<= linkAngle && linkAngle <= angle){
					tP = Point.polar(distance -endNodeWidthOffset,linkAngle);
				}else if(angle<=linkAngle &&linkAngle <=Math.PI-angle){
					tP = Point.polar(distance -endNodeHeightOffset,linkAngle);
				}else if(-(Math.PI-angle)<linkAngle&&linkAngle<-angle){
					tP = Point.polar(distance +endNodeHeightOffset,linkAngle);
				}else if(Math.PI-angle< linkAngle<Math.PI){
					tP = Point.polar(distance +endNodeWidthOffset,linkAngle);
				}else if(-Math.PI<linkAngle<angle-Math.PI ){
					tP = Point.polar(distance -endNodeWidthOffset,linkAngle);
				}
				
				tP.offset(fP.x,fP.y);
				
				//确定箭头位置
				var arrowPoint:Point = Point.polar(Point.distance(tP,fP),linkAngle);
				arrowPoint.offset(fP.x,fP.y);
				//确定连线终点位置
				tP = Point.polar(Point.distance(tP,fP) -10,linkAngle);
				tP.offset(fP.x,fP.y);
				//确定连线起点位置
//				fP = startPoint;
				if(endArrow){
					if(endArrowVisible){
						endArrow.x = arrowPoint.x;
						endArrow.y = arrowPoint.y;
						endArrow.rotation = linkDegree;
					}
				}
				
				if(dashStyle == DashStyle.NONE){
					data = "M "+fP.x+" "+fP.y+" L "+tP.x+" "+tP.y;
				}else if(dashStyle == DashStyle.DASH){
					
				}else if(dashStyle == DashStyle.DASH_DOT){
					
				}else if(dashStyle == DashStyle.DOT){
					
				}
			}else if(shapeType == LinkShapeType.ORTHOGONAL){
				var startOffset:Point = new Point();
				var endOffset:Point = new Point();
				
				if(startConnectionArea == LinkConnectionArea.LEFT){
					fP.offset(-startNode.width/2,0);
					startOffset.offset(-EXTEND_LENGTH,0);
				}else if(startConnectionArea == LinkConnectionArea.RIGHT){
					fP.offset(startNode.width/2,0);
					startOffset.offset(EXTEND_LENGTH,0);
				}else if(startConnectionArea == LinkConnectionArea.TOP){
					fP.offset(0,-startNode.height/2);
					startOffset.offset(0,-EXTEND_LENGTH);
				}else if(startConnectionArea == LinkConnectionArea.BOTTOM){
					fP.offset(0,startNode.height/2);
					startOffset.offset(0,EXTEND_LENGTH);
				}
				
				if(endConnectionArea == LinkConnectionArea.LEFT){
					fP.offset(-endNode.width/2,0);
					startOffset.offset(-EXTEND_LENGTH,0);
				}else if(endConnectionArea == LinkConnectionArea.RIGHT){
					fP.offset(endNode.width/2,0);
					startOffset.offset(EXTEND_LENGTH,0);
				}else if(endConnectionArea == LinkConnectionArea.TOP){
					fP.offset(0,-endNode.height/2);
					startOffset.offset(0,-EXTEND_LENGTH);
				}else if(endConnectionArea == LinkConnectionArea.BOTTOM){
					fP.offset(0,endNode.height/2);
					startOffset.offset(0,EXTEND_LENGTH);
				}
				
				var basePoint:Point = new Point(startOffset.x/2+endOffset.x/2,startOffset.y/2+endOffset.y/2);
				if(dashStyle == DashStyle.NONE){
					data = "M "+fP.x+" "+fP.y+" L "+startOffset.x+" "+startOffset.y+" L "+basePoint.x+" "+startOffset.y
						+" L "+basePoint.x+" "+endOffset.y+" L "+endOffset.x+" "+endOffset.y+" L "+tP.x+" "+tP.y;
				}else if(dashStyle == DashStyle.DASH){
					
				}else if(dashStyle == DashStyle.DASH_DOT){
					
				}else if(dashStyle == DashStyle.DOT){
					
				}
			}else if(shapeType == LinkShapeType.FREE){
				
			}else if(shapeType == LinkShapeType.OBLIQUE){
				
			}
			
			/*var data:String = "M 0 0";
			
			temp = Point.polar(Point.distance(tP,fP) - 4,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 8,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 12,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 16,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 20,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 24,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 28,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 32,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 36,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 40,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 44,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 48,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 52,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 56,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 60,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 64,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 68,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 72,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 76,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 80,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 84,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 88,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 92,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 96,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="M "+temp.x+" "+temp.y+" ";
			
			temp = Point.polar(Point.distance(tP,fP) - 100,edgeAngle);
			temp.offset(fP.x,fP.y);
			data+="L "+temp.x+" "+temp.y+" ";*/
			
			path.data = data;
//			path.data = "M "+fallbackStartPoint.x+" "+fallbackStartPoint.y+" V "+ fallbackEndPoint.y+" H "+(fallbackEndPoint.x-10) ;
//			path.data = "M -10 0 H -100 V -100 ";
		}
		
		//-----------------------------------------------------------
		// 覆盖函数
		//-----------------------------------------------------------
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			draw();
		}
		override protected function partAdded(partName:String, instance:Object):void{
			if(instance == this.startArrow){
				this.startArrow.visible = getStyle("startArrowVisible")
			}
			if(instance == this.endArrow){
				this.endArrow.visible = getStyle("endArrowVisible")
			}
		}
		
		override public function stylesInitialized():void{
			super.stylesInitialized();
			for (var i:String in defaultCSSStyles) {
				if (getStyle (i) == undefined) {
					setStyle (i, defaultCSSStyles [i]);
				}
			}
		} 
		
		override public function styleChanged(styleProp:String):void{
			super.styleChanged(styleProp);
			invalidateDisplayList();
		} 
	}
}