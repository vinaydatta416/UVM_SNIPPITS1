// -----------------------------------------------------------
// Import UVM package and include UVM macros
// -----------------------------------------------------------
import uvm_pkg::*;                 // Import all UVM base classes
`include "uvm_macros.svh"         // Include UVM macros (like factory registration)

// -----------------------------------------------------------
// Base sequence item: write_xtn
// -----------------------------------------------------------
class write_xtn extends uvm_sequence_item;

  rand int a;                      // Declare a random integer variable

  `uvm_object_utils(write_xtn)    // Register with factory

  // Constructor
  function new(string name = "write_xtn");
    super.new(name);              // Call base class constructor
  endfunction

  // Constraint: a must be between 6 and 14
  constraint valid_a { a > 5; a < 15; }

endclass

// -----------------------------------------------------------
// Derived sequence item: small_xtn (child of write_xtn)
// -----------------------------------------------------------
class small_xtn extends write_xtn;

  `uvm_object_utils(small_xtn)    // Register derived class with factory

  // Constructor
  function new(string name = "small_xtn");
    super.new(name);              // Call parent constructor
  endfunction

  // Override constraint: a must be exactly 9
  constraint valid_a { a == 9; }

endclass

// -----------------------------------------------------------
// Declare a handle of base type (write_xtn)
// -----------------------------------------------------------
write_xtn xtn_h;

// -----------------------------------------------------------
// Top module
// -----------------------------------------------------------
module top;

  // Task to create and randomize object
  task call();
    xtn_h = write_xtn::type_id::create("xtn_h"); // Create object using factory
    xtn_h.randomize();                            // Randomize it
    $display("The value of a is %0d", xtn_h.a);   // Display the value of 'a'
  endtask

  initial begin
    // ---------------- First call without override ----------------
    $display("--- Without Override ---");
    call();  // Will create object of write_xtn

    // ---------------- Set type override ----------------
    factory.set_type_override_by_type(write_xtn::get_type(), small_xtn::get_type());
    // Now any factory creation of write_xtn will return small_xtn

    // ---------------- Second call with override ----------------
    $display("--- With Override ---");
    call();  // Will create object of small_xtn (overridden)

    // ---------------- Print factory override info ----------------
    factory.print();
  end

endmodule
