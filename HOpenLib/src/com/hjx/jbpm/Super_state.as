package com.hjx.jbpm
{
	/**
	 * 
	 * @author huangjixin
	 * 
	 */
	public class Super_state extends JbpmBase
	{
		private var _commonNodeElements:CommonNodeElements = new CommonNodeElements();
		private var _end_state:End_state = new End_state();
		private var _state:State = new State();
		private var _node:Node = new Node();
		private var _task_node:Task_node= new Task_node();
		private var _process_state:Process_state = new Process_state();
		private var _super_state:Super_state = new Super_state();
		private var _fork:Fork = new Fork();
		private var _join:Join = new Join();
		private var _decision:Decision = new Decision();
		
		public function Super_state()
		{
			super();
		}
		
		public function get decision():Decision
		{
			return _decision;
		}

		public function set decision(value:Decision):void
		{
			_decision = value;
		}

		public function get join():Join
		{
			return _join;
		}

		public function set join(value:Join):void
		{
			_join = value;
		}

		public function get fork():Fork
		{
			return _fork;
		}

		public function set fork(value:Fork):void
		{
			_fork = value;
		}

		public function get super_state():Super_state
		{
			return _super_state;
		}

		public function set super_state(value:Super_state):void
		{
			_super_state = value;
		}

		public function get process_state():Process_state
		{
			return _process_state;
		}

		public function set process_state(value:Process_state):void
		{
			_process_state = value;
		}

		public function get task_node():Task_node
		{
			return _task_node;
		}

		public function set task_node(value:Task_node):void
		{
			_task_node = value;
		}

		public function get node():Node
		{
			return _node;
		}

		public function set node(value:Node):void
		{
			_node = value;
		}

		public function get state():State
		{
			return _state;
		}

		public function set state(value:State):void
		{
			_state = value;
		}

		public function get end_state():End_state
		{
			return _end_state;
		}

		public function set end_state(value:End_state):void
		{
			_end_state = value;
		}

		public function get commonNodeElements():CommonNodeElements
		{
			return _commonNodeElements;
		}
		
		public function set commonNodeElements(value:CommonNodeElements):void
		{
			_commonNodeElements = value;
		}
		
		override public function toXml():XML
		{
			var xml:XML = super.toXml();
			var xmllist:XMLList = commonNodeElements.toXml().children();
			for each (var x:XML in xmllist) 
			{
				xml.appendChild(x);
			}
			xml.appendChild(decision.toXml());
			xml.appendChild(join.toXml());
			xml.appendChild(fork.toXml());
			xml.appendChild(super_state.toXml());
			xml.appendChild(process_state.toXml());
			xml.appendChild(task_node.toXml());
			xml.appendChild(node.toXml());
			xml.appendChild(state.toXml());
			xml.appendChild(end_state.toXml());
			return xml;
		}
	}
}