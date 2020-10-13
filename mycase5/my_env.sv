`ifndef __MY_ENV_SV
`define __MY_ENV_SV

//  Class: my_env
//
class my_env extends uvm_env;
    `uvm_component_utils(my_env);

    my_driver drv;

    my_monitor i_mon;
    my_monitor o_mon;

    //  Constructor: new
    function new(string name = "my_env", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern virtual function void build_phase(uvm_phase phase);

endclass: my_env

function void my_env::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    super.build_phase(phase);
    drv = my_driver::type_id::create("drv", this);
    i_mon = my_monitor::type_id::create("i_mon", this);
    o_mon = my_monitor::type_id::create("o_mon", this);

endfunction: build_phase



`endif
