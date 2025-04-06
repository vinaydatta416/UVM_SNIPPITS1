// Importing the UVM package
import uvm_pkg::*;
// Including UVM macros like `uvm_component_utils`
`include "uvm_macros.svh"

// Declaration of the base_test class, derived from uvm_component
class base_test extends uvm_component;
  
  // Registering the base_test class with the factory
  `uvm_component_utils(base_test)

  // Constructor of the base_test class
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent); // Calling parent class constructor
  endfunction

  // build_phase: used to construct components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase); // Call base class build_phase
  endfunction

  // end_of_elaboration_phase: called after build and connect phases
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase); // Call base class method
    uvm_top.print_topology(); // Print the UVM component hierarchy
  endfunction

endclass

// Top-level module
module top;
  initial begin
    // Starts the UVM test named "base_test"
    run_test("base_test");

    // uvm_test_top is the default top-level test handle created by UVM
    // This line is just a placeholder/comment
    // uvm_test_top
  end
endmodule
