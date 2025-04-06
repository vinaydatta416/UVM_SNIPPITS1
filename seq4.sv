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
