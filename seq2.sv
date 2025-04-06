// Import the UVM package
import uvm_pkg::*;
// Include UVM macros
`include "uvm_macros.svh"

//----------------------------------------------------
// Sequencer class definition (typed to uvm_sequence_item)
//----------------------------------------------------
class seqr extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(seqr) // Factory registration

  // Constructor
  function new(string name = "seqr", uvm_component parent);
    super.new(name, parent); // Call base class constructor
  endfunction
endclass

//----------------------------------------------------
// Driver class definition (typed to uvm_sequence_item)
//----------------------------------------------------
class driver extends uvm_driver #(uvm_sequence_item);
  `uvm_component_utils(driver) // Factory registration

  // Constructor
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent); // Call base class constructor
  endfunction
endclass

//----------------------------------------------------
// Monitor class definition
//----------------------------------------------------
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor) // Factory registration

  // Constructor
  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent); // Call base class constructor
  endfunction
endclass

//----------------------------------------------------
// Agent class containing sequencer, driver, and monitor
//----------------------------------------------------
class agent extends uvm_agent;
  `uvm_component_utils(agent) // Factory registration

  seqr seqr_h;      // Handle to sequencer
  driver drvr_h;    // Handle to driver
  monitor mntr_h;   // Handle to monitor

  // Constructor
  function new(string name = "agent", uvm_component parent);
    super.new(name, parent); // Call base class constructor
  endfunction

  // Build phase: create all sub-components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call parent build phase
    seqr_h = seqr::type_id::create("seqr_h", this);    // Create sequencer
    drvr_h = driver::type_id::create("drvr_h", this);  // Create driver
    mntr_h = monitor::type_id::create("mntr_h", this); // Create monitor
  endfunction
endclass

//----------------------------------------------------
// Environment class containing the agent
//----------------------------------------------------
class env extends uvm_env;
  `uvm_component_utils(env) // Factory registration

  agent agent_h; // Handle to agent

  // Constructor
  function new(string name = "env", uvm_component parent);
    super.new(name, parent); // Call base class constructor
  endfunction

  // Build phase: create agent
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call parent build phase
    agent_h = agent::type_id::create("agent_h", this); // Create agent
  endfunction
endclass

//----------------------------------------------------
// Base test class (top-level UVM test)
//----------------------------------------------------
class base_test extends uvm_test;
  `uvm_component_utils(base_test) // Factory registration

  env env_h; // Handle to environment

  // Constructor
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent); // Call base class constructor
  endfunction

  // Build phase: create environment
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call parent build phase
    env_h = env::type_id::create("env_h", this); // Create environment
  endfunction

  // End of elaboration: print testbench hierarchy
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase); // Call parent phase method
    uvm_top.print_topology(); // Print UVM testbench hierarchy
  endfunction
endclass

//----------------------------------------------------
// Top-level module to start simulation
//----------------------------------------------------
module top;
  initial begin
    run_test("base_test"); // Start the UVM test
  end
endmodule

/* ------------------------------------------------------
 Expected Output Example:
 
 Running test base_test...
 
 # UVM_INFO ... [Questa UVM] ...
 # UVM_INFO ... [RNTST] Running test base_test...
 # UVM_INFO ... [UVMTOP] UVM testbench topology:
 # --------------------------------------------------------------
 # Name                       Type                    Size  Value
 # --------------------------------------------------------------
 # uvm_test_top               base_test               -     @466
 #   env_h                    env                     -     @473
 #     agent_h                agent                   -     @484
 #       drvr_h               driver                  -     @601
 #         rsp_port           uvm_analysis_port       -     @616
 #         seq_item_port      uvm_seq_item_pull_port  -     @608
 #       mntr_h               monitor                 -     @624
 #       seqr_h               seqr                    -     @492
 #         rsp_export         uvm_analysis_export     -     @499
 #         seq_item_export    uvm_seq_item_pull_imp   -     @593
 #         ...
 # --------------------------------------------------------------
 
 Report Summary:
 UVM_INFO   : 4
 UVM_WARNING: 0
 UVM_ERROR  : 0
 UVM_FATAL  : 0
------------------------------------------------------ */
