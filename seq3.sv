// Import UVM package which includes all UVM base classes
import uvm_pkg::*;
// Include UVM macros like `uvm_component_utils`, `uvm_info`, etc.
`include "uvm_macros.svh"

//------------------------------------------------------------
// Sequencer class definition (handles sequence execution)
//------------------------------------------------------------
class seqr extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(seqr) // Register sequencer with factory

  // Constructor
  function new(string name = "seqr", uvm_component parent);
    super.new(name, parent); // Call base constructor
  endfunction
endclass

//------------------------------------------------------------
// Driver class definition (drives transactions to DUT)
//------------------------------------------------------------
class driver extends uvm_driver #(uvm_sequence_item);
  `uvm_component_utils(driver) // Register driver with factory

  // Constructor
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent); // Call base constructor
  endfunction
endclass

//------------------------------------------------------------
// Monitor class definition (monitors DUT activity)
//------------------------------------------------------------
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor) // Register monitor with factory

  // Constructor
  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent); // Call base constructor
  endfunction
endclass

//------------------------------------------------------------
// Agent class definition (contains seqr, drvr, mntr)
//------------------------------------------------------------
class agent extends uvm_agent;
  `uvm_component_utils(agent) // Register agent with factory

  seqr seqr_h;      // Handle to sequencer
  driver drvr_h;    // Handle to driver
  monitor mntr_h;   // Handle to monitor

  // Constructor
  function new(string name = "agent", uvm_component parent);
    super.new(name, parent); // Call base constructor
  endfunction

  // Build phase: create all agent subcomponents
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call parent build
    seqr_h = seqr::type_id::create("seqr_h", this);    // Create sequencer
    drvr_h = driver::type_id::create("drvr_h", this);  // Create driver
    mntr_h = monitor::type_id::create("mntr_h", this); // Create monitor
  endfunction

  // Connect phase: connect sequencer to driver
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase); // Call parent connect
    drvr_h.seq_item_port.connect(seqr_h.seq_item_export); // Connect ports
    `uvm_info("agent", "completed the seqr driver connection", UVM_MEDIUM) // Print info
  endfunction
endclass

//------------------------------------------------------------
// Environment class definition (contains agent)
//------------------------------------------------------------
class env extends uvm_env;
  `uvm_component_utils(env) // Register env with factory

  agent agent_h; // Handle to agent

  // Constructor
  function new(string name = "env", uvm_component parent);
    super.new(name, parent); // Call base constructor
  endfunction

  // Build phase: create the agent
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call parent build
    agent_h = agent::type_id::create("agent_h", this); // Create agent
  endfunction
endclass

//------------------------------------------------------------
// Base test class definition (top-level UVM test)
//------------------------------------------------------------
class base_test extends uvm_test;
  `uvm_component_utils(base_test) // Register test with factory

  env env_h; // Handle to environment

  // Constructor
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent); // Call base constructor
  endfunction

  // Build phase: create the environment
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call parent build
    env_h = env::type_id::create("env_h", this); // Create env
  endfunction

  // End of elaboration: print UVM testbench hierarchy
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase); // Call parent phase
    uvm_top.print_topology(); // Print UVM hierarchy
  endfunction
endclass

//------------------------------------------------------------
// Top-level module to initiate the UVM test
//------------------------------------------------------------
module top;
  initial begin
    run_test("base_test"); // Starts the simulation with base_test
  end
endmodule
