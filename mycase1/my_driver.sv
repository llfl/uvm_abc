`ifndef __MY_DRIVER_SV
`define __MY_DRIVER_SV

//  Class: my_driver
//
class my_driver extends uvm_driver;

    function new(string name = "my_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: main_phase
    extern virtual task main_phase(uvm_phase phase);
    
    
endclass: my_driver

task my_driver::main_phase(uvm_phase phase);
    top_tb.rxd <= 8'b0;
    top_tb.rx_dv <= 1'b0;
    while (!top_tb.rst_n) begin
        @(posedge top_tb.clk);
    end
    for (int i = 0; i < 256; i++) begin
        @(posedge top_tb.clk);
        //$urandom_range(maxval, minval = 0) is not work!!!!
        //It seems positions of maxval and minval is irrelevant.
        top_tb.rxd <= $urandom_range(0, 255);
        top_tb.rx_dv <= 1'b1;
        `uvm_info(get_name(), "data is drived", UVM_LOW);
    end
    @(posedge top_tb.clk);
    top_tb.rx_dv <= 1'b0;
endtask: main_phase
`endif
