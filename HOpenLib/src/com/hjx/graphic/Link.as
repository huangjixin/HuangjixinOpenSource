package com.hjx.graphic
{
	import com.hjx.graphic.skin.LinkSkin;
	import com.hjx.uitls.Geometry;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.graphics.SolidColorStroke;
	import mx.styles.StyleManager;
	
	import ws.tink.spark.graphics.SolidColorDash;
	import ws.tink.spark.primatives.Path;

	/**
	 * 所有连线的基类，用于连接节点。一条线可以没有节点，或者一个节点，或者两个节点，所以其必须有两个Node的引用。 
	 * @author huangjixin
	 * 
	 */
	[Style(name="caps", inherit="yes", type="String",enumeration="round,square,none")]
	[Style(name="caretColor", inherit="yes", type="uint",format="Color")]
	[Style(name="color", inherit="yes", type="uint",format="Color")]
	[Style(name="dashArray", inherit="yes", type="Array")]
	[Style(name="dashStyle", inherit="yes", type="String",enumeration="none,dash,dot,dashDot")]
	[Style(name="dash", inherit="yes", type="Number")]
	[Style(name="endArrowType", inherit="yes", type="String",enumeration="triangle,open,sunken,curved,square,diamond,circle,star")]
	[Style(name="endArrowVisible", inherit="yes", type="Boolean",format="Boolean",enumeration="true,false")]
	[Style(name="joints", inherit="yes", type="String",enumeration="round,miter,bevel")]
	[Style(name="miterLimit", inherit="yes", type="uint",format="Number")]
	[Style(name="orthogonalSpacing", inherit="yes", type="Number")]
	[Style(name="pixelHinting", inherit="yes", type="Boolean",format="Boolean")]
	[Style(name="radius", inherit="yes", type="Number")]
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
		private var _shapeTypeChange:Boolean;
		
		private var linkTypeOrthogonal:String;
		private var _fallbackEndPoint:Point;
		private var _fallbackStartPoint:Point;
		
		private var _startConnectionArea:String = LinkConnectionArea.CENTER;
		private var _endConnectionArea:String = LinkConnectionArea.CENTER;
		
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
		
		[SkinPart(required="false")]
		/**
		 * 存放label标签等元素。 
		 */
		public var labelElement:DisplayObject;
		
		private var _shapePoints:Vector.<Point>;
		private var _strokeWidth:Number;
		private var _strokeWidthChange:Boolean;
		private var _radius:Number = 5;
		private var _radiusChange:Boolean;
		private var _dashStyle:String = DashStyle.NONE;
		private var _dashStyleChange:Boolean;
		private var _startArrowVisible:Boolean;
		private var _startArrowVisibleChange:Boolean;
		private var _endArrowVisible:Boolean;
		private var _endArrowVisibleChange:Boolean;
		private var _startArrowType:String;
		private var _startArrowTypeChange:Boolean;
		private var _endArrowType:String;
		private var _endArrowTypeChange:Boolean;
		private var _orthogonalSpacing:Number = 12;
		private var _orthogonalSpacingChange:Boolean;
		private var _dash:Number = 8;
		private var _dashChange:Boolean;
		
		internal static var Top:int=0;
		
		internal static var Right:int=1;
		
		internal static var Bottom:int=2;
		
		internal static var Left:int=3;
		
		private var connectingAreaOffset:int = 10;
		
		public function Link(startNode:Node=null,endNode:Node=null)
		{
			this.fallbackStartPoint = new Point(0, 0);
			this.fallbackEndPoint = new Point(0, 0);
			this._shapePoints = new Vector.<Point>();
			
			super();
			if(startNode){
				this.startNode = startNode;
			}
			if(endNode){
				this.endNode = endNode;
			}
			
			/*for (var i:String in defaultCSSStyles) {
				setStyle (i, defaultCSSStyles [i]);
			}*/
		}
		
		/**
		 * 形状点组，它将决定连线形状。 
		 */
		public function get shapePoints():Vector.<Point>
		{
			return _shapePoints;
		}

		/**
		 * 结束节点的连接区域。 
		 * @return 
		 * 
		 */
		[Bindable]
		[Inspectable(enumeration="left,right,top,bottom,center")]
		public function get endConnectionArea():String
		{
			return _endConnectionArea;
		}

		public function set endConnectionArea(value:String):void
		{
			_endConnectionArea = value;
			invalidateDisplayList();
		}

		/**
		 * 开始节点的连接区域。 
		 * @return 
		 * 
		 */
		[Bindable]
		[Inspectable(enumeration="left,right,top,bottom,center")]
		public function get startConnectionArea():String
		{
			return _startConnectionArea;
		}

		public function set startConnectionArea(value:String):void
		{
			_startConnectionArea = value;
			invalidateDisplayList();
		}

		[Bindable]
		public function get fallbackStartPoint():Point
		{
			return _fallbackStartPoint;
		}

		public function set fallbackStartPoint(value:Point):void
		{
			/*if (!value) 
			{
				throw new ArgumentError("参数类型错误");
			}*/
			
			_fallbackStartPoint = value;
			if (!this.startNode) 
			{
				this.invalidateShape();
			}
		}

		[Bindable]
		public function get fallbackEndPoint():Point
		{
			return _fallbackEndPoint;
		}

		public function set fallbackEndPoint(value:Point):void
		{
			/*if (!value) 
			{
				throw new ArgumentError("参数类型错误");
			}*/
			_fallbackEndPoint = value;
			if (!this.endNode) 
			{
				this.invalidateShape();
			}
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
			_shapeTypeChange = true;
			this.invalidateShape();
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
				var index:int;
				/*var eNode:Node = this._endNode;
				if(eNode){
					index = eNode.incomingLinks.indexOf(this);
					if(index ==-1){
						eNode.incomingLinks.splice(index,1);
					}
				}*/
				_endNode = value;
				dispatchEvent(new Event("endNodeChange"));
				invalidateShape();
				
				index==-1;
				if(_endNode){
					fallbackEndPoint = null;
					index = _endNode.incomingLinks.indexOf(this);
					if(index==-1){
						_endNode.incomingLinks.push(this);	
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
				var index:int=-1;
				/*var sNode:Node = this._startNode;
				if(sNode){
					index = sNode.outgoingLinks.indexOf(this);
					if(index ==-1){
						sNode.incomingLinks.splice(index,1);
					}
				}*/
				_startNode = value;
				dispatchEvent(new Event("startNodeChange"));
				invalidateShape();
				
				index=-1;
				if(_startNode){
					fallbackStartPoint = null;
					index = _startNode.outgoingLinks.indexOf(this);
					if(index ==-1){
						_startNode.outgoingLinks.push(this);
					}
				}
			}
		}
		
		/**
		 * 计算Path的矩形框。 
		 * @param path
		 * @return 
		 * 
		 */
		public static function getPathBounds(path:Path):Rectangle
		{
			var rect:Rectangle = new Rectangle(path.measuredX, path.measuredY, path.measuredWidth, path.measuredHeight);
			var weight:Number = path.stroke == null ? 0 : path.stroke.weight;
			if (weight != 0) 
			{
				rect.width = rect.width + weight;
				rect.height = rect.height + weight;
				rect.x = rect.x - weight / 2;
				rect.y = rect.y - weight / 2;
			}
			return rect;
		}
		
		internal static function getDirection(startPoint:Point, endPoint:Point):int
		{
			var loc1:Number=endPoint.x - startPoint.x;
			var pX:Number=endPoint.y - startPoint.y;
			if (Math.abs(loc1) >= Math.abs(pX)) 
			{
				if (loc1 > 0) 
				{
					return Right;
				}
				return Left;
			}
			if (pX > 0) 
			{
				return Bottom;
			}
			return Top;
		}
		
		internal static function RotateRectangle(rect:Rectangle, dirction:int):void
		{
			var temp:Number=NaN;
			
			switch (dirction) 
			{
				case 1:
				{
					temp = rect.x;
					rect.x = -rect.y - rect.height;
					rect.y = temp;
					temp = rect.width;
					rect.width = rect.height;
					rect.height = temp;
					break;
				}
				case 2:
				{
					rect.x = -rect.x - rect.width;
					rect.y = -rect.y - rect.height;
					break;
				}
				case 3:
				{
					temp = rect.x;
					rect.x = rect.y;
					rect.y = -temp - rect.width;
					temp = rect.width;
					rect.width = rect.height;
					rect.height = temp;
					break;
				}
			}
			return;
		}
		
		internal static function RotatePoint(point:Point, ratate:int):Point
		{
			var rotatePoint:Point = new Point();
			rotatePoint.x = point.x * Math.cos(ratate) - point.y * Math.sin(ratate);
			rotatePoint.y = point.y * Math.cos(ratate) + point.x * Math.sin(ratate);
			
			return rotatePoint;
		}
		
		/**
		 * 绘制图形。 
		 * 
		 */
		public function draw():void{
			var stPoint:Point;
			var enPoint:Point;
			var stSubGraph:SubGraph = null;
			var enSubGraph:SubGraph = null;
			
			if(startNode){
				if(!fallbackStartPoint){
					var stArrCol:ArrayCollection = new ArrayCollection();
					getCollpasedSubGraph(stArrCol,startNode);
					/*if(stArrCol.length>0){
						if(stArrCol[0] is SubGraph){
							stSubGraph = stArrCol[0] as SubGraph;
						}
					}*/
					for(var i:int = stArrCol.length-1 ;i>=0;i--) 
					{
						var stSG:SubGraph = stArrCol[i];
						if(stSG.collapsed){
							stSubGraph = stSG;
							break;
						}
					}
					
					if(stSubGraph){
						stPoint = new Point(stSubGraph.centerX,stSubGraph.centerY);
						stPoint = stSubGraph.parent.localToGlobal(stPoint);
						stPoint = this.parent.globalToLocal(stPoint);
					}else{
						stPoint = new Point(startNode.centerX,startNode.centerY);
						stPoint = startNode.parent.localToGlobal(stPoint);
						stPoint = this.parent.globalToLocal(stPoint);					
					}
				}else{
					stPoint = fallbackStartPoint;
				}
				
			}else{
				if(!fallbackStartPoint){
					stPoint = new Point();
				}else{
					stPoint = fallbackStartPoint;
				}
			}
			
			if(endNode){
				if(!fallbackEndPoint){
					var enArrCol:ArrayCollection = new ArrayCollection();
					getCollpasedSubGraph(enArrCol,endNode);
					/*if(enArrCol.length>0){
						if(enArrCol[0] is SubGraph){
							enSubGraph = enArrCol[0] as SubGraph;
						}
					}*/
					for(var j:int = enArrCol.length-1 ;j>=0;j--) 
					{
						var enSG:SubGraph = enArrCol[i];
						if(enSG.collapsed){
							enSubGraph = enSG;
							break;
						}
					}
					if (enSubGraph){
						enPoint = new Point(enSubGraph.centerX,enSubGraph.centerY);
						enPoint = endNode.parent.localToGlobal(enPoint);
						enPoint = this.parent.globalToLocal(enPoint);
					}else{
						enPoint = new Point(endNode.centerX,endNode.centerY);
						enPoint = endNode.parent.localToGlobal(enPoint);
						enPoint = this.parent.globalToLocal(enPoint);						
					}
				}else{
					enPoint = fallbackEndPoint;
				}
				
			}else{
				if(!fallbackEndPoint){
					enPoint = new Point();
				}else{
					enPoint = fallbackEndPoint;
				}
			}
			
			// path绘图数据。
			var data:String = getData(stPoint,enPoint,stSubGraph,enSubGraph);
			path.data = data;
		}
		
		/**
		 * 通过开始节点，结束节点，线的风格，形状，计算开始箭头，结束箭头的位置，返回字符串数据。 
		 * @return data字符串。
		 * 
		 */
		private function getData(stPoint:Point,enPoint:Point,stSubGraph:SubGraph = null,enSubGraph:SubGraph = null):String
		{
			var data:String = "";
			// 确定连线风格。
			var dashStyle:String = this.getStyle("dashStyle");
			// 
			var fP:Point = stPoint;
			var tP:Point = enPoint;
			//计算终点和起始点形成的角度。
			var linkAngle:Number = Math.atan2(tP.y - fP.y,tP.x - fP.x);
			//如果为直连线的话，那么连线连线的终点箭头就是linkDegree，开始箭头就是linkDegree+180
			var linkDegree:Number = Geometry.rad2deg(linkAngle);
			if(shapeType == LinkShapeType.STRAIGHT){
				var distance:Number;//两点之间的距离。
				var minOffset:Number;
				
				if(startNode){
//					//确定结束节点的高宽比角度。
					var startNodeHWAngle:Number = stSubGraph == null ?Math.atan2(startNode.height,startNode.width):Math.atan2(stSubGraph.collapsedHeight,stSubGraph.collapsedWidth);
					// 计算出终点二分之一宽度对应的弦；
					var sNodeHeightOffset:Number = stSubGraph == null ?startNode.width/2/ Math.cos(linkAngle):stSubGraph.collapsedWidth/2/ Math.cos(linkAngle);
//					// 计算出终点二分之一高度对应的弦；（因为角度的变化，要让终点始终紧贴着终结点，必须找到更小的弦）
					var sNodeWidthOffset:Number = stSubGraph == null ?startNode.height/2/ Math.sin(linkAngle):stSubGraph.collapsedHeight/2/ Math.sin(linkAngle);
//					
					minOffset = Math.min(Math.abs(sNodeHeightOffset),Math.abs(sNodeWidthOffset));
//					minOffset = Math.abs(minOffset);
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
					var endNodeHWAngle:Number = enSubGraph == null ?Math.atan2(endNode.height,endNode.width):Math.atan2(enSubGraph.collapsedHeight,enSubGraph.collapsedWidth);
					// 计算出终点二分之一宽度对应的弦；
					var eNodeHeightOffset:Number = enSubGraph == null ?endNode.width/2/ Math.cos(linkAngle):enSubGraph.collapsedWidth/2/ Math.cos(linkAngle);
					// 计算出终点二分之一高度对应的弦；（因为角度的变化，要让终点始终紧贴着终结点，必须找到更小的弦）
					var eNodeWidthOffset:Number = enSubGraph == null ?endNode.height/2/ Math.sin(linkAngle):enSubGraph.collapsedHeight/2/ Math.sin(linkAngle);
					
					minOffset = Math.min(Math.abs(eNodeHeightOffset),Math.abs(eNodeWidthOffset));
					
//					minOffset = Math.abs(minOffset);
					distance = Point.distance(tP,fP);
//					if(distance>= minOffset){
//						tP = Point.polar(distance -minOffset,linkAngle);
//					}else{
//						if(minOffset == Math.abs(eNodeHeightOffset)){
//							tP = Point.polar(distance +eNodeHeightOffset,linkAngle);
//						}else{
//							tP = Point.polar(distance +eNodeWidthOffset,linkAngle);
//						}
//						
//					}
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
		
		
		private function getCollpasedSubGraph(arr:ArrayCollection,render:Renderer):SubGraph
		{
			if(render.parent is Graph){
				var graph:Graph = Graph(render.parent);
				var parentDoc:Object = graph.parentDocument;
				var parentSubGraph:SubGraph;
				if(parentDoc.hasOwnProperty("hostComponent")){
					var hostComponent:Object = parentDoc["hostComponent"];
					var render1:Renderer;
					if(hostComponent is Renderer){
						render1 = parentDoc["hostComponent"] as Renderer;
					}
					if(render1 is SubGraph){
						parentSubGraph = render1 as SubGraph;
					}
					if(parentSubGraph){
						arr.addItem(parentSubGraph);
						getCollpasedSubGraph(arr,render1);
						return parentSubGraph;
					}else{
						return null;
					}
				}
			}
			
			return null;
		}//getCollpaseSubGraph结束
		
		/**
		 * 获得当前path的矩形框推荐值。 
		 * @return 
		 * 
		 */
		public function getBoundsForMeasure():Rectangle
		{
			this.updateBoundsForMeasure();
			if (this.path != null) 
			{
				return getPathBounds(this.path);
			}
			return new Rectangle();
		}
		
		private final function updateBoundsForMeasure():void
		{
			this.computeShapePoints();
			return;
		}
		/**
		 * 查找开始节点。 
		 * @return 
		 * 
		 */
		public function getVisibleStartNode():Node
		{
			if (!this.startNode) 
			{
				return null;
			}
			if (this.parent == null || this.startNode.parent == this.parent) 
			{
				return this.startNode;
			}
			return this.getRealVisible(this.startNode);
		}
		
		/**
		 * 查找可阅的结束节点。 
		 * @return 
		 * 
		 */
		public function getVisibleEndNode():Node
		{
			if (!this.endNode) 
			{
				return null;
			}
			if (this.parent == null || this.endNode.parent == this.parent) 
			{
				return this.endNode;
			}
			return this.getRealVisible(this.endNode);
		}
		
		/**
		 * 因为子图是可嵌套和缩放的，认为处于收缩状态的子图里面的节点不是可视化节点。 
		 * @param node
		 * @return 
		 * 
		 */
		internal function getRealVisible(node:Node):Node
		{
			var localNode:Node = node;
			while (!(localNode.parent == null) &&
				localNode.parent is Graph &&
				Graph(localNode.parent).owningSubGraph) 
			{
				localNode = Graph(localNode.parent).owningSubGraph;
				if (!(localNode is SubGraph && SubGraph(localNode).collapsed)) 
				{
					continue;
				}
				node = localNode;
			}
			return node;
			
			var subGraph:SubGraph = getParentSubGraph(node.parent);
			while (subGraph) 
			{
				if(!subGraph.collapsed){
					node = subGraph;
					break;
				}
				subGraph = getParentSubGraph(subGraph.parent);
			}
			return node;
		}
		
		/**
		 * 计算连线的形状。 
		 * 
		 */
		internal function computeShapePoints():void
		{
			var realVisialeStartNode:Node = this.getVisibleStartNode();
			var realVisialeEndNode:Node = this.getVisibleEndNode();
			var defaultStartPoint:Point = new Point();
			var defaultEndPoint:Point = new Point();
			var displayObjectContainer:DisplayObjectContainer = this.parent == null ? this : this.parent;
			var startNodeRect:Rectangle;
			var endNodeRect:Rectangle;
			
			if(this.startNode){
				startNodeRect = realVisialeStartNode.getNodeOrBaseBounds(displayObjectContainer);
				defaultStartPoint.x = startNodeRect.x + startNodeRect.width/2;
				defaultStartPoint.y = startNodeRect.y + startNodeRect.height/2;
				
				this.fallbackStartPoint = defaultStartPoint.clone();
			}else{
				defaultStartPoint = this.fallbackStartPoint.clone();
			}

			if(this.endNode){
				endNodeRect = realVisialeEndNode.getNodeOrBaseBounds(displayObjectContainer);
				defaultEndPoint.x = endNodeRect.x + endNodeRect.width/2;
				defaultEndPoint.y = endNodeRect.y + endNodeRect.height/2;
				
				this.fallbackEndPoint = defaultEndPoint.clone();
			}else{
				defaultEndPoint = this.fallbackEndPoint.clone();
			}
			
			var point1:Point =defaultStartPoint;
			var point2:Point =defaultEndPoint;
			var radian:Number=0;
			var minOffset:Number=0; //直连线偏移量。
			var offsetX:Number=0;
			var offsetY:Number=0;
			
			switch(this.shapeType)
			{
				case LinkShapeType.STRAIGHT:
				{
					if (this._shapePoints == null) 
					{
						this._shapePoints = new Vector.<flash.geom.Point>();
					}
					else 
					{
						this._shapePoints.splice(0, this._shapePoints.length);
					}
					
					//计算连接区域的点。
					if(this.startNode){
						if(startConnectionArea == LinkConnectionArea.CENTER){
							//计算开始节点偏移量坐标。
							radian= Math.atan2(point1.y - point2.y, point1.x - point2.x);
							minOffset = Math.min(Math.abs(realVisialeStartNode.width/2/Math.cos(radian)),Math.abs(realVisialeStartNode.height/2/Math.sin(radian)));
							offsetX = minOffset*Math.cos(radian);
							offsetY = minOffset*Math.sin(radian);
							defaultStartPoint.offset(-offsetX,-offsetY);
							
						}else if(startConnectionArea == LinkConnectionArea.LEFT){
							offsetX = Math.abs(realVisialeStartNode.width/2);
							offsetY = 0;
							defaultStartPoint.offset(-offsetX,-offsetY);
						}else if(startConnectionArea == LinkConnectionArea.RIGHT){
							offsetX = Math.abs(realVisialeStartNode.width/2);
							offsetY = 0;
							defaultStartPoint.offset(offsetX,-offsetY);
						}else if(startConnectionArea == LinkConnectionArea.TOP){
							offsetX = 0;
							offsetY = Math.abs(realVisialeStartNode.height/2);
							defaultStartPoint.offset(-offsetX,-offsetY);
						}else if(startConnectionArea == LinkConnectionArea.BOTTOM){
							offsetX = 0;
							offsetY = Math.abs(realVisialeStartNode.height/2);
							defaultStartPoint.offset(-offsetX,offsetY);
						}

						this.fallbackStartPoint = defaultStartPoint.clone();
					}else{
						defaultStartPoint = this.fallbackStartPoint.clone();
					}
					
					if(this.endNode){
						if(endConnectionArea == LinkConnectionArea.CENTER){
							//计算开始节点偏移量坐标。
							radian= Math.atan2(point2.y - point1.y, point2.x - point1.x);
							minOffset = Math.min(Math.abs(realVisialeEndNode.width/2/Math.cos(radian)),Math.abs(realVisialeEndNode.height/2/Math.sin(radian)));
							offsetX = minOffset*Math.cos(radian);
							offsetY = minOffset*Math.sin(radian);
							defaultEndPoint.offset(-offsetX,-offsetY);							
						}else if(endConnectionArea == LinkConnectionArea.LEFT){
							offsetX = Math.abs(realVisialeEndNode.width/2);
							offsetY = 0;
							defaultEndPoint.offset(-offsetX,-offsetY);
						}else if(endConnectionArea == LinkConnectionArea.RIGHT){
							offsetX = Math.abs(realVisialeEndNode.width/2);
							offsetY = 0;
							defaultEndPoint.offset(offsetX,-offsetY);
						}else if(endConnectionArea == LinkConnectionArea.TOP){
							offsetX = 0;
							offsetY = Math.abs(realVisialeEndNode.height/2);
							defaultEndPoint.offset(-offsetX,-offsetY);
						}else if(endConnectionArea == LinkConnectionArea.BOTTOM){
							offsetX = 0;
							offsetY = Math.abs(realVisialeEndNode.height/2);
							defaultEndPoint.offset(-offsetX,offsetY);
						}
						
						this.fallbackEndPoint = defaultEndPoint.clone();
					}else{
						defaultEndPoint = this.fallbackEndPoint.clone();
					}
					
					this._shapePoints.push(defaultStartPoint);
					this._shapePoints.push(defaultEndPoint);
					if(labelElement){
						validateNow();
						radian= Math.atan2(defaultEndPoint.y - defaultStartPoint.y, defaultEndPoint.x - defaultStartPoint.x);
						var labelElementWidth:Number =UIComponent(labelElement).width; 
						var labelElementHeight:Number =UIComponent(labelElement).height; 
//						labelElement.rotation = radian*180/Math.PI;
						labelElement.x = defaultStartPoint.x/2+defaultEndPoint.x/2-labelElementWidth/2;
						labelElement.y = defaultStartPoint.y/2+defaultEndPoint.y/2-labelElementHeight/2;
/*						labelElement.x = defaultStartPoint.x/2+defaultEndPoint.x/2-labelElement.width/2-labelElement.width*Math.sin(radian)/2;;
						labelElement.y = defaultStartPoint.y/2+defaultEndPoint.y/2-labelElement.height/2-labelElement.height*Math.cos(radian)/2;*/
						/*var dx:Number = labelElement.x;
						var dy:Number = labelElement.y;
						labelElement.x = dx * Math.cos(radian) - dy * Math.sin(radian);
						labelElement.y = dy * Math.cos(radian) + dx * Math.sin(radian);*/
					}
					break;
				}
				case LinkShapeType.ORTHOGONAL:
				{
					var startRect:Rectangle;
					var endRect:Rectangle;
					var direction:int = getDirection(defaultStartPoint,defaultEndPoint);
					if (this._shapePoints == null) 
					{
						this._shapePoints = new Vector.<flash.geom.Point>();
					}
					else 
					{
						this._shapePoints.splice(0, this._shapePoints.length);
					}
					
					//计算连接区域的点。
					if(this.startNode){
						if(startConnectionArea == LinkConnectionArea.CENTER){
							//计算开始节点偏移量坐标。
							radian= Math.atan2(point1.y - point2.y, point1.x - point2.x);
							minOffset = Math.min(Math.abs(realVisialeStartNode.width/2/Math.cos(radian)),Math.abs(realVisialeStartNode.height/2/Math.sin(radian)));
							offsetX = minOffset*Math.cos(radian);
							offsetY = minOffset*Math.sin(radian);
							defaultStartPoint.offset(-offsetX,-offsetY);
							//插入第一个起始元素；
//							this._shapePoints.splice(0,0, defaultStartPoint);
							
						}else if(startConnectionArea == LinkConnectionArea.LEFT){
							offsetX = Math.abs(realVisialeStartNode.width/2);
							offsetY = 0;
							defaultStartPoint.offset(-offsetX,-offsetY);
							
							//插入第一个起始元素；
//							this._shapePoints.splice(0,0, defaultStartPoint);
//							this._shapePoints.splice(1,0, defaultStartPoint.clone().offset(-this._orthogonalSpacing,0));
							
						}else if(startConnectionArea == LinkConnectionArea.RIGHT){
							offsetX = Math.abs(realVisialeStartNode.width/2);
							offsetY = 0;
							defaultStartPoint.offset(offsetX,-offsetY);
							
							//插入第一个起始元素；
//							this._shapePoints.splice(0,0, defaultStartPoint);
//							this._shapePoints.splice(1,0, defaultStartPoint.clone().offset(this._orthogonalSpacing,0));
							
						}else if(startConnectionArea == LinkConnectionArea.TOP){
							offsetX = 0;
							offsetY = Math.abs(realVisialeStartNode.height/2);
							defaultStartPoint.offset(-offsetX,-offsetY);
							
							//插入第一个起始元素；
//							this._shapePoints.splice(0,0, defaultStartPoint);
//							this._shapePoints.splice(1,0, defaultStartPoint.clone().offset(0,-this._orthogonalSpacing));
							
						}else if(startConnectionArea == LinkConnectionArea.BOTTOM){
							offsetX = 0;
							offsetY = Math.abs(realVisialeStartNode.height/2);
							defaultStartPoint.offset(-offsetX,offsetY);
							
							//插入第一个起始元素；
//							this._shapePoints.splice(0,0, defaultStartPoint);
//							this._shapePoints.splice(1,0, defaultStartPoint.clone().offset(0,this._orthogonalSpacing));
							
						}
						
						this.fallbackStartPoint = defaultStartPoint.clone();
						
						if(this.parent){
							startRect = this.startNode.getNodeOrBaseBounds(this.parent);
						}else{
							startRect = new Rectangle(defaultStartPoint.x,defaultStartPoint.y);
						}
						
					}else{
						defaultStartPoint = this.fallbackStartPoint.clone();
						
						startRect = new Rectangle(defaultStartPoint.x,defaultStartPoint.y);
					}
					
					if(this.endNode){
						if(endConnectionArea == LinkConnectionArea.CENTER){
							//计算开始节点偏移量坐标。
							radian= Math.atan2(point2.y - point1.y, point2.x - point1.x);
							minOffset = Math.min(Math.abs(realVisialeEndNode.width/2/Math.cos(radian)),Math.abs(realVisialeEndNode.height/2/Math.sin(radian)));
							offsetX = minOffset*Math.cos(radian);
							offsetY = minOffset*Math.sin(radian);
							defaultEndPoint.offset(-offsetX,-offsetY);	
							
							//插入最后元素；
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint);
							
						}else if(endConnectionArea == LinkConnectionArea.LEFT){
							offsetX = Math.abs(realVisialeEndNode.width/2);
							offsetY = 0;
							defaultEndPoint.offset(-offsetX,-offsetY);
							
							//插入最后元素；
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint);
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint.clone().offset(-this._orthogonalSpacing,0));
							
						}else if(endConnectionArea == LinkConnectionArea.RIGHT){
							offsetX = Math.abs(realVisialeEndNode.width/2);
							offsetY = 0;
							defaultEndPoint.offset(offsetX,-offsetY);
							//插入最后元素；
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint);
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint.clone().offset(this._orthogonalSpacing,0));
							
						}else if(endConnectionArea == LinkConnectionArea.TOP){
							offsetX = 0;
							offsetY = Math.abs(realVisialeEndNode.height/2);
							defaultEndPoint.offset(-offsetX,-offsetY);
							
							//插入最后元素；
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint);
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint.clone().offset(0,-this._orthogonalSpacing));
							
						}else if(endConnectionArea == LinkConnectionArea.BOTTOM){
							offsetX = 0;
							offsetY = Math.abs(realVisialeEndNode.height/2);
							defaultEndPoint.offset(-offsetX,offsetY);
							
							//插入最后元素；
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint);
//							this._shapePoints.splice(this._shapePoints.length,0, defaultEndPoint.clone().offset(0,this._orthogonalSpacing));
						}
						
						this.fallbackEndPoint = defaultEndPoint.clone();
						
						if(this.parent){
							endRect = this.endNode.getNodeOrBaseBounds(this.parent);
						}else{
							endRect = new Rectangle(defaultEndPoint.x,defaultEndPoint.y);
						}
						
					}else{
						defaultEndPoint = this.fallbackEndPoint.clone();
						
						endRect = new Rectangle(defaultEndPoint.x,defaultEndPoint.y);
					}
					
					
					computeOrthogonal(defaultStartPoint,startRect,defaultEndPoint,endRect,this._shapePoints);
					if(labelElement){
						validateNow();
						var avg:int = this._shapePoints.length/2;
						labelElement.x = this._shapePoints[avg].x/2+this._shapePoints[avg+1].x/2-labelElement.width/2;
						labelElement.y = this._shapePoints[avg].y/2+this._shapePoints[avg+1].y/2-labelElement.height/2;
					}
				}	
				default:
				{
					break;
				}
			}
		}
		
		
		/**
		 * 计算正交线。 
		 * @param startPoint
		 * @param endPoint
		 * @param shapePoints
		 * 
		 */
		internal function computeOrthogonal(startPoint:Point,startRect:Rectangle, endPoint:Point, endRect:Rectangle,shapePoints:Vector.<Point>):void
		{
			var direction:int = getDirection(startPoint,endPoint);
			
			/*var rotateDe:int = 0;
			switch (direction) 
			{
				case Top:
				{
					break;
				}
				case Bottom:
				{
					rotateDe = 2;
					break;
				}
				case Left:
				{
					rotateDe = 1;
					break;
				}
				case Right:
				{
					rotateDe = 3;
					break;
				}
			}
			
			RotatePoint(startPoint, rotateDe);
			RotateRectangle(startRect, rotateDe);
			
			RotatePoint(endPoint, rotateDe);
			RotateRectangle(endRect, rotateDe);
			var pX:Number;
			var pY:Number;
			switch(direction){
				case Top:
					if (endRect.bottom < startRect.top) 
					{
						if (endRect.left > startPoint.x || endRect.right < startPoint.x) 
						{
							pY = Math.min(startRect.top, endRect.top) - this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(startPoint.x, pY));
							shapePoints.push(new flash.geom.Point(endPoint.x, pY));
						}
						else 
						{
							pY = (startPoint.y + endRect.bottom) / 2;
							shapePoints.push(new flash.geom.Point(startPoint.x, pY));
							if (endPoint.x > startPoint.x) 
							{
								pX = endRect.left - this._orthogonalSpacing;
							}
							else 
							{
								pX = endRect.right + this._orthogonalSpacing;
							}
							shapePoints.push(new flash.geom.Point(pX, pY));
							pY = endRect.top - this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(pX, pY));
							shapePoints.push(new flash.geom.Point(endPoint.x, pY));
						}
					}
					else if (endRect.top > startRect.bottom) 
					{
						if (endPoint.x > startRect.right || endPoint.x < startRect.left) 
						{
							pY = Math.min(startRect.top, endRect.top) - this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(startPoint.x, pY));
							shapePoints.push(new flash.geom.Point(endPoint.x, pY));
						}
						else 
						{
							pY = startRect.top - this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(startPoint.x, pY));
							if (endPoint.x < startPoint.x) 
							{
								pX = startRect.left - this._orthogonalSpacing;
							}
							else 
							{
								pX = startRect.right + this._orthogonalSpacing;
							}
							shapePoints.push(new flash.geom.Point(pX, pY));
							pY = (endPoint.y + startRect.bottom) / 2;
							shapePoints.push(new flash.geom.Point(pX, pY));
							shapePoints.push(new flash.geom.Point(endPoint.x, pY));
						}
					}
					else 
					{
						pY = Math.min(startRect.top, endRect.top) - this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(startPoint.x, pY));
						shapePoints.push(new flash.geom.Point(endPoint.x, pY));
					}
				break;
				
				case Bottom:
					if (endPoint.y < startPoint.y) 
					{
						if (endPoint.x != startPoint.x) 
						{
							pY = (startPoint.y + endPoint.y) / 2;
							shapePoints.push(new flash.geom.Point(startPoint.x, pY));
							shapePoints.push(new flash.geom.Point(endPoint.x, pY));
						}
					}
					else if (endRect.left > startRect.right || endRect.right < startRect.left) 
					{
						pY = startRect.top - this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(startPoint.x, pY));
						if (endRect.left > startRect.right) 
						{
							pX = (endRect.left + startRect.right) / 2;
						}
						else 
						{
							pX = (endRect.right + startRect.left) / 2;
						}
						shapePoints.push(new flash.geom.Point(pX, pY));
						pY = endRect.bottom + this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(pX, pY));
						shapePoints.push(new flash.geom.Point(endPoint.x, pY));
					}
					else 
					{
						pY = Math.min(startRect.top, endRect.top) - this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(startPoint.x, pY));
						if (endPoint.x > startPoint.x) 
						{
							pX = Math.max(startRect.right, endRect.right) + this._orthogonalSpacing;
						}
						else 
						{
							pX = Math.min(startRect.left, endRect.left) - this._orthogonalSpacing;
						}
						shapePoints.push(new flash.geom.Point(pX, pY));
						pY = endRect.bottom + this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(pX, pY));
						shapePoints.push(new flash.geom.Point(endPoint.x, pY));
					}
				break;
				
				case Left:
					if (endRect.left < startPoint.x) 
					{
						if (endRect.bottom < startPoint.y) 
						{
							pY = (startPoint.y + endRect.bottom) / 2;
							shapePoints.push(new flash.geom.Point(startPoint.x, pY));
							pX = endRect.left - this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(pX, pY));
							shapePoints.push(new flash.geom.Point(pX, endPoint.y));
						}
						else 
						{
							pY = Math.min(endRect.top, startRect.top) - this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(startPoint.x, pY));
							pX = Math.min(endRect.left, startRect.left) - this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(pX, pY));
							shapePoints.push(new flash.geom.Point(pX, endPoint.y));
						}
					}
					else if (endPoint.y < startRect.top) 
					{
						shapePoints.push(new flash.geom.Point(startPoint.x, endPoint.y));
					}
					else if (endRect.left > startRect.right) 
					{
						pY = startRect.top - this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(startPoint.x, pY));
						pX = (startRect.right + endRect.left) / 2;
						shapePoints.push(new flash.geom.Point(pX, pY));
						shapePoints.push(new flash.geom.Point(pX, endPoint.y));
					}
					else 
					{
						pY = Math.min(endRect.top, startRect.top) - this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(startPoint.x, pY));
						pX = Math.min(endRect.left, startRect.left) - this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(pX, pY));
						shapePoints.push(new flash.geom.Point(pX, endPoint.y));
					}
				break;
				
				case Right:
					if (endRect.right > startPoint.x) 
					{
						if (endRect.bottom < startPoint.y) 
						{
							pY = (startPoint.y + endRect.bottom) / 2;
							shapePoints.push(new Point(startPoint.x, pY));
							pX = endRect.right + this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(pX, pY));
							shapePoints.push(new flash.geom.Point(pX, endPoint.y));
						}
						else 
						{
							pY = Math.min(endRect.top, startRect.top) - this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(startPoint.x, pY));
							pX = Math.max(endRect.right, startRect.right) + this._orthogonalSpacing;
							shapePoints.push(new flash.geom.Point(pX, pY));
							shapePoints.push(new flash.geom.Point(pX, endPoint.y));
						}
					}
					else if (endPoint.y < startRect.top) 
					{
						shapePoints.push(new flash.geom.Point(startPoint.x, endPoint.y));
					}
					else if (endRect.right < startRect.left) 
					{
						pY = startRect.top - this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(startPoint.x, pY));
						pX = (startRect.left + endRect.right) / 2;
						shapePoints.push(new flash.geom.Point(pX, pY));
						shapePoints.push(new flash.geom.Point(pX, endPoint.y));
					}
					else 
					{
						pY = Math.min(endRect.top, startRect.top) - this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(startPoint.x, pY));
						pX = Math.max(endRect.right, startRect.right) + this._orthogonalSpacing;
						shapePoints.push(new flash.geom.Point(pX, pY));
						shapePoints.push(new flash.geom.Point(pX, endPoint.y));
					}
				break;
				
			}*/
			//// 计算偏移量，决定起始终点。
			/*startPoint = computeStartConnectAreaOffsetPoint(startPoint,false);
			endPoint = computeEndConnectAreaOffsetPoint(endPoint,false);*/

			var cloneStartPoint:Point = startPoint.clone();
			if(startConnectionArea != LinkConnectionArea.CENTER){
				cloneStartPoint = computeStartConnectAreaOffsetPoint(cloneStartPoint,false);	
				shapePoints.push(cloneStartPoint);
				startPoint = computeStartConnectAreaOffsetPoint(startPoint);			
			}
			
			shapePoints.push(startPoint);
			
			var cloneEndPoint:Point = endPoint.clone();			
			if(this.endConnectionArea != LinkConnectionArea.CENTER){
				endPoint = computeEndConnectAreaOffsetPoint(endPoint);
			}
			
			var middle:Point = new Point(startPoint.x/2+endPoint.x/2,startPoint.y/2+endPoint.y/2);
			
			switch(direction){
				case Left:
					if(endPoint.y <=startPoint.y){
						shapePoints.push(new Point(middle.x,startPoint.y));
						shapePoints.push(new Point(middle.x,endPoint.y));
					}else{
						shapePoints.push(new Point(endPoint.x,startPoint.y));
					}
					break;
				
				case Top:
					shapePoints.push(new Point(startPoint.x,middle.y));
					shapePoints.push(new Point(endPoint.x,middle.y));
					break;
				
				case Right:
					if(endPoint.y <=startPoint.y){
						shapePoints.push(new Point(middle.x,startPoint.y));
						shapePoints.push(new Point(middle.x,endPoint.y));
					}else{
						shapePoints.push(new Point(endPoint.x,startPoint.y));
					}
					
					break;
				
				case Bottom:
					shapePoints.push(new Point(startPoint.x,middle.y));
					shapePoints.push(new Point(endPoint.x,middle.y));
					break;
			}
			
			if(this.endConnectionArea != LinkConnectionArea.CENTER){
				shapePoints.push(endPoint);
				cloneEndPoint = computeEndConnectAreaOffsetPoint(cloneEndPoint,false);	
			}
			
			shapePoints.push(cloneEndPoint);
			
			
			
			///---------------------------------------------------------------------------
			/// 分类讨论。
			///---------------------------------------------------------------------------
			/*startPoint = computeStartConnectAreaOffsetPoint(startPoint);
			endPoint = computeEndConnectAreaOffsetPoint(endPoint);
			shapePoints.push(startPoint);
			if(startConnectionArea == LinkConnectionArea.RIGHT){
				shapePoints.push(new Point(startPoint.x+this._orthogonalSpacing,startPoint.y));	
				if(endConnectionArea == LinkConnectionArea.LEFT){
					//左对左
					shapePoints.push(new Point(startPoint.x+this._orthogonalSpacing,endPoint.y));
					shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,endPoint.y));
					
				}else if(endConnectionArea == LinkConnectionArea.BOTTOM){
					//左对底
					shapePoints.push(new Point(startPoint.x+this._orthogonalSpacing,endPoint.y+this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x,endPoint.y+this._orthogonalSpacing));
					
				}else if(endConnectionArea == LinkConnectionArea.TOP){
					//左对上
					shapePoints.push(new Point(endPoint.x,startPoint.y));
					shapePoints.push(new Point(endPoint.x,endPoint.y-this._orthogonalSpacing));
					
				}else if(endConnectionArea == LinkConnectionArea.RIGHT){
					//左对右
					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,startPoint.y));
					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,endPoint.y));
					
				}else{
					if(endConnectionArea == LinkConnectionArea.CENTER){
						middle.x = shapePoints[1].x/2+endPoint.x/2;
						middle.y = shapePoints[1].y/2+endPoint.y/2;
						startPoint = shapePoints[1];
						switch(direction)
						{
							case Top:
							{
								shapePoints.push(new Point(startPoint.x,middle.y));
								shapePoints.push(new Point(endPoint.x,middle.y));
								break;
							}
							case Bottom:
							{
								shapePoints.push(new Point(startPoint.x,middle.y));
								shapePoints.push(new Point(endPoint.x,middle.y));
								break;
							}
							case Right:
							{
								shapePoints.push(new Point(middle.x,startPoint.y));
								shapePoints.push(new Point(middle.x,endPoint.y));
								break;
							}
							case Left:
							{
								shapePoints.push(new Point(middle.x,startPoint.y));
								shapePoints.push(new Point(middle.x,endPoint.y));
								break;
							}
								
							default:
							{
								break;
							}
						}
					}	
				}
			}else if(startConnectionArea == LinkConnectionArea.LEFT){
				shapePoints.push(new Point(startPoint.x-this._orthogonalSpacing,startPoint.y));	
				if(endConnectionArea == LinkConnectionArea.LEFT){
					//左对左
					shapePoints.push(new Point(startPoint.x-this._orthogonalSpacing,endPoint.y));
					shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,endPoint.y));
					
				}else if(endConnectionArea == LinkConnectionArea.BOTTOM){
					//左对底
					shapePoints.push(new Point(startPoint.x-this._orthogonalSpacing,endPoint.y+this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x,endPoint.y+this._orthogonalSpacing));
					
				}else if(endConnectionArea == LinkConnectionArea.TOP){
					//左对上
					shapePoints.push(new Point(endPoint.x,startPoint.y));
					shapePoints.push(new Point(endPoint.x,endPoint.y-this._orthogonalSpacing));
					
				}else if(endConnectionArea == LinkConnectionArea.RIGHT){
					//左对右
					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,startPoint.y));
					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,endPoint.y));
					
				}else{
					if(endConnectionArea == LinkConnectionArea.CENTER){
						middle.x = shapePoints[1].x/2+endPoint.x/2;
						middle.y = shapePoints[1].y/2+endPoint.y/2;
						startPoint = shapePoints[1];
						switch(direction)
						{
							case Top:
							{
								shapePoints.push(new Point(startPoint.x,middle.y));
								shapePoints.push(new Point(endPoint.x,middle.y));
								break;
							}
							case Bottom:
							{
								shapePoints.push(new Point(startPoint.x,middle.y));
								shapePoints.push(new Point(endPoint.x,middle.y));
								break;
							}
							case Right:
							{
								shapePoints.push(new Point(middle.x,startPoint.y));
								shapePoints.push(new Point(middle.x,endPoint.y));
								break;
							}
							case Left:
							{
								shapePoints.push(new Point(middle.x,startPoint.y));
								shapePoints.push(new Point(middle.x,endPoint.y));
								break;
							}
								
							default:
							{
								break;
							}
						}
					}	
				}
			}else if(startConnectionArea == LinkConnectionArea.TOP){
				shapePoints.push(new Point(startPoint.x,startPoint.y-this._orthogonalSpacing));	
				if(endConnectionArea == LinkConnectionArea.LEFT){
					//上对左
					shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,startPoint.y-this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,endPoint.y));
					
				}else if(endConnectionArea == LinkConnectionArea.BOTTOM){
					//上对底
					shapePoints.push(new Point(startPoint.x,endPoint.y+this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x,endPoint.y+this._orthogonalSpacing));
					
				}else if(endConnectionArea == LinkConnectionArea.TOP){
					//上对上
					shapePoints.push(new Point(endPoint.x,startPoint.y-this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x,endPoint.y-this._orthogonalSpacing));
					
				}else if(endConnectionArea == LinkConnectionArea.RIGHT){
					// 上对右
					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,startPoint.y-this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,endPoint.y));
					
				}else{
					if(endConnectionArea == LinkConnectionArea.CENTER){
						middle.x = shapePoints[1].x/2+endPoint.x/2;
						middle.y = shapePoints[1].y/2+endPoint.y/2;
						startPoint = shapePoints[1];
						switch(direction)
						{
							case Top:
							{
								shapePoints.push(new Point(startPoint.x,middle.y));
								shapePoints.push(new Point(endPoint.x,middle.y));
								break;
							}
							case Bottom:
							{
								shapePoints.push(new Point(startPoint.x,middle.y));
								shapePoints.push(new Point(endPoint.x,middle.y));
								break;
							}
							case Right:
							{
								shapePoints.push(new Point(middle.x,startPoint.y));
								shapePoints.push(new Point(middle.x,endPoint.y));
								break;
							}
							case Left:
							{
								shapePoints.push(new Point(middle.x,startPoint.y));
								shapePoints.push(new Point(middle.x,endPoint.y));
								break;
							}
								
							default:
							{
								break;
							}
						}
					}	
				}
			}else if(startConnectionArea == LinkConnectionArea.BOTTOM){
				shapePoints.push(new Point(startPoint.x,startPoint.y+this._orthogonalSpacing));	
				if(endConnectionArea == LinkConnectionArea.LEFT){
					//下对左
//					if(startPoint.y+this._orthogonalSpacing >= endPoint.y){
//						shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,startPoint.y+this._orthogonalSpacing));
//					}else{
//						if(startPoint.x<endPoint.x-this._orthogonalSpacing){
//							shapePoints.push(new Point(startPoint.x,endPoint.y));
//						}else{
//							if(endPoint.y-endRect.height/2-this._orthogonalSpacing>=startPoint.y+this._orthogonalSpacing){
//								shapePoints.push(new Point(startPoint.x,endPoint.y-endRect.height/2-this._orthogonalSpacing));
//								shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,endPoint.y-endRect.height/2-this._orthogonalSpacing));						
//							}else{
//								shapePoints.push(new Point(startPoint.x,startPoint.y+this._orthogonalSpacing));
//								shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,startPoint.y+this._orthogonalSpacing));
//							}
//							
//						}
//					}
//					
//					shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,endPoint.y));
//					
					shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,startPoint.y+this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x-this._orthogonalSpacing,endPoint.y));
				}else if(endConnectionArea == LinkConnectionArea.BOTTOM){
					//下对底
					if(startPoint.y+this._orthogonalSpacing >= endPoint.y+this._orthogonalSpacing){
						shapePoints.push(new Point(startPoint.x,startPoint.y+this._orthogonalSpacing));
						shapePoints.push(new Point(endPoint.x,startPoint.y+this._orthogonalSpacing));
					}else{
						shapePoints.push(new Point(startPoint.x,endPoint.y+this._orthogonalSpacing));
					}
					
					shapePoints.push(new Point(endPoint.x,endPoint.y+this._orthogonalSpacing));
					
				}else if(endConnectionArea == LinkConnectionArea.TOP){
					//下对上
//					if(startPoint.y+this._orthogonalSpacing >= endPoint.y-this._orthogonalSpacing){
//						if(endPoint.x+endRect.width/2+this._orthogonalSpacing<= startPoint.x){
//							shapePoints.push(new Point(endPoint.x+endRect.width/2+this._orthogonalSpacing,startPoint.y+this._orthogonalSpacing));
//							shapePoints.push(new Point(endPoint.x+endRect.width/2+this._orthogonalSpacing,endPoint.y-this._orthogonalSpacing));
//						}else{
//							shapePoints.push(new Point(endPoint.x-endRect.width/2-this._orthogonalSpacing,startPoint.y+this._orthogonalSpacing));
//							shapePoints.push(new Point(endPoint.x-endRect.width/2-this._orthogonalSpacing,endPoint.y-this._orthogonalSpacing));							
//						}
//					}else{
//						shapePoints.push(new Point(endPoint.x,startPoint.y+this._orthogonalSpacing));					
//					}
//					shapePoints.push(new Point(endPoint.x,endPoint.y-this._orthogonalSpacing));
//					
					shapePoints.push(new Point(endPoint.x,startPoint.y+this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x,endPoint.y-this._orthogonalSpacing));
				}else if(endConnectionArea == LinkConnectionArea.RIGHT){
					// 下对右
//					if(startPoint.y+this._orthogonalSpacing >= endPoint.y){
//						shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,startPoint.y+this._orthogonalSpacing));					
//					}else{
//						if(endPoint.x+this._orthogonalSpacing<= startPoint.x){
//							shapePoints.push(new Point(startPoint.x,endPoint.y));
//						}else{
//							if(endPoint.y-endRect.height/2-this._orthogonalSpacing>= startPoint.y+this._orthogonalSpacing){
//								shapePoints.push(new Point(startPoint.x,endPoint.y-endRect.height/2-this._orthogonalSpacing));
//								shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,endPoint.y-endRect.height/2-this._orthogonalSpacing));							
//							}else{
//								shapePoints.push(new Point(startPoint.x,startPoint.y+this._orthogonalSpacing));
//								shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,startPoint.y+this._orthogonalSpacing));
//							}
//						}
//						
//					}
//					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,endPoint.y));
//					
					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,startPoint.y+this._orthogonalSpacing));
					shapePoints.push(new Point(endPoint.x+this._orthogonalSpacing,endPoint.y));
					
				}else{
					if(endConnectionArea == LinkConnectionArea.CENTER){
						middle.x = shapePoints[1].x/2+endPoint.x/2;
						middle.y = shapePoints[1].y/2+endPoint.y/2;
						startPoint = shapePoints[1];
						switch(direction)
						{
							case Top:
							{
								shapePoints.push(new Point(startPoint.x,middle.y));
								shapePoints.push(new Point(endPoint.x,middle.y));
								break;
							}
							case Bottom:
							{
								shapePoints.push(new Point(startPoint.x,middle.y));
								shapePoints.push(new Point(endPoint.x,middle.y));
								break;
							}
							case Right:
							{
								shapePoints.push(new Point(middle.x,startPoint.y));
								shapePoints.push(new Point(middle.x,endPoint.y));
								break;
							}
							case Left:
							{
								shapePoints.push(new Point(middle.x,startPoint.y));
								shapePoints.push(new Point(middle.x,endPoint.y));
								break;
							}
								
							default:
							{
								break;
							}
						}
					}	
				}
			}else{
				if(endConnectionArea == LinkConnectionArea.CENTER){
					switch(direction)
					{
						case Top:
						{
							shapePoints.push(new Point(startPoint.x,middle.y));
							shapePoints.push(new Point(endPoint.x,middle.y));
							break;
						}
						case Bottom:
						{
							shapePoints.push(new Point(startPoint.x,middle.y));
							shapePoints.push(new Point(endPoint.x,middle.y));
							break;
						}
						case Right:
						{
							shapePoints.push(new Point(middle.x,startPoint.y));
							shapePoints.push(new Point(middle.x,endPoint.y));
							break;
						}
						case Left:
						{
							shapePoints.push(new Point(middle.x,startPoint.y));
							shapePoints.push(new Point(middle.x,endPoint.y));
							break;
						}
							
						default:
						{
							break;
						}
					}
				}					
			}
			
			shapePoints.push(endPoint);*/
		}
		
		/**
		 * 获取起始节点的连接区域个数。 
		 * @return 
		 * 
		 */
		internal function getStartConnectAreaCount():int{
			var count:int = 0;
			
			//如果在中间，默认为0。
			if(this.startConnectionArea == LinkConnectionArea.CENTER){
				return count;
			}
			
			var startLinks:Vector.<Link>;
			
			if(this.startNode){
				startLinks = this.startNode.getLinks();
			}
			
			var ilink:Link;
			
			for each (ilink in startLinks) 
			{
				if(ilink.startConnectionArea != this.startConnectionArea
					&&ilink.endConnectionArea != this.startConnectionArea){
					continue;
				}
				if(ilink.startConnectionArea == this.startConnectionArea ||
					ilink.endConnectionArea == this.startConnectionArea){
					count++;
				}
			}
			
			return count;
		}
		/**
		 * 获取起始节点的连接区域偏移量。 
		 * @return 
		 * 
		 */
		internal function computeStartConnectAreaOffset():Number{
			var count:int = getStartConnectAreaCount();
			var offset:Number = 0;
			
			//如果在中间，默认为0。
			if(count == 0){
				return offset;
			}
			
			var startLinks:Vector.<Link>;
			
			if(this.startNode){
				startLinks = this.startNode.getLinks();
			}
			
			var ilink:Link;
			var n:int = 0;//n表示计算出连线在第几条
			
			for each (ilink in startLinks) 
			{
				if(ilink.startConnectionArea != this.startConnectionArea
					&&ilink.endConnectionArea != this.startConnectionArea){
					continue;
				}
				if(ilink.startConnectionArea == this.startConnectionArea
					||ilink.endConnectionArea == this.startConnectionArea){
					if(ilink == this){
						break;
					}else{
						n++;					
					}
				}
			}
			
			offset = n * connectingAreaOffset - (count-1)* connectingAreaOffset/2;
			
			return offset;
		}
		
		/**
		 * 计算开始连接区域的偏移量Point。 
		 * @param startPoint
		 * @return 
		 * 
		 */
		internal function computeStartConnectAreaOffsetPoint(startPoint:Point,includeOrthSpacing:Boolean = true):Point{
			var offset:Number = computeStartConnectAreaOffset();
			//-----------
			// 如果是纵向那么添加纵向偏移量，横向则添加横向偏移量。
			//-----------
			
			if(this.startConnectionArea == LinkConnectionArea.TOP ){
				if(includeOrthSpacing)
					startPoint.offset(offset,-this._orthogonalSpacing);
				else
					startPoint.offset(offset,0);
			}else if(this.startConnectionArea == LinkConnectionArea.BOTTOM){
				if(includeOrthSpacing)
					startPoint.offset(offset,this._orthogonalSpacing);
				else
					startPoint.offset(offset,0);
			}else if(this.startConnectionArea == LinkConnectionArea.LEFT){
				if(includeOrthSpacing)
					startPoint.offset(-this._orthogonalSpacing,offset);
				else
					startPoint.offset(0,offset);
			}else if(this.startConnectionArea == LinkConnectionArea.RIGHT){
				if(includeOrthSpacing)
					startPoint.offset(this._orthogonalSpacing,offset);
				else
					startPoint.offset(0,offset);
			} 
			
			return startPoint;
		}
		/**
		 * 获取结束节点的连接区域个数。 
		 * @return 
		 * 
		 */
		internal function getEndConnectAreaCount():int{
			var count:int = 0;
			
			//如果在中间，默认为0。
			if(this.endConnectionArea == LinkConnectionArea.CENTER){
				return count;
			}
			
			var endLinks:Vector.<Link>;
			
			if(this.endNode){
				endLinks = this.endNode.getLinks();
			}
			
			var ilink:Link;
			
			for each (ilink in endLinks) 
			{
				if(ilink.startConnectionArea != this.endConnectionArea
					&&ilink.endConnectionArea != this.endConnectionArea){
					continue;
				}
				
				if(ilink.startConnectionArea == this.endConnectionArea ||
					ilink.endConnectionArea == this.endConnectionArea){
					count++;
				}
			}
			
			return count;
		}
		/**
		 * 获取结束节点的连接区域偏移量。 
		 * @return 
		 * 
		 */
		internal function computeEndConnectAreaOffset():Number{
			var count:int = getEndConnectAreaCount();
			var offset:Number = 0;
			
			//如果在中间，默认为0。
			if(count == 0){
				return offset;
			}
			
			var endLinks:Vector.<Link>;
			
			if(this.endNode){
				endLinks = this.endNode.getLinks();
			}
			
			var ilink:Link;
			var n:int = 0;//n表示计算出连线在第几条
			
			for each (ilink in endLinks) 
			{
				if(ilink.startConnectionArea != this.endConnectionArea
					&&ilink.endConnectionArea != this.endConnectionArea){
					continue;
				}
				
				if(ilink.startConnectionArea == this.endConnectionArea
					||ilink.endConnectionArea == this.endConnectionArea){
					if(ilink == this){
						break;
					}else{
						n++;					
					}
				}
			}
			
			offset = n * connectingAreaOffset - (count-1)* connectingAreaOffset/2;
			
			return offset;
		}
		
		/**
		 * 计算结束连接区域的偏移量。 
		 * @param endPoint
		 * @return 
		 * 
		 */
		internal function computeEndConnectAreaOffsetPoint(endPoint:Point,includeOrthSpacing:Boolean = true):Point{
			
			var offset:Number = computeEndConnectAreaOffset();
			//-----------
			// 如果是纵向那么添加纵向偏移量，横向则添加横向偏移量。
			//-----------
			if(this.endConnectionArea == LinkConnectionArea.TOP ){
				if(includeOrthSpacing)
					endPoint.offset(offset,-this._orthogonalSpacing);
				else
					endPoint.offset(offset,0);
			}else if(this.endConnectionArea == LinkConnectionArea.BOTTOM){
				if(includeOrthSpacing)
					endPoint.offset(offset,this._orthogonalSpacing);
				else
					endPoint.offset(offset,0);
			}else if(this.endConnectionArea == LinkConnectionArea.LEFT){
				if(includeOrthSpacing)
					endPoint.offset(-this._orthogonalSpacing,offset);
				else
					endPoint.offset(0,offset);
			}else if(this.endConnectionArea == LinkConnectionArea.RIGHT){
				if(includeOrthSpacing)
					endPoint.offset(this._orthogonalSpacing,offset);
				else
					endPoint.offset(0,offset);
			} 
			
			return endPoint;
		}
		
		/**
		 * 得到上级子图。 
		 * @param object
		 * @return 
		 * 
		 */
		internal static function getParentSubGraph(object:Object):SubGraph{
			while (object is DisplayObject) 
			{
				if (object is SubGraph) 
				{
					return SubGraph(object);
				}
				object = object.parent;
			}
			return null;
		}
		/**
		 * 刷新连线形状。 
		 * 
		 */
		public function invalidateShape():void
		{
			/*if (!this.getFlag(LinkShapeChangeFlag) || this.getFlag(ShapePointsUpToDateFlag)) 
			{
				this.setFlag(LinkShapeChangeFlag, true);
				this.setFlag(ShapePointsUpToDateFlag, false);
				invalidateProperties();
			}*/
			_shapeTypeChange = true;
			invalidateProperties();
			return;
		}
		
		private function createDashRoundPolyline(shapePoints:Vector.<Point>,radius:Number):String{
			var data:String;
			var point:Point;
			if(shapeType == "straight"){
				for each (point in shapePoints) 
				{
					if(point == shapePoints[0]){
						data = "M "+point.x+" "+point.y+" ";
					}else{
						data+="L "+point.x+" "+point.y+" ";					
					}
				}
				
			}else if(shapeType == LinkShapeType.ORTHOGONAL){
				for(var i:int = 0;i<shapePoints.length;i++) 
				{
					point = shapePoints[i];
					if(point == shapePoints[0]){
						data = "M "+point.x+" "+point.y+" ";
					}else{
						var prevPoint:Point = shapePoints[i-1];
						var nextPoint:Point;
						if(i+1<shapePoints.length){
							nextPoint = shapePoints[i+1];
							if(point.x != prevPoint.x && prevPoint.x != nextPoint.x && prevPoint.y != nextPoint.y){
								
								if(point.x > prevPoint.x){
									data+="L "+(point.x-radius)+" "+point.y+" ";
									if(point.y >= prevPoint.y){
										data+="Q "+point.x+" "+point.y;	
										if(point.y <= nextPoint.y){
											data+=" "+point.x+" "+(point.y+radius)+" ";
										}else{
											data+=" "+point.x+" "+(point.y-radius)+" ";
										}
									}else{
										data+="Q "+point.x+" "+point.y;	
										if(point.y <= nextPoint.y){
											data+=" "+point.x+" "+(point.y+radius)+" ";
										}else{
											data+=" "+point.x+" "+(point.y-radius)+" ";
										}
									}
								}else{
									data+="L "+(point.x+radius)+" "+point.y+" ";
									if(point.y >= prevPoint.y){
										data+="Q "+point.x+" "+point.y+" ";	
										if(point.y <= nextPoint.y){
											data+=" "+point.x+" "+(point.y+radius)+" ";
										}else{
											data+=" "+point.x+" "+(point.y-radius)+" ";
										}									
									}else{
										data+="Q "+point.x+" "+point.y+" ";	
										if(point.y <= nextPoint.y){
											data+=" "+point.x+" "+(point.y+radius)+" ";
										}else{
											data+=" "+point.x+" "+(point.y-radius)+" ";
										}
									}	
								}
							}else if(point.y != prevPoint.y && prevPoint.x != nextPoint.x && prevPoint.y != nextPoint.y){
								if(point.y > prevPoint.y){
									data+="L "+point.x+" "+(point.y-radius)+" ";
									if(point.x >= prevPoint.x){
										data+="Q "+point.x+" "+point.y;	
										if(point.x <= nextPoint.x){
											data+=" "+(point.x+radius)+" "+point.y+" ";
										}else{
											data+=" "+(point.x-radius)+" "+point.y+" ";
										}
									}else{
										data+="Q "+point.x+" "+point.y;	
										if(point.x <= nextPoint.x){
											data+=" "+(point.x+radius)+" "+point.y+" ";
										}else{
											data+=" "+(point.x-radius)+" "+point.y+" ";
										}
									}
								}else{
									data+="L "+point.x+" "+(point.y+radius)+" ";
									if(point.x >= prevPoint.x){
										data+="Q "+point.x+" "+point.y;	
										if(point.x <= nextPoint.x){
											data+=" "+(point.x+radius)+" "+point.y+" ";
										}else{
											data+=" "+(point.x-radius)+" "+point.y+" ";
										}								
									}else{
										data+="Q "+point.x+" "+point.y;	
										if(point.x <= nextPoint.x){
											data+=" "+(point.x+radius)+" "+point.y+" ";
										}else{
											data+=" "+(point.x-radius)+" "+point.y+" ";
										}
									}
								}
							}else{
								data+="L "+point.x+" "+point.y+" ";
							}
						}else{
							data+="L "+point.x+" "+point.y+" ";						
						}
					}
				}
				
			}
			return data;
		}
		
		/*private function computeQ(point1:Point,point2:Point,point3:Point):String{
			var data:String = "";
			data += "L "+point1.x+" " +point1.y;
			data += "Q "+point2.x+" " +point2.y+" "+ point2.x+" "+point2.y+10;point2.
		}*/
		//-----------------------------------------------------------
		// 覆盖函数
		//-----------------------------------------------------------
		override protected function cloneStyle(renderer:Renderer, cloneRenderer:Renderer):void
		{
			cloneRenderer.setStyle("caps",renderer.getStyle("caps"));
			cloneRenderer.setStyle("color",renderer.getStyle("color"));
			cloneRenderer.setStyle("dashArray",renderer.getStyle("dashArray"));
			cloneRenderer.setStyle("dashStyle",renderer.getStyle("dashStyle"));
			cloneRenderer.setStyle("endArrowType",renderer.getStyle("endArrowType"));
			cloneRenderer.setStyle("endArrowVisible",renderer.getStyle("endArrowVisible"));
			cloneRenderer.setStyle("joints",renderer.getStyle("joints"));
			cloneRenderer.setStyle("miterLimit",renderer.getStyle("miterLimit"));
			cloneRenderer.setStyle("orthogonalSpacing",renderer.getStyle("orthogonalSpacing"));
			cloneRenderer.setStyle("pixelHinting",renderer.getStyle("pixelHinting"));
			cloneRenderer.setStyle("radius",renderer.getStyle("radius"));
			cloneRenderer.setStyle("selectedColor",renderer.getStyle("selectedColor"));
			cloneRenderer.setStyle("selectedStrokeWidth",renderer.getStyle("selectedStrokeWidth"));
			cloneRenderer.setStyle("startArrowType",renderer.getStyle("startArrowType"));
			cloneRenderer.setStyle("startArrowVisible",renderer.getStyle("startArrowVisible"));
			cloneRenderer.setStyle("strokeColor",renderer.getStyle("strokeColor"));
			cloneRenderer.setStyle("strokeWidth",renderer.getStyle("strokeWidth"));
		}
		
		/*override protected function measure():void{
			super.measure();
			this.measuredWidth = getBoundsForMeasure().width;
			this.measuredHeight = getBoundsForMeasure().height;
		}*/
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
			if(_strokeWidthChange ||
				_radiusChange ||
				_dashStyleChange ||
				_startArrowVisibleChange ||
				_endArrowVisibleChange ||
				_startArrowTypeChange ||
				_endArrowTypeChange ||
				_shapeTypeChange ||
				_orthogonalSpacingChange||
				_dashChange){
				/*if (_shapeTypeChange || _orthogonalSpacingChange) 
				{
					
				}*/
				this.computeShapePoints();
				if (this.path && this._shapePoints) 
				{
					this.updateArrow();
					this.path.data = createDashRoundPolyline(this._shapePoints, this._radius);
					var color:uint;
					if(this._dashStyle == DashStyle.NONE){
						if(!path.stroke || path.stroke is SolidColorStroke){
							color = getStyle("strokeColor");
							if(styleManager.isValidStyleValue(color)){
								path.stroke = new SolidColorStroke(color,this._strokeWidth,0.6);							
							}else{
								path.stroke = new SolidColorStroke(0,this._strokeWidth,0.6);
							}
						}
					}else if(this._dashStyle == DashStyle.DASH){
						if(!path.stroke || path.stroke is SolidColorStroke){
							color = getStyle("strokeColor");
							if(styleManager.isValidStyleValue(color)){
								path.stroke = new SolidColorDash(_dash,_dash,color,this._strokeWidth,0.6);				
							}else{
								path.stroke = new SolidColorDash(_dash,_dash,0x808080,this._strokeWidth,0.6);
							}
						}
					}
					/*if (this._curved) 
					{
						this.configureCurvedPath(this.path);
					}
					else 
					{
						loc1 = com.ibm.ilog.elixir.diagram.utils.PathUtil.createDashRoundPolyline(this._shapePoints, this._radius, this._dashArray, this.firstPointOfPath, this.lastPointOfPath);
						this.path.data = loc1;
					}*/
					/*if (this.getFlag(LinkShapeChangeFlag) || this.getFlag(ArrowVisibilityChangeFlag) || this.getFlag(ArrowTypeChangeFlag)) 
					{
						this.updateArrow();
					}*/
				}
				
				_strokeWidthChange=
					_radiusChange=
					_dashStyleChange=
					_startArrowVisibleChange=
					_endArrowVisibleChange=
					_startArrowTypeChange=
					_endArrowTypeChange = 
					_shapeTypeChange = 
				_orthogonalSpacingChange = 
				_dashChange=false;
			}
