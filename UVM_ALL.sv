//============================================================
// 1st code == demonstrating factory override using inheritance in UVM

// Import UVM package and include UVM macros
 /*
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

*/

//=========================================================================


//=========================================================================
// demonstrating object comparison in UVM
/*

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

*/


//=========================================================================
    
    
    
    
// This UVM code is for building a basic UVM testbench structure that 
//demonstrates the creation and connection of components: driver, agent, environment, and test.
//It showcases how UVM phases (build, connect, run)
//work and how components interact in a layered UVM testbench.

/*
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

*/



//=========================================================================



//This UVM code is for **demonstrating custom `do_print()` and `do_copy()` methods in a sequence item**, 
//showing how to manually implement printing and copying of transaction data (`address` and `data`)
//instead of using built-in UVM macros like `uvm_field_int`.

/*
  // Include the UVM macros file, which provides useful macros for UVM functionality
`include "uvm_macros.svh"

// Import the UVM package to use UVM classes and methods
import uvm_pkg::*;

// Define a transaction class that extends uvm_sequence_item
class write_xtn extends uvm_sequence_item;
    
    // Declare two 3-bit randomizable variables for address and data
    rand bit [2:0] address;
    rand bit [2:0] data;
	
    // Register the class with the UVM Factory to enable dynamic creation
	  `uvm_object_utils(write_xtn)
	  
    `uvm_object_utils_begin(write_xtn)
        // Enable UVM automation for 'address' and 'data' (printing, copying, comparing, etc.)
      `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end   

  // Constructor for the write_xtn class
    function new(string name = "write_xtn");
  // Call the parent class (uvm_sequence_item) constructor
        super.new(name);
    endfunction
	
	virtual function void do_print(uvm_printer printer);
	$display("Called By Print Method");
	printer.print_field("address", address, 3,UVM_DEC);
	printer.print_field("data", data, 3, UVM_DEC);
	
	endfunction
	
	virtual function void do_copy(uvm_object rhs);
	        write_xtn temph;
			$cast(temph,rhs);
			this.address = temph.address;
			this.data = temph.data;
			endfunction

endclass

// Define a testbench module
module top;
    
    // Declare object handles for the transaction class
    write_xtn xtn_h1, xtn_h2, xtn_h3;

    // Initial block to execute the test
    initial begin
        // Create an instance of write_xtn using the UVM factory
        xtn_h1 = write_xtn::type_id::create("xtn_h1");
      
	  // Randomize the values of address and data
        xtn_h1.randomize();

        // Print the values of address and data in a formatted UVM output
        xtn_h1.print();
        xtn_h1.print(uvm_default_tree_printer);
        xtn_h1.print(uvm_default_line_printer);
	xtn_h1 = write_xtn :: type_id ::create("xtn_h2");
	xtn_h2.copy(xtn_h1);
		xtn_h1.print();

    end

endmodule

*/

//=========================================================================





///This UVM code is for **demonstrating custom implementation of `do_print()`, 
//`do_copy()`, object comparison using `compare()`, and cloning using `clone()` in a 
//`uvm_sequence_item`-based transaction**. It shows manual handling of print, 
//copy, compare, and clone behaviors typically automated by UVM macros.

/*

      // Include the UVM macros file, which provides useful macros for UVM functionality
`include "uvm_macros.svh"

// Import the UVM package to use UVM classes and methods
import uvm_pkg::*;

// Define a transaction class that extends uvm_sequence_item
class write_xtn extends uvm_sequence_item;
    
    // Declare two 3-bit randomizable variables for address and data
    rand bit [2:0] address;
    rand bit [2:0] data;

    // Register the class with the UVM Factory to enable dynamic creation
    `uvm_object_utils(write_xtn)

    // Constructor for the write_xtn class
    function new(string name = "write_xtn");
        super.new(name);
    endfunction
    
    // Print method override
    virtual function void do_print(uvm_printer printer);
        $display("Called By Print Method");
        printer.print_field("address", address, 3, UVM_DEC);
        printer.print_field("data", data, 3, UVM_DEC);
    endfunction
    
    // Copy method override
    virtual function void do_copy(uvm_object rhs);
        write_xtn temph;
        if (!$cast(temph, rhs)) begin
            `uvm_error("COPY", "Casting failed in do_copy")
            return;
        end
        this.address = temph.address;
        this.data = temph.data;
    endfunction
endclass

// Define a testbench module
module top;
    
    // Declare object handles for the transaction class
    write_xtn xtn_h1, xtn_h2, xtn_h3;

    // Initial block to execute the test
    initial begin
        // Create an instance of write_xtn using the UVM factory
        xtn_h1 = write_xtn::type_id::create("xtn_h1");
        xtn_h1.randomize();

        // Print the values of address and data in a formatted UVM output
        xtn_h1.print();
        xtn_h1.print(uvm_default_tree_printer);
        xtn_h1.print(uvm_default_line_printer);
        
        // Create another instance and copy data
        xtn_h2 = write_xtn::type_id::create("xtn_h2");
        xtn_h2.copy(xtn_h1);
        xtn_h2.print();
        
        // Compare two objects
        if (xtn_h2.compare(xtn_h1))
            $display("H1 AND H2 BOTH ARE SAME");
        
        // Clone an object
        xtn_h3 = write_xtn::type_id::create("xtn_h3");
        xtn_h3 = write_xtn::type_id::create("xtn_clone");
        xtn_h3 = write_xtn::type_id::create("xtn_clone");
        $cast(xtn_h3, xtn_h1.clone());
        xtn_h3.print();
    end
endmodule
*/




