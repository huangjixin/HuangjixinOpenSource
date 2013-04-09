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
	[Style(name="endArrowVisible", inherit="yes", type="Boolean",format="Boolean",enumeration="true,false")]
	[Style(name="joints", inherit="yes", type="String",enumeration="round,miter,bevel")]
	[Style(name="miterLimit", inherit="yes", type="uint",format="Number")]
	[Style(name="orthogonalSpacing", inherit="no", type="Number")]
	[Style(name="pixelHinting", inherit="yes", type="Boolean",format="Boolean")]
	[Style(name="radius", inherit="no", type="Number")]
	[Style(name="selectedColor", inherit="yes", type="uint",format="Color")]
	[Style(name="selectedStrokeWidth", inherit="yes", type="uint",format="Number")]
	[Style(name="startArrowType", inherit="yes", type="String",enumeration="triangle,open,sunken,curved,square,diamond,circle,star")]
	[Style(name="startArrowVisible", inherit="yes", type="Boolean",format="Boolean",enumeration="true,false")]
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
		 * 箭头头部长度。 
		 */
		private static const ARROW_HEADER_LENGTH:Number = 10;
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
			
			
			// path绘图数据。
			var data:String = getData();
			path.data = data;
		}
		
		/**
		 * 通过开始节点，结束节点，线的风格，形状，计算开始箭头，结束箭头的位置，返回字符串数据。 
		 * @return data字符串。
		 * 
		 */
		private function getData():String
		{
			var data:String = "";
			// 确定连线风格。
			var dashStyle:String = this.getStyle("dashStyle");
			// 
			var fP:Point = fallbackStartPoint;
			var tP:Point = fallbackEndPoint;
			//计算终点和起始点形成的角度。
			var linkAngle:Number = Math.atan2(tP.y - fP.y,tP.x - fP.x);
			//如果为直连线的话，那么连线连线的终点箭头就是linkDegree，开始箭头就是linkDegree+180
			var linkDegree:Number = Geometry.rad2deg(linkAngle);
			if(shapeType == LinkShapeType.STRAIGHT){
				var distance:Number;//两点之间的距离。
				var minOffset:Number;
				if(startNode){
//					//确定结束节点的高宽比角度。
					var startNodeHWAngle:Number = Math.atan2(startNode.height,startNode.width);
					// 计算出终点二分之一宽度对应的弦；
					var sNodeHeightOffset:Number = startNode.width/2/ Math.cos(linkAngle);
//					// 计算出终点二分之一高度对应的弦；（因为角度的变化，要让终点始终紧贴着终结点，必须找到更小的弦）
					var sNodeWidthOffset:Number = startNode.height/2/ Math.sin(linkAngle);
//					
					minOffset = Math.min(Math.abs(sNodeHeightOffset),Math.abs(sNodeWidthOffset));
					minOffset = Math.abs(minOffset);
					fP.offset(minOffset*Math.cos(linkAngle),minOffset*Math.sin(linkAngle));
				}
				//确定开始点箭头位置
				var sArrowPoint:Point = fP.clone();
				if(startArrow){
					var startArrowVisible:* = getStyle("startArrowVisible");
					if(startArrowVisible){//倘若终节点可见，移动其位置，旋转其箭头，并且确定连线终点位置
						var startArrowType:* = getStyle("startArrowType");
						if(startArrowType == "triangle"){
							startArrow.x = sArrowPoint.x;
							startArrow.y = sArrowPoint.y;
							startArrow.rotation = 180+linkDegree;
							
							//确定连线终点位置
							sArrowPoint = Point.polar(ARROW_HEADER_LENGTH,linkAngle);
							fP.offset(sArrowPoint.x,sArrowPoint.y);
						}
					}
				}
				
				if(endNode){
					//确定结束节点的高宽比角度。
					var endNodeHWAngle:Number = Math.atan2(endNode.height,endNode.width);
					// 计算出终点二分之一宽度对应的弦；
					var eNodeHeightOffset:Number = endNode.width/2/ Math.cos(linkAngle);
					// 计算出终点二分之一高度对应的弦；（因为角度的变化，要让终点始终紧贴着终结点，必须找到更小的弦）
					var eNodeWidthOffset:Number = endNode.height/2/ Math.sin(linkAngle);
				
					minOffset = Math.min(Math.abs(eNodeHeightOffset),Math.abs(eNodeWidthOffset));
					minOffset = Math.abs(minOffset);
					distance = Point.distance(tP,fP);
					tP = Point.polar(distance -minOffset,linkAngle);
					tP.offset(fP.x,fP.y);
				}
				
				//确定终点箭头位置
				var eArrowPoint:Point = Point.polar(Point.distance(tP,fP),linkAngle);
				eArrowPoint.offset(fP.x,fP.y);
				if(endArrow){
					var endArrowVisiable:* = getStyle("endArrowVisible");
					if(endArrowVisiable){//倘若终节点可见，移动其位置，旋转其箭头，并且确定连线终点位置
						var endArrowType:* = getStyle("endArrowType");
						if(endArrowType == "triangle"){
							endArrow.x = eArrowPoint.x;
							endArrow.y = eArrowPoint.y;
							endArrow.rotation = linkDegree;
							
							//确定连线终点位置
							tP = Point.polar(Point.distance(tP,fP) - ARROW_HEADER_LENGTH,linkAngle);
							tP.offset(fP.x,fP.y);
						}
					}
				}
				
				if(dashStyle == DashStyle.NONE){
					data = "M "+fP.x+" "+fP.y+" L "+tP.x+" "+tP.y;
				}else if(dashStyle == DashStyle.DASH){
					
				}else if(dashStyle == DashStyle.DASH_DOT){
					
				}else if(dashStyle == DashStyle.DOT){
					
				}
			}else if(shapeType == LinkShapeType.ORTHOGONAL){
				var startOffset:Point ;
				var endOffset:Point ;
				
				if(startConnectionArea == LinkConnectionArea.LEFT){
					fP.offset(-startNode.width/2,0);
					startOffset = fP.clone();
					startOffset.offset(-EXTEND_LENGTH,0);
				}else if(startConnectionArea == LinkConnectionArea.RIGHT){
					fP.offset(startNode.width/2,0);
					startOffset = fP.clone();
					startOffset.offset(EXTEND_LENGTH,0);
				}else if(startConnectionArea == LinkConnectionArea.TOP){
					fP.offset(0,-startNode.height/2);
					startOffset = fP.clone();
					startOffset.offset(0,-EXTEND_LENGTH);
				}else if(startConnectionArea == LinkConnectionArea.BOTTOM){
					fP.offset(0,startNode.height/2);
					startOffset = fP.clone();
					startOffset.offset(0,EXTEND_LENGTH);
				}
				
				if(endConnectionArea == LinkConnectionArea.LEFT){
					tP.offset(-endNode.width/2,0);
					endOffset = tP.clone();
					endOffset.offset(-EXTEND_LENGTH,0);
					tP.offset(-10,0);
					if(endArrow){
						endArrow.x = tP.x;
						endArrow.y = tP.y;
						endArrow.rotation = 0;
					}
				}else if(endConnectionArea == LinkConnectionArea.RIGHT){
					tP.offset(endNode.width/2,0);
					endOffset = tP.clone();
					endOffset.offset(EXTEND_LENGTH,0);
				}else if(endConnectionArea == LinkConnectionArea.TOP){
					tP.offset(0,-endNode.height/2);
					endOffset = tP.clone();
					endOffset.offset(0,-EXTEND_LENGTH);
				}else if(endConnectionArea == LinkConnectionArea.BOTTOM){
					tP.offset(0,endNode.height/2);
					endOffset = tP.clone();
					endOffset.offset(0,EXTEND_LENGTH);
				}
				
				var basePoint:Point = new Point(startOffset.x/2+endOffset.x/2,startOffset.y/2+endOffset.y/2);
				if(dashStyle == DashStyle.NONE){
					data = "M "+fP.x+" "+fP.y+" L "+startOffset.x+" "+startOffset.y
						+" L "+basePoint.x+" "+startOffset.y
						+" L "+basePoint.x+" "+endOffset.y
						+" L "+endOffset.x+" "+endOffset.y
						+" L "+tP.x+" "+tP.y;
				}else if(dashStyle == DashStyle.DASH){
					
				}else if(dashStyle == DashStyle.DASH_DOT){
					
				}else if(dashStyle == DashStyle.DOT){
					
				}
			}else if(shapeType == LinkShapeType.FREE){
				
			}else if(shapeType == LinkShapeType.OBLIQUE){
				
			}
			return data;
		}//getData结束
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
			if(styleProp =="endArrowType"){
				if(getStyle("endArrowType") == "triangle"){
					if(endArrow){
						endArrow.data = "M -10 -5 l 10 5 l -10 5 Z";
					}
				}else if(getStyle("endArrowType") == "circle"){
					if(endArrow){
						endArrow.data = "M -10 -5 l 10 5 l -10 5 Z";
					}
				}else if(getStyle("endArrowType") == "square"){
					if(endArrow){
						endArrow.data = "M -10 -5 l -10 5 l 0 5 l 0 -5 l -10 -5";
					}
				}
			}
			if(styleProp =="startArrowVisible"){
				if(startArrow){
					var startArrowVisible:Boolean = getStyle("startArrowVisible");
					startArrow.visible = startArrowVisible;
				}
			}
			if(styleProp =="endArrowVisible"){
				if(endArrow){
					var endArrowVisible:Boolean = getStyle("endArrowVisible");
					endArrow.visible = endArrowVisible;
				}
			}
		} 
	}
}