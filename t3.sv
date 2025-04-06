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