//=========================================================================   
    
    
    
 //6
 
//This UVM code is for **demonstrating UVM automation macros
//(`uvm_field_int`) for print, copy, compare, and clone operations** in a 
//`uvm_sequence_item`-based transaction. It simplifies these operations using macro-based 
//automation instead of overriding `do_print()`, `do_copy()`, etc.

/*
// Include the UVM macros file, which provides useful macros for UVM functionality
`include "uvm_macros.svh"

// Import the UVM package to use UVM classes and methods
import uvm_pkg::*;

// Define a transaction class that extends uvm_sequence_item
class write_xtn extends uvm_sequence_item;
    
    // Declare two 3-bit randomizable variables for address and data
    rand bit [2:0] address;
    rand bit [2:0] data;

    // Register the class with the UVM Factory to enable dynamic creation
    `uvm_object_utils_begin(write_xtn)
        // Enable UVM automation for 'address' and 'data' (printing, copying, comparing, etc.)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor for the write_xtn class
    function new(string name = "write_xtn");
        // Call the parent class (uvm_sequence_item) constructor
        super.new(name);
    endfunction

endclass

// Define a testbench module
module top;
    
    // Declare object handles for the transaction class
    write_xtn xtn_h1, xtn_h2, xtn_h3;

    // Initial block to execute the test
    initial begin
        // Create an instance of write_xtn using the UVM factory
        xtn_h1 = write_xtn::type_id::create("xtn_h1");

        // Randomize the values of address and data
        xtn_h1.randomize();

        // Print the values of address and data in a formatted UVM output
        xtn_h1.print();
        xtn_h1.print(uvm_default_tree_printer);
        xtn_h1.print(uvm_default_line_printer);
		xtn_h2 = write_xtn :: type_id ::create("xtn_h2");
		xtn_h2.copy(xtn_h1);
		xtn_h2.print();
		if(xtn_h2.compare(xtn_h1));
			$display("H1 AND H2 BOTH ARE SAME");
		$cast(xtn_h3,xtn_h1.clone());
		xtn_h3.print();

    end

endmodule
*/



//=========================================================================  4



//7

/*  This UVM code is for **demonstrating the use of `uvm_field_int` macros within
    //`uvm_object_utils_begin`/`end` to automate print, copy, compare, and clone functionality** in a//
    `uvm_sequence_item`. It also shows how to create, randomize, and print a UVM object using different UVM printers.

// Include the UVM macros file, which provides useful macros for UVM functionality
`include "uvm_macros.svh"

// Import the UVM package to use UVM classes and methods
import uvm_pkg::*;

// Define a transaction class that extends uvm_sequence_item
class write_xtn extends uvm_sequence_item;
    
    // Declare two 3-bit randomizable variables for address and data
    rand bit [2:0] address;
    rand bit [2:0] data;

    // Register the class with the UVM Factory to enable dynamic creation
    `uvm_object_utils_begin(write_xtn)
        // Enable UVM automation for 'address' and 'data' (printing, copying, comparing, etc.)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor for the write_xtn class
    function new(string name = "write_xtn");
        // Call the parent class (uvm_sequence_item) constructor
        super.new(name);
    endfunction

endclass

// Define a testbench module
module top;
    
    // Declare object handles for the transaction class
    write_xtn xtn_h1, xtn_h2, xtn_h3;

    // Initial block to execute the test
    initial begin
        // Create an instance of write_xtn using the UVM factory
        xtn_h1 = write_xtn::type_id::create("xtn_h1");

        // Randomize the values of address and data
        xtn_h1.randomize();

        // Print the values of address and data in a formatted UVM output
        xtn_h1.print();
        xtn_h1.print(uvm_default_tree_printer);
        xtn_h1.print(uvm_default_line_printer);

    end

endmodule
*/


//=========================================================================
    
    
//8
    
 //This UVM code is for **demonstrating a complete basic UVM
 
 //testbench with sequence, sequencer, driver, agent, environment, and test**,
 //where a sequence generates randomized transactions and sends them to the driver through the sequencer. 
 //It shows full UVM connectivity and flow from stimulus generation to printing the transaction data in the driver.