//			draw();
		}
		
		/**
		 * 更新箭头，根据箭头是否可视计算旋转角度和偏移量。 
		 * 
		 */
		internal function updateArrow():void
		{
			var point1:Point;
			var point2:Point;
			var radian:Number;
			if (this.startArrow) 
			{
				if ((this._startArrowVisible && this._endArrowVisible) || this._startArrowVisible) 
				{
					point1 = this._shapePoints[0];
					point2 = this._shapePoints[1];
					if (point1 && point2 && !(isNaN(point1.length) || isNaN(point2.length))) 
					{
						radian = Math.atan2(point1.y - point2.y, point1.x - point2.x);
						this.startArrow.rotation = radian * 180 / Math.PI;
						this.startArrow.x = point1.x;
						this.startArrow.y = point1.y;
						this.startArrow.visible = true;
						var midWidth:Number;
						var startRect:Rectangle = getPathBounds(this.startArrow);
						var startOffsetW:Number = Math.max(10,startRect.width);
						point1.offset(-startOffsetW * Math.cos(radian),-startOffsetW*Math.sin(radian));
						this._shapePoints[0] = point1;
					}
				}
				else 
				{
					this.startArrow.visible = false;
				}
			}
			if (this.endArrow) 
			{
				if ((this._startArrowVisible && this._endArrowVisible) || this._endArrowVisible) 
				{
					point1 = this._shapePoints[this._shapePoints.length - 2];
					point2 = this._shapePoints[(this._shapePoints.length - 1)];
					if (point1 && point2 && !(isNaN(point1.length) || isNaN(point2.length))) 
					{
						radian = Math.atan2(point2.y - point1.y, point2.x - point1.x);
						this.endArrow.rotation = radian * 180 / Math.PI;
						this.endArrow.x = point2.x;
						this.endArrow.y = point2.y;
						this.endArrow.visible = true;
						var endRect:Rectangle = getPathBounds(this.startArrow);
						var endOffsetW:Number = Math.max(10,endRect.width);
						point2.offset(-endOffsetW * Math.cos(radian),-endOffsetW*Math.sin(radian));
						this._shapePoints[this._shapePoints.length - 1] = point2;
					}
				}
				else 
				{
					this.endArrow.visible = false;
				}
			}
			return;
		}
		
		internal function clonePointVector(shapePoints:Vector.<Point>):Vector.<Point>
		{
			var length:int = shapePoints ? shapePoints.length : 0;
			if (length == 0) 
			{
				return null;
			}
			
			var result:Vector.<Point> =new Vector.<Point>(length);
			var flag:int = 0;
			while (flag < length) 
			{
				result[flag] = shapePoints[flag].clone();
				++flag;
			}
			return result;
		}
		
		override protected function partAdded(partName:String, instance:Object):void{
			if(instance == this.startArrow){
				this.startArrow.visible = getStyle("startArrowVisible")
			}
			if(instance == this.endArrow){
				this.endArrow.visible = getStyle("endArrowVisible")
			}
			
			if(instance == this.labelElement){
				invalidateShape();
			}
		}
		
		override public function stylesInitialized():void{
			super.stylesInitialized();
			this.initStyles();
		} 
		
		/**
		 *  
		 * @param styleProp
		 * 
		 */
		override public function styleChanged(styleProp:String):void{
			super.styleChanged(styleProp);
			this.initStyles(styleProp);
		} 
		
		internal function initStyles(styleProp:String=null):void
		{
			var changedStyle:Boolean = styleProp == null || styleProp == "styleName";
			var isInvlidate:Boolean = false;
			if (changedStyle || styleProp == "strokeWidth") 
			{
				var strokeWidth:* = getStyle("strokeWidth");
				if (styleManager.isValidStyleValue(strokeWidth)) 
				{
					if (strokeWidth != this._strokeWidth) 
					{
						this._strokeWidth = strokeWidth;
						_strokeWidthChange = true;
					}
				}
			}
			
			if (changedStyle || styleProp == "radius") 
			{
				var radius:* = getStyle("radius");
				if (styleManager.isValidStyleValue(radius)) 
				{
					if (radius != this._radius) 
					{
						this._radius = radius;
						isInvlidate = true;
						_radiusChange = true;
					}
				}
			}
			
			if (changedStyle || styleProp == "dashStyle") 
			{
				var dashStyle:* = getStyle("dashStyle");
				if (styleManager.isValidStyleValue(dashStyle)) 
				{
					this._dashStyle = dashStyle;
					isInvlidate = true;
					_dashStyleChange = true;
				}
			}
			
			if (changedStyle || styleProp == "startArrowVisible") 
			{
				var startArrowVisible:* = getStyle("startArrowVisible");
				if (styleManager.isValidStyleValue(startArrowVisible)) 
				{
					this._startArrowVisible = startArrowVisible;
					isInvlidate = true;
					_startArrowVisibleChange = true;
				}
			}
			
			if (changedStyle || styleProp == "endArrowVisible") 
			{
				var endArrowVisible:* = getStyle("endArrowVisible");
				if (styleManager.isValidStyleValue(endArrowVisible)) 
				{
					this._endArrowVisible = endArrowVisible;
					isInvlidate = true;
					_endArrowVisibleChange = true;
				}
			}
			
			if (changedStyle || styleProp == "startArrowType") 
			{
				var startArrowType:* = getStyle("startArrowType");
				if (styleManager.isValidStyleValue(startArrowType)) 
				{
					this._startArrowType = startArrowType;
					isInvlidate = true;
					_startArrowTypeChange = true;
				}
			}
			
			if (changedStyle || styleProp == "endArrowType") 
			{
				var endArrowType:* = getStyle("endArrowType");
				if (styleManager.isValidStyleValue(endArrowType)) 
				{
					this._endArrowType = endArrowType;
					isInvlidate = true;
					_endArrowTypeChange = true;
				}
			}
			
			if (changedStyle || styleProp == "_orthogonalSpacing") 
			{
				var orthogonalSpacing:* = getStyle("_orthogonalSpacing");
				if (styleManager.isValidStyleValue(orthogonalSpacing)) 
				{
					this._orthogonalSpacing = orthogonalSpacing;
					isInvlidate = true;
					_orthogonalSpacingChange = true;
				}
			}
			
			if (changedStyle || styleProp == "dash") 
			{
				var dash:* = getStyle("dash");
				if (styleManager.isValidStyleValue(dash)) 
				{
					this._dash = dash;
					isInvlidate = true;
					_dashChange = true;
				}
			}
			
			if (isInvlidate) 
			{
				invalidateProperties();
			}
		}
	}
}