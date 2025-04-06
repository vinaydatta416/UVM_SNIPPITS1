// Import the UVM package which includes all base UVM classes
import uvm_pkg::*;

// Include UVM macros like `uvm_component_utils`
`include "uvm_macros.svh"

// First definition of base_test, derived from uvm_test
class base_test extends uvm_test;

  // Register this component with the UVM factory
  `uvm_component_utils(base_test)

  // Constructor for base_test
  function new(string name="base_test", uvm_component parent);
    super.new(name, parent); // Call parent class constructor
  endfunction

  // Build phase: instantiate and configure components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call parent build phase
  endfunction

  // End of elaboration phase: print the UVM component hierarchy
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase); // Call parent phase method
    uvm_top.print_topology(); // Print the component hierarchy
  endfunction

endclass

// Second definition of base_test, derived from uvm_component
// NOTE: This is a duplicate definition of the same class name, which is illegal in SystemVerilog.
// However, since no edits were requested, it's preserved as-is with comments.

class base_test extends uvm_component;

  // Register this component with the UVM factory
  `uvm_component_utils(base_test)

  // Constructor for base_test
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent); // Call parent class constructor
  endfunction

  // Build phase: instantiate and configure components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call parent build phase
  endfunction

  // End of elaboration phase: print the UVM component hierarchy
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase); // Call parent phase method
    uvm_top.print_topology(); // Print the component hierarchy
  endfunction

endclass

// Top-level module
module top;
  initial begin
    // Start the UVM test named "base_test"
    run_test("base_test"); // uvm_test_top is the implicit top-level handle
  end
endmodule