/*

 // Import UVM package
import uvm_pkg::*;
// Include UVM macros
`include "uvm_macros.svh"

//------------------------------------------------------------
// Sequence item: transaction
//------------------------------------------------------------
class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction) // Register with factory

    rand bit [3:0] address; // Random address field
    rand bit [3:0] data;    // Random data field

    function new(string name="transaction");
        super.new(name); // Call base constructor
    endfunction
endclass

//------------------------------------------------------------
// Sequence: generates multiple transactions
//------------------------------------------------------------
class seq extends uvm_sequence#(transaction);
    `uvm_object_utils(seq) // Register with factory
     
    function new(string name ="seq");
        super.new(name);
    endfunction

    // Sequence body: create and randomize transaction items
    task body();
        req = transaction::type_id::create("req"); // Create a transaction
        repeat(4) begin // Generate 4 transactions
            start_item(req); // Start transaction
            req.randomize(); // Randomize fields
            finish_item(req); // Finish transaction
        end
    endtask : body
endclass

//------------------------------------------------------------
// Sequencer: issues items to driver
//------------------------------------------------------------
class seqr extends uvm_sequencer #(transaction);
    `uvm_component_utils(seqr) // Register with factory

    function new(string name = "seqr", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

//------------------------------------------------------------
// Driver: receives items from sequencer and drives them
//------------------------------------------------------------
class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver) // Register with factory

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Run phase: fetch and process transaction from sequencer
    task run_phase (uvm_phase phase);
        begin
            super.run_phase(phase); // Optional parent call
            seq_item_port.get_next_item(req); // Get transaction
            $display("The address and data are %d and %d", req.address, req.data); // Display values
            seq_item_port.item_done(); // Indicate done
        end
    endtask
endclass

//------------------------------------------------------------
// Monitor: typically observes DUT signals (not implemented)
//------------------------------------------------------------
class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new(string name = "monitor", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

//------------------------------------------------------------
// Agent: encapsulates sequencer, driver, monitor
//------------------------------------------------------------
class agent extends uvm_agent;
    `uvm_component_utils(agent)

    seqr seqr_h;      // Handle to sequencer
    driver drvr_h;    // Handle to driver
    monitor mntr_h;   // Handle to monitor

    function new(string name = "agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build all subcomponents
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr_h = seqr::type_id::create("seqr_h", this);
        drvr_h = driver::type_id::create("drvr_h", this);
        mntr_h = monitor::type_id::create("mntr_h", this);
    endfunction

    // Connect sequencer to driver
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drvr_h.seq_item_port.connect(seqr_h.seq_item_export);
        `uvm_info("agent", "completed the seqr-driver connection", UVM_MEDIUM)
    endfunction
endclass

//------------------------------------------------------------
// Environment: top-level container for agent
//------------------------------------------------------------
class env extends uvm_env;
    `uvm_component_utils(env)

    agent agent_h; // Handle to agent

    function new(string name = "env", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build agent
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_h = agent::type_id::create("agent_h", this);
    endfunction
endclass

//------------------------------------------------------------
// Test: top-level test class
//------------------------------------------------------------
class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    env env_h;   // Handle to environment
    seq seq_h;   // Handle to sequence

    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build environment and sequence
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = env::type_id::create("env_h", this);
        seq_h = seq::type_id::create("seq_h"); // Create sequence (not a component)
    endfunction

    // Print the testbench topology
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    // Run sequence on the sequencer
    task run_phase(uvm_phase phase);
        phase.raise_objection(this); // Raise objection to keep sim alive
        seq_h.start(env_h.agent_h.seqr_h); // Start sequence
        phase.drop_objection(this); // Drop objection to end sim
    endtask
endclass

//------------------------------------------------------------
// Top-level module to launch the UVM test
//------------------------------------------------------------
module top;
    initial begin
        run_test("base_test"); // Start the test
    end
endmodule
*/


//=========================================================================
//9



/* 
This UVM code is for **building a full UVM testbench skeleton** that includes all major components:

* **`sequencer`**
* **`driver`**
* **`monitor`**
* **`agent`** (encapsulates seqr/drvr/mntr)
* **`env`** (contains the agent)
* **`base_test`** (instantiates the environment)
* **`top module`** to call `run_test()`.

🔹 It demonstrates proper usage of **UVM factory**, **build/connect phases**, **UVM hierarchy**, and is ready for attaching sequences and extending functionality.

✅ You can **name this chat**:
**"UVM Full Testbench Skeleton with Agent-Env-Test Setup ✅🧑‍💻🧪"**

*/


/*
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
*/


//=========================================================================


//10


/*
//✅ This UVM code is a full Testbench Skeleton Template — 
//it includes everything except the sequence and transaction classes.
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

*/


//=========================================================================
 //11
 
 
 
 
/*
    //✅ This is a Minimal UVM Test Template showing only base_test 
    //(extends uvm_component, not uvm_test) and top module with run_test.
  // //Importing the UVM package
  
  
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

*/



//=========================================================================

//12 



/*
//This code defines two versions of base_test (one extending uvm_test, the other uvm_component) 
//— which causes a duplicate class name error in SystemVerilog.

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








*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/
//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/


//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/
//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/


//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/
//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/


//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/
//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/


//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/
//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/


//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/

//=========================================================================


//=========================================================================

/*









*/





//=========================================================================


//=========================================================================

/*









*/




//=========================================================================


//=========================================================================

/*









*/



//=========================================================================


//=========================================================================

/*









*/

































































































