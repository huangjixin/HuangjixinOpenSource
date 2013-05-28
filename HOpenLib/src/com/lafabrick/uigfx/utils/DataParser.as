/**
 * @author Fabien BIZOT
 * http://lafabrick.com/blog
 * http://twitter.com/fabienbizot
 */
package com.lafabrick.uigfx.utils
{
	import com.lafabrick.uigfx.element.Contour;
	import com.lafabrick.uigfx.geom.ComplexPoint;
	import com.lafabrick.uigfx.geom.ConstraintPoint;

	/**
	 * Utilities for managing SVG and UIGFX paths
	 */
	public class DataParser
	{
		/**
		 * Convert SVG path to UIGFX path ( UIGFX path with no constraints - only X and Y commands, and successor and predecessor vector definition)
		 * 
		 * <p>Values of SVG commands are considered as being defined absolute (converted to uppercase)</p>
		 * <ul>
		 * <li>Following commands are <b>NOT parsed</b> :
		 * <ul>
		 * <li><b>A/a</b> (elliptical arc command)</li>
		 * <li><b>T/t</b> (Shorthand quadratic bezier)</li>
		 * <li><b>S/s</b> (Shorthand cubic bezier)<br /></li>
		 * </ul>
		 * </li>
		 * <li>Following command are <b>PARTIALY implemented</b> :
		 * <ul>
		 * <li><b>Q/q</b> (quadratic bezier)</li>
		 * </ul>
		 * </li>
		 * </ul>
		 */
		public static function svgToUigfxPath( svgPath : String )  :String
		{
			var dataString : String = validateData( svgPath );
			var uigfxPath : String;
			
			uigfxPath = "C";
			
			var commandsAr : Array = dataString.match( /[a-zA-Z][\-0-9\. ]*/g );
			var numCommands : Number = commandsAr.length;
			
			var commandValues : Array;
			var previousCommandValues : Array;
			var nextCommandValues : Array;
			
			var commandName : String;
			var nextCommandName : String;
			var prevCommandName : String;
			
			var counter : Number = 0;
			for(; counter<numCommands; counter++) {
				commandName = commandsAr[counter].charAt(0);
				
				if( commandName ) {
					commandValues = (commandsAr[counter] as String).substring(2).split(/[ ]+/g);

					if( counter-1 > -1 ) {
						prevCommandName = (commandsAr[counter-1] as String).charAt(0);
						previousCommandValues = (commandsAr[counter-1] as String).substring(2).split(/[ ]+/g);
					}
					else {
						prevCommandName = (commandsAr[numCommands-1] as String).charAt(0);
						previousCommandValues = (commandsAr[numCommands-1] as String).substring(2).split(/[ ]+/g);
					}
					
					if( counter+1 < numCommands ) {
						nextCommandName = (commandsAr[counter+1] as String).charAt(0);
						nextCommandValues = (commandsAr[counter+1] as String).substring(2).split(/[ ]+/g);
					}
					else {
						nextCommandName = (commandsAr[0] as String).charAt(0);
						nextCommandValues = (commandsAr[0] as String).substring(2).split(/[ ]+/g);
					}
					
					switch( commandName.toUpperCase() ) {
						// moveTo
						case "M" :
							
							uigfxPath += " D X "+Math.round(commandValues[0])+" Y "+Math.round(commandValues[1]);
							break;
						// lineTo
						case "L" :
							uigfxPath += " D X "+Math.round(commandValues[0])+" Y "+Math.round(commandValues[1]);
							break;
						// lineTo vertical
						case "V" :
							uigfxPath += " D X ";
							uigfxPath += ( previousCommandValues && previousCommandValues[0] ) == true ? Math.round(previousCommandValues[0]) : 0;
							uigfxPath += " Y "+Math.round(commandValues[1]);
							break;
						// lineTo horizontal
						case "H" :
							uigfxPath += " D X "+Math.round(commandValues[0])+" Y ";
							uigfxPath += ( previousCommandValues && previousCommandValues[1] ) == true ? Math.round(previousCommandValues[1]) : 0;
							break;
						// curveTo (quadratic)
						case "Q" :
							uigfxPath += " D X "+Math.round(commandValues[2])+" Y "+Math.round(commandValues[3]);
							uigfxPath += " P "+Math.round(commandValues[0]-commandValues[2])+" "+Math.round( commandValues[1]-commandValues[3]);
							break;
						// curveTo (cubic)
						case "C" :
							if( prevCommandName.toUpperCase() != "C" ) {
								uigfxPath += " D X "+Math.round(previousCommandValues[0])+" Y "+Math.round(previousCommandValues[1]);
								uigfxPath += " S "+Math.round(commandValues[0]-previousCommandValues[0])+" "+Math.round(commandValues[1]-previousCommandValues[1]);
							}
							
							uigfxPath += " D X "+Math.round(commandValues[4])+" Y "+Math.round(commandValues[5]);
							
							if( nextCommandName.toUpperCase() == "C" ) {
								uigfxPath += " S "+Math.round(nextCommandValues[0]-commandValues[4])+" "+Math.round( nextCommandValues[1]-commandValues[5]);
							}
							
							uigfxPath += " P "+Math.round(commandValues[2]-commandValues[4])+" "+Math.round(commandValues[3]-commandValues[5]);
							
							if( nextCommandName.toUpperCase() == "M" ) {
								uigfxPath += " D X "+Math.round(commandValues[4])+" Y "+Math.round(commandValues[5]);
							}
							
							break;
						// S curveTo (cubic) with the first control point is the reflection of the second control point on the previous C command
						// T curveTo (quadratic) with the control point is the reflection of the control point on the previous Q command
						
						
					}
					
				}
			}
			
			if( dataString.match( /[zZ]/g ).length == 0 ) {
				uigfxPath = uigfxPath.replace("C", "C O");
			}
			
			return uigfxPath;
		}
		
		/**
		 * Parse the compact representation of Contour in "data" property (ComplexPath)
		 * 
		 * @see com.lafabrick.uigfx.primitives.ComplexPath
		 */
		public static function parseComplexData( dataString : String ) : Vector.<Contour>
		{
			
			var pattern : RegExp = new RegExp("^[a-zA-Z ][\-0-9\. ]*");
			var patternWhitespace : RegExp = new RegExp("[ ]$");
			
			dataString = validateData( dataString );
			
			if( dataString.search(/^C /) == -1 ) {
				dataString = "C "+dataString;
			}
			
			var arContours : Array = dataString.slice(2).split(/C /);			
			var numContour : int = dataString.match(/C+/g).length;
			var contours : Vector.<Contour> = new Vector.<Contour>();
			
			var dataPoint : String;
			var currentCode : String;
			
			for ( var ct:Number = 0; ct<numContour; ct++) {
				var contour : Contour = new Contour();
				contour.points = new Vector.<ComplexPoint>();
				
				var arPoints : Array;
				
				if( (arContours[ct] as String).match( /O+/g ).length > 0 ) {
					arPoints = arContours[ct].slice(4).split(/D /);		
					contour.closedContour = false;
				}
				else {
					arPoints = arContours[ct].slice(2).split(/D /);
					contour.closedContour = true;
				}
				
				var numPoint : int = arContours[ct].match(/D+/g).length;
				for ( var pt:Number = 0; pt<numPoint; pt++) {
					dataPoint = arPoints[pt].replace( patternWhitespace, "" );
					var lnCodes : Number =  dataPoint.split( /[a-zA-Z]/).length;
					
					var complexPoint : ComplexPoint = new ComplexPoint();
					
					for ( var co:Number = 0; co<lnCodes-1; co++) {
						var code : String = pattern.exec( dataPoint );
						if( code && code.length>0 ) {
							dataPoint = dataPoint.slice( code.length );
							var extractCode : String = code.replace( patternWhitespace, "");
							
							var arCode : Array = extractCode.split(" ");
							
							switch( arCode[0].toUpperCase() ) {
								
								case "X" :
									complexPoint.x = getNumber(arCode, 1 );
									break;
								case "L" :
									complexPoint.left = getNumber(arCode, 1 );
									break;
								case "H" :
									complexPoint.horizontalCenter = getNumber(arCode, 1 );
									break;
								case "R" :
									complexPoint.right = getNumber(arCode, 1 );
									break;
								case "Y" :
									complexPoint.y = getNumber(arCode, 1 );
									break;
								case "T" :
									complexPoint.top = getNumber(arCode, 1 );
									break;
								case "V" :
									complexPoint.verticalCenter = getNumber(arCode, 1 );
									break;
								case "B" :
									complexPoint.bottom = getNumber(arCode, 1 );
									break;
								case "P" :
									complexPoint.prevAnchorOffsetX = getNumber(arCode, 1 );
									complexPoint.prevAnchorOffsetY = getNumber(arCode, 2 );
									break;
								case "S" :
									complexPoint.nextAnchorOffsetX = getNumber(arCode, 1 );
									complexPoint.nextAnchorOffsetY = getNumber(arCode, 2 );
									break;
								default :
									break;
							}
						}
					}
					
					contour.points.push( complexPoint );
				}
				contours.push( contour );
			}
			
			return contours;	
		}
		
		/**
		 * Obtain the compact representation of path in "contours" property (ComplexPath)
		 * 
		 * @see com.lafabrick.uigfx.primitives.ComplexPath
		 */
		public static function obtainComplexData( data : Vector.<Contour> ) : String
		{
			var dataString : String = "";
			var contour : Contour;
			var point : ComplexPoint;
			
			var tempConstraint : String;
			for each( contour in data ) {
				dataString += "C ";
				if( contour.closedContour == false ) {
					dataString += "O ";
				}
				for each( point in contour.points ) {
					// Start a new declaration
					dataString += "D ";
					
					// for H constraints
					tempConstraint = point.getHorizontalConstraint();
					switch( tempConstraint ) {
						case ConstraintPoint.LEFT_CONSTRAINT :
							dataString += "L "+point.left+" ";
							break;
						case ConstraintPoint.RIGHT_CONSTRAINT :
							dataString += "R "+point.right+" ";
							break;
						case ConstraintPoint.HORIZONTAL_CENTER_CONSTRAINT :
							dataString += "H "+point.horizontalCenter+" ";
							break;
						case ConstraintPoint.X_CONSTRAINT :
							dataString += "X "+point.x+" ";
							break;
					}
					// for V constraints
					tempConstraint = point.getVerticalConstraint();
					switch( tempConstraint ) {
						case ConstraintPoint.TOP_CONSTRAINT :
							dataString += "T "+point.top+" ";
							break;
						case ConstraintPoint.BOTTOM_CONSTRAINT :
							dataString += "B "+point.bottom+" ";
							break;
						case ConstraintPoint.VERTICAL_CENTER_CONSTRAINT :
							dataString += "V "+point.verticalCenter+" ";
							break;
						case ConstraintPoint.Y_CONSTRAINT :
							dataString += "Y "+point.y+" ";
							break;
					}
					// for Predecessor bezier
					if( point.prevAnchorOffsetX != 0 && point.prevAnchorOffsetY != 0 ) {
						dataString += "P "+point.prevAnchorOffsetX+" "+point.prevAnchorOffsetY+" ";
					}
					
					else if( point.prevAnchorOffsetX != 0 && point.prevAnchorOffsetY == 0 ) {
						dataString += "P "+point.prevAnchorOffsetX+" ";
					}
					else if( point.prevAnchorOffsetX == 0 && point.prevAnchorOffsetY != 0 ) {
						dataString += "P 0 "+point.prevAnchorOffsetY+" ";
					}
					
					// for successor bezier
					if( point.nextAnchorOffsetX != 0 && point.nextAnchorOffsetY != 0 ) {
						dataString += "S "+point.nextAnchorOffsetX+" "+point.nextAnchorOffsetY+" ";
					}
						
					else if( point.nextAnchorOffsetX != 0 && point.nextAnchorOffsetY == 0 ) {
						dataString += "S "+point.nextAnchorOffsetX+" ";
					}
					else if( point.nextAnchorOffsetX == 0 && point.nextAnchorOffsetY != 0 ) {
						dataString += "S 0 "+point.nextAnchorOffsetY+" ";
					}
				
				}
			}
			return dataString;
		}
		
		/**
		 * @private
		 */
		private static function validateData( dataString : String ) : String
		{
			// Split letter followed by number (ie "M3" becomes "M 3")
			var temp:String = dataString.replace(/([A-Za-z])([0-9\-\.])/g, "$1 $2");
			// Split number followed by letter (ie "3M" becomes "3 M")
			temp = temp.replace(/([0-9\.])([A-Za-z\-])/g, "$1 $2");
			// Split letter followed by letter (ie "zM" becomes "z M")
			temp = temp.replace(/([A-Za-z\-])([A-Za-z\-])/g, "$1 $2");
			// Replace commas with spaces
			temp = temp.replace(/,/g, " ");
			// Trim leading and trailing spaces
			temp = temp.replace(/^\s+/, "");
			temp = temp.replace(/\s+$/, ""); 
			
			return temp;
		}
		
		/**
		 * @private
		 */
		private static function getNumber( ar : Array, position : Number ) : Number
		{
			if( ar.length>=Number(position+1) ) {
				return ar[position];
			}
			return 0;
		}
	}
}