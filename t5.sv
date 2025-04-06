`include "uvm_macros.svh"                 // Include UVM macros (e.g., `uvm_info, `uvm_component_utils)
import uvm_pkg::*;                        // Import all UVM types and classes from the UVM package

//========================= DRIVER =========================//

class driver extends uvm_driver;         // Define a class `driver` that extends uvm_driver (base class for drivers)

  `uvm_component_utils(driver)           // Register the class with the UVM factory (enables create by name)

  function new(string name = "driver", uvm_component parent); // Constructor with default name and parent
    super.new(name, parent);             // Call the parent class constructor
  endfunction

  virtual function void build_phase(uvm_phase phase); // build_phase: for creating sub-components, setting config
    super.build_phase(phase);           // Always call base class's build_phase
    `uvm_info("driver",                 // UVM info message with ID "driver"
              "am in the build of driver",  // Message string
              UVM_MEDIUM);             // Verbosity level: UVM_MEDIUM
  endfunction

  virtual function void connect_phase(uvm_phase phase); // connect_phase: used to connect ports/exports
    super.connect_phase(phase);        // Call base class's connect_phase
    `uvm_info("driver",                // UVM info message
              "am in the connect of driver",
              UVM_MEDIUM);             // Medium verbosity
  endfunction

  task run_phase(uvm_phase phase);     // run_phase: simulation run-time behavior
    phase.raise_objection(this);       // Raise objection to keep simulation running
    `uvm_info("driver",                // Log message during run phase
              "am in the run phase of driver",
              UVM_MEDIUM);
    phase.drop_objection(this);        // Drop objection to allow phase to end
  endtask

endclass

//========================= AGENT =========================//

class agent extends uvm_agent;          // Agent class: groups sequencer, driver, monitor

  `uvm_component_utils(agent)           // Register agent with factory

  driver drv_h;                         // Handle for driver component

  function new(string name = "agent", uvm_component parent); // Constructor
    super.new(name, parent);            // Call parent class constructor
  endfunction

  virtual function void build_phase(uvm_phase phase);  // build_phase of agent
    super.build_phase(phase);          // Call base build_phase
    `uvm_info("agent", "am in the build of agent", UVM_MEDIUM); // Info message

    drv_h = driver::type_id::create("drv_h", this);    // Create driver using factory
    drv_h.set_report_verbosity_level(UVM_MEDIUM);      // Set verbosity of the driver to medium
  endfunction

  virtual function void connect_phase(uvm_phase phase); // connect_phase of agent
    super.connect_phase(phase);         // Base call
    `uvm_info("agent", "am in the connect of agent", UVM_MEDIUM); // Log connection
  endfunction

  task run_phase(uvm_phase phase);     // Agent run phase
    phase.raise_objection(this);       // Raise objection to delay phase end
    `uvm_info("agent", "am in the run phase of agent", UVM_MEDIUM); // Print message
    phase.drop_objection(this);        // Drop objection
  endtask

endclass

//========================= ENVIRONMENT =========================//

class env extends uvm_env;             // env class: top-level container for agents, scoreboards, etc.

  `uvm_component_utils(env)             // Factory registration

  agent agnt_h;                         // Agent handle

  function new(string name = "env", uvm_component parent); // Constructor
    super.new(name, parent);            // Call base class constructor
  endfunction

  virtual function void build_phase(uvm_phase phase);  // build_phase of env
    super.build_phase(phase);          // Call base method
    `uvm_info("env", "am in the build of env", UVM_MEDIUM); // Info message
    agnt_h = agent::type_id::create("agnt_h", this);   // Create agent using factory
    agnt_h.set_report_verbosity_level(UVM_MEDIUM);     // Set verbosity for agent
  endfunction

  virtual function void connect_phase(uvm_phase phase); // connect_phase of env
    super.connect_phase(phase);         // Base connect
    `uvm_info("env", "am in the connect of env", UVM_MEDIUM); // Log message
  endfunction

  task run_phase(uvm_phase phase);     // env run_phase
    phase.raise_objection(this);       // Raise objection to keep run phase active
    `uvm_info("env", "am in the run phase of env", UVM_MEDIUM); // Info log
    phase.drop_objection(this);        // Drop objection to allow phase to end
  endtask

endclass

//========================= TEST =========================//

class basetest extends uvm_test;       // Test class extending uvm_test (entry point for testbench)

  `uvm_component_utils(basetest)        // Register test with factory

  env env_h;                            // Handle to environment

  function new(string name = "basetest", uvm_component parent); // Constructor
    super.new(name, parent);            // Call base constructor
  endfunction

  virtual function void build_phase(uvm_phase phase);  // build_phase of test
    super.build_phase(phase);          // Base class build
    `uvm_info("test", "am in the build of test", UVM_MEDIUM); // Log
    env_h = env::type_id::create("env_h", this);       // Create env
  endfunction

  virtual function void connect_phase(uvm_phase phase); // connect_phase of test
    super.connect_phase(phase);         // Base connect
    `uvm_info("test", "am in the connect of test", UVM_MEDIUM); // Log
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase); // Called after build/connect
    `uvm_info("test", "am in the end_of_elaboration of test", UVM_MEDIUM); // Info
    uvm_top.print_topology();           // Print full UVM hierarchy (for debug)
  endfunction

  task run_phase(uvm_phase phase);     // run_phase of test
    phase.raise_objection(this);       // Keep run phase active
    #10;                                // Wait 10 time units
    `uvm_info("test", "am in the run phase of test", UVM_MEDIUM); // Log
    phase.drop_objection(this);        // Allow run phase to end
  endtask

endclass

//========================= TOP MODULE =========================//

module top;

  initial begin
    uvm_top.set_report_verbosity_level(UVM_MEDIUM); // Set default verbosity for the entire testbench
    run_test("basetest");            // Run the test by name ("basetest") using UVM factory
  end

endmodule
