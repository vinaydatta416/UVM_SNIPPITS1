`include "uvm_macros.svh"      // Include UVM macros
import uvm_pkg::*;             // Import all UVM classes

// Define a class named 'transaction' which extends uvm_object
class transaction extends uvm_object;

  rand bit[15:0] addr;         // Random address field (16-bit)
  rand bit[15:0] data;         // Random data field (16-bit)

  // Register fields for UVM automation (factory, copy, compare, print)
  `uvm_object_utils_begin(transaction)
    `uvm_field_int(addr, UVM_PRINT)   // Enable print for addr
    `uvm_field_int(data, UVM_PRINT)   // Enable print for data
  `uvm_object_utils_end

  // Constructor for transaction object
  function new(string name = "transaction");
    super.new(name);          // Call base class constructor
  endfunction

endclass  // End of transaction class


// Define base_test class which extends uvm_test
class base_test extends uvm_test;

  transaction tr1, tr2;       // Declare two transaction objects to compare
  uvm_comparer comp;          // UVM object for comparing objects

  `uvm_component_utils(base_test)  // Register class with factory

  // Constructor for base_test
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);       // Call base class constructor
  endfunction

  // Build phase: create objects using factory
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);      // Call base build phase

    // Create tr1 and tr2 using UVM factory
    tr1 = transaction::type_id::create("tr1", this);
    tr2 = transaction::type_id::create("tr2", this);

    // Create comparer object manually
    comp = new();
  endfunction

  // Run phase: do randomization and comparison
  task run_phase(uvm_phase phase);
    super.run_phase(phase);       // Call base run phase

    // Randomize both transaction objects
    assert(tr1.randomize());      // Randomize tr1 and check success
    assert(tr2.randomize());      // Randomize tr2 and check success

    // Configure comparer settings
    comp.verbosity = UVM_LOW;     // Set log level to low (minimal)
    comp.sev = UVM_ERROR;         // Severity for mismatches = error
    comp.show_max = 100;          // Show up to 100 mismatches

    // Print info before first comparison
    `uvm_info(get_full_name(), "Comparing objects", UVM_LOW)

    // Compare the two transaction objects (likely different)
    comp.compare_object("tr_compare", tr1, tr2);

    // Now copy tr1 into tr2 (make them identical)
    tr2.copy(tr1);

    // Compare again (they should now match)
    comp.compare_object("tr_compare", tr1, tr2);

    // Print final comparison result
    `uvm_info(get_full_name(), $sformatf("Comparing objects: result = %0d", comp.result), UVM_LOW)

    // Compare mismatched integers (expect error)
    comp.compare_field_int("int_compare", 5'h2, 5'h4, 5);  // Mismatch: 0x2 vs 0x4

    // Compare mismatched strings (expect error)
    comp.compare_string("string_compare", "name", "names"); // Mismatch: extra 's'

    // Show result after mismatches
    `uvm_info(get_full_name(), $sformatf("Comparing objects: result = %0d", comp.result), UVM_LOW)

    // Now compare matching values
    comp.compare_field_int("int_compare", 5'h4, 5'h4, 5);   // Match
    comp.compare_string("string_compare", "name", "name"); // Match
  endtask

endclass  // End of base_test


// Top-level module to run UVM test
module tb_top;

  initial begin
    run_test("base_test");    // Run the test named "base_test"
  end

endmodule
