///////////////////////////////////////////////////////////////////////////////
// Licensed Materials - Property of IBM
// 5724-Z78
// © Copyright IBM Corporation 2007, 2011. All Rights Reserved.
//
// Note to U.S. Government Users Restricted Rights:
// Use, duplication or disclosure restricted by GSA ADP Schedule
// Contract with IBM Corp.
///////////////////////////////////////////////////////////////////////////////
package com.hjx.diagram
{
	
	
	import com.hjx.bpmn.graphic.Association;
	import com.hjx.bpmn.graphic.ConnectingObject;
	import com.hjx.bpmn.graphic.EndEvent;
	import com.hjx.bpmn.graphic.FlowObject;
	import com.hjx.bpmn.graphic.Gateway;
	import com.hjx.bpmn.graphic.MessageFlow;
	import com.hjx.bpmn.graphic.SequenceFlow;
	import com.hjx.bpmn.graphic.StartEvent;
	import com.hjx.bpmn.graphic.SubProcess;
	import com.hjx.graphic.Graph;
	import com.hjx.graphic.Link;
	import com.hjx.graphic.Node;
	import com.hjx.graphic.Renderer;
	import com.hjx.graphic.SubGraph;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	
	
	[Event(name="timerStop", type="flash.events.Event")]
	
	/**
	 * A base class for "running" a diagram, that is, dynamically changing
	 * properties of a diagram's nodes and/or links to simulate a real-time
	 * data feed.
	 */   
	public class DiagramRunner extends Timer
	{
		// The diagram component that we want to animate
		private var _diagram:Diagram;
		
		private var _hasBeenReset:Boolean = true;
		
		// The current objects, that are, the last objects that were modified
		private var _currents:Vector.<Renderer> = null;  
		
		// the number of end nodes that have been reached
		private var _encounteredStops:Number = 0;
		
		// work data structures
		private var _messages:Dictionary = null;
		private var nextTasks:Vector.<Renderer> = new Vector.<Renderer>();
		private var remainingTargets:Vector.<Renderer> = new Vector.<Renderer>();
		
		
		/**
		 * Creates a new diagram runner.
		 * 
		 * @param diagrammer The diagrammer to be animated.
		 * @param delay The delay between two animation steps.
		 */ 
		public function DiagramRunner(diagram:Diagram , delay:Number)
		{
			super(delay);
			_diagram = diagram;
			addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		
		/**
		 * 
		 */
		private function initialize():void {
			// initialize tables and data 
			_messages = new Dictionary();
			_currents = new Vector.<Renderer>();
			_encounteredStops = 0;
			
			// initialize the monitoring status of all node and links
			doInitDelay(_diagram.graph,delay);
			doInit(_diagram.graph);
			
			// find all roots among subgraph (sub processes, pool of lanes)
			getRoots(_diagram.graph);
			
			// mark roots as "active"
			for each(var root:Object in _currents){
				enter(root);
			}
			timerHandler(null);
		}
		
		
		/**
		 * Do the initialization for nodes, links and subgraph.
		 * It resets the states of each object.
		 */
		private function doInit(graph:Graph):void {
			var nodes:Vector.<Node> = graph.getNodes();
			for each (var node:Node in nodes ) {
				init(node);
			}
			var links:Vector.<Link> = graph.getLinks();
			for each (var link:Link in links) {
				init(link);
			}
			var subgraphs:Vector.<SubGraph> = graph.getSubGraphs();
			for each (var subgraph:SubGraph in subgraphs) {
				doInit(subgraph.graph);
			}      
		}
		
		
		/**
		 * 
		 */
		override public function set delay(value:Number):void 
		{
			// modify all monitoring delay on BPM objects: their skin animations could depend on it
			doInitDelay(_diagram.graph,value);
			
			super.delay = value;
		}
		
		
		/**
		 * Do the modification of delay in each BPM object that
		 * needs it.
		 */
		private function doInitDelay(graph:Graph, value:Number):void {
			var links:Vector.<Link> = graph.getLinks();
			for each (var link:Link in links) {
				if(link is ConnectingObject){
					ConnectingObject(link).monitoringDelay = value; 
				}
			}
			var subgraphs:Vector.<SubGraph> = graph.getSubGraphs();
			for each (var subgraph:SubGraph in subgraphs) {
				doInitDelay(subgraph.graph,value);
			}      
		}    
		
		
		/**
		 * 
		 */
		override public function start():void
		{
			if(_hasBeenReset){
				initialize();
			}
			_hasBeenReset = false;
			super.start();
		}    
		
		
		/**
		 * 
		 */
		override public function reset():void
		{
			_hasBeenReset = true;
			super.reset();
			
			for(var i:int=0; i<_currents.length; i++ ){
				if(_currents[i] != null){
					leave(_currents[i]);
					_currents[i] = null;
				}      
			}
			
			dispatchEvent(new Event("timerStop"));
		}
		
		
		/**
		 * This method is called at every step of the animation.
		 * Calls the "next" method to determine which objects to modify next.
		 * Then calls "leave" on the previous objects, and "enter" on the new
		 * objects.
		 */
		private function timerHandler(event:TimerEvent):void
		{
			// clean the vectors
			nextTasks.length = 0;
			remainingTargets.length = 0;
			
			for each(var current:Renderer in _currents ){
				
				if(current==null){
					continue;
				}
				
				if( isWaitingIncomingMessage(current) && !(isSender(current) && allTargetsReady(FlowObject(current)) ) ){
					remainingTargets.push(current); 
					continue;
				}                
				
				// gets the next tasks that can be reached from the current one
				next(current,nextTasks);
				
				// leave the current task, and send events
				if(current != null){
					leave(current);
					
					// send LEAVE event
					if( current is FlowObject ){
						
						// if we are leaving a gateway node, then indicates the choice that has been made
						var extra:String;
						if( (current is Gateway) && (nextTasks[0] is SequenceFlow) ){
							extra = ""+(nextTasks[0] as SequenceFlow).label;
						}
						
						// create an event instance, and dispatch it
						var ev:DiagramRunnerEvent = new DiagramRunnerEvent(DiagramRunnerEvent.LEAVE,
							current as FlowObject,null,extra);
						dispatchEvent(ev);
					}
					
					// send ENDNODE event
					if( current is FlowObject && nextTasks.length==0 ){            
						ev = new DiagramRunnerEvent(DiagramRunnerEvent.ENDNODE,current as FlowObject);
						dispatchEvent(ev);
					}
				}
				
				// enter each next tasks if they exist, otherwise it means that the current one
				// was a end node (no next tasks).
				if( nextTasks.length > 0 ){
					for each(var o:Renderer in nextTasks){
						enter(o);
					}
				} 
					// a end node is reached
				else if( nextTasks.length==0 || current is EndEvent ){ 
					_encounteredStops++;
					
					// if the flowobject is in a subgraph then set the subgraph monitoring statur to "done"
					if(current is FlowObject){
						var flowObject:FlowObject = current as FlowObject;
						if(flowObject.parent is Graph && (flowObject.parent as Graph).owningSubGraph is SubProcess ){
							((flowObject.parent as Graph).owningSubGraph as SubProcess).monitoringStatus = "done";
						}            
					}          
					
					// no more next object, then stop: the stop function will restart the timer if the runner is looping
					if(_encounteredStops>=_currents.length +remainingTargets.length){
						reset();
					}
					
				}
			}
			
			_currents = nextTasks.concat(remainingTargets);
		}
		
		
		/**
		 * 
		 */
		private function isSender(object:Object):Boolean
		{
			return  _messages[object]!=null && _messages[object]["outgoing"]==true 
		}
		
		
		/**
		 * 
		 */    
		private function isWaitingIncomingMessage(object:Object):Boolean
		{
			if( _messages[object]==null || _messages[object]["incoming"]==null ) return false;      
			return (_messages[object]["incoming"] as Vector.<FlowObject>).length>0;
		}
		
		
		/**
		 * 
		 */
		private function allTargetsReady(sender:FlowObject):Boolean
		{
			var links:Vector.<Link> = sender.getOutgoingLinks();
			for each( var link:Link in links){
				if(link is MessageFlow){
					var msgflow:MessageFlow = link as MessageFlow;
					if( (msgflow.endNode is FlowObject) && (msgflow.endNode as FlowObject).monitoringStatus!="active" ){
						return false;
					}
				}
			}
			
			return true
		}
		
		
		/**
		 * 
		 */
		private function sendMessages(sender:Object):void {
			_messages[sender]["outgoing"] = false
		}
		
		
		/**
		 * Returns the next objects, following the flow of the diagram:
		 * 
		 * @param previous The current object.
		 */ 
		private function next(previous:Object,result:Vector.<Renderer>):void
		{
			
			if( previous is SequenceFlow ){
				var node:Node = (previous as SequenceFlow).endNode
				if(result.indexOf(node)==-1){
					result.push(node );
				}
			}
			else if( previous is Node ){
				var links:Vector.<Link> = (previous as Node).getOutgoingLinks();
				
				// if the current node is an gateway randomly choose among SequenceFlow, 
				if ( previous is Gateway) {
					var idx:Number = Math.round( Math.random() * (links.length-1) );
					while( !(links[idx] is SequenceFlow) ){            
						idx = Math.round( Math.random() * (links.length-1) );
					}
					if(result.indexOf(links[idx])==-1)result.push(links[idx]);
				}
					// otherwise take all outgoing flows 
				else {
					for each( var l:Link in links){
						if( result.indexOf(l)==-1 ){
							result.push(l); 
						}
					}
				}       
			}
			
		}
		
		
		/**
		 * Get the roots: the objects having no incoming links.
		 */
		private function getRoots(parent:Graph):void {
			var nodes:Vector.<Node> = parent.getNodes();
			
			for each (var node:Node in nodes ) {
				if(node is SubGraph){
					getRoots(SubGraph(node).graph);
				} else if( (node is StartEvent) && (node.getIncomingLinks().length == 0) ){
					_currents.push(node);
					return;
				}
			}
			
		}
		
		
		/**
		 * Called on all objects when the animation is started.
		 * Initialize the monitoring status with empty value.
		 */      
		private function init(object:Object):void
		{
			if(object is FlowObject){
				var flowObject:FlowObject = object as FlowObject;
				flowObject.monitoringStatus = "";
				var msgIn:Number = 0;
				var msgOut:Number = 0;
				
				// for this node: get targets of outgoing messages and sources of incoming messages
				var msgs:Object = new Object();
				msgs["outgoing"]= false;
				msgs["incoming"]= null;
				var links:Vector.<Link> = flowObject.getOutgoingLinks();
				for each (var link:Link in links){
					if(link is MessageFlow){
						msgs["outgoing"]=true;
						break;
					}
				}
				
				links = flowObject.getIncomingLinks();
				for each ( link in links){
					if(link is MessageFlow){
						if(msgs["incoming"]==null)  msgs["incoming"] = new Vector.<FlowObject>();
						(msgs["incoming"] as Vector.<FlowObject>).push(link.startNode);
					}
				}
				_messages[flowObject] = msgs
				
				
			} else if(object is ConnectingObject){
				ConnectingObject(object).monitoringStatus = "";
			}
		}
		
		
		/**
		 * Selects the next object.
		 */ 
		private function enter(next:Object):void
		{
			// scroll to "next"
			if(next is Renderer){
				var renderer:Renderer = next as Renderer;        
				var r:Rectangle = renderer.getBounds(_diagram.graph);
				r.inflate(30,30); 
//				_diagram.scroller.ensureRectangleIsVisible(r, false, true);
			}
			
			if(next is FlowObject){
				var flowObject:FlowObject = next as FlowObject;
				var awaitMsg:Boolean = isWaitingIncomingMessage(next);
				
				// for end event we directly set its status to 'done' because no need to display
				// a "processing" status
				if(flowObject is EndEvent) {
					flowObject.monitoringStatus = "done";
				}else {
					flowObject.monitoringStatus = "active";
				}
				
				// if the flowobject is in a subgraph then set the subgraph monitoring status to "active"
				if(flowObject.parent is Graph && (flowObject.parent as Graph).owningSubGraph is SubProcess ){
					((flowObject.parent as Graph).owningSubGraph as SubProcess).monitoringStatus = "active";
				}        
				
				// if object is a gateway, prepare a message that indicates the choices given by this "decision" node
				var extra:String = "";
				if(next is Gateway){
					var links:Vector.<Link> = (next as Gateway).getOutgoingLinks();
					for each(var l:Link in links){
						if(l is SequenceFlow){
							extra += (l as SequenceFlow).label+", ";
						}
					}
					
				}
					// for other task, check if there are involved documents
				else {
					links = flowObject.getLinks();
					for each( l in links){
						if(l is Association){
							var assoc:Association = l as Association;
							if( assoc.startNode!=flowObject ){ 
								extra += assoc.startNode.label+", ";
							}
							else{
								extra += assoc.endNode.label+", ";
							} 
						}
					}
				}
				if( extra.length>0) extra = extra.slice(0,extra.length-2);
				
				
				//send ENTER event
				var ev:DiagramRunnerEvent = new DiagramRunnerEvent(DiagramRunnerEvent.ENTER,next as FlowObject,null,extra);        
				dispatchEvent(ev);
				
				// if awaiting message, then send AWAITMESSAGE event
				if(awaitMsg ){
					// create the list of message senders
					var senders:Vector.<FlowObject> = _messages[next]["incoming"] as Vector.<FlowObject>;
					extra="";
					for each (var s:FlowObject in senders){
						extra += s.label+" ";
					}
					// create an event instance, and dispatch it
					ev = new DiagramRunnerEvent(DiagramRunnerEvent.AWAITMESSAGE,
						flowObject,
						null,
						extra);
					dispatchEvent(ev);        
				}  
				
			} else if(next is ConnectingObject){
				ConnectingObject(next).monitoringStatus = "active";      
			}      
		}
		
		
		/**
		 * Deselects the previous object.
		 */ 
		private function leave(previous:Object ):void
		{
			if(previous is FlowObject){
				FlowObject(previous).monitoringStatus = "done";
			}
			else if(previous is ConnectingObject){
				ConnectingObject(previous).monitoringStatus = "done";
				
				// leaving a MessageFlow = release its targets
				if(previous is MessageFlow){
					// get sender and target of this message
					var sender:Object = (previous as MessageFlow).startNode;
					var target:Object = (previous as MessageFlow).endNode;
					
					// remove the sender from the list of senders of the targets
					if( _messages[target]!=null && _messages[target]["incoming"]!=null ){
						var senders:Vector.<FlowObject> = _messages[target]["incoming"] as Vector.<FlowObject>;
						senders.splice(senders.indexOf(sender),1);
					}
				}      
			}
		}
	}
	
}