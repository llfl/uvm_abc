`ifndef __MY_DRIVER_SV
`define __MY_DRIVER_SV

//  Class: my_driver
//
class my_driver extends uvm_driver;

    `uvm_component_utils(my_driver);

    virtual my_if vif;

    function new(string name = "my_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern virtual function void build_phase(uvm_phase phase);

    //  Function: main_phase
    extern virtual task main_phase(uvm_phase phase);
    
    
endclass: my_driver

function void my_driver::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    super.build_phase(phase);
    `uvm_info(get_name(), "build_phase is called", UVM_LOW);

    assert (uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
        `uvm_info(get_name(), "vif has been found in ConfigDB.", UVM_LOW)
    end else `uvm_fatal(get_name(), "vif cannot be found in ConfigDB!")

endfunction: build_phase
 

task my_driver::main_phase(uvm_phase phase);
    phase.raise_objection(this);
        vif.data <= 8'b0;
        vif.valid <= 1'b0;
        while (!vif.rst_n) begin
            @(posedge vif.clk);
        end
        for (int i = 0; i < 256; i++) begin
            @(posedge vif.clk);
            //$urandom_range(maxval, minval = 0) is not work!!!!
            //It seems positions of maxval and minval is irrelevant.
            vif.data <= $urandom_range(0, 255);
            vif.valid <= 1'b1;
            `uvm_info(get_name(), "data is drived", UVM_LOW);
        end
        @(posedge vif.clk);
        vif.valid <= 1'b0;
    phase.drop_objection(this);
endtask: main_phase

`endif
