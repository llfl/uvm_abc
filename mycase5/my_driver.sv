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

    extern task drive_one_pkt(my_transaction tr);
    
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
    my_transaction tr;//it has to place befor objection
    phase.raise_objection(this);
        vif.data <= 8'b0;
        vif.valid <= 1'b0;
        while (!vif.rst_n) begin
            @(posedge vif.clk);
        end
        for (int i = 0; i < 2; i++) begin
            @(posedge vif.clk);
            tr = new("tr");
            assert (tr.randomize() with {pload.size == 200;});
            drive_one_pkt(tr);
        end
        repeat(5) @(posedge vif.clk);
    phase.drop_objection(this);
endtask: main_phase

task my_driver::drive_one_pkt(my_transaction tr);
    bit [47:0] tmp_data;
    bit [7:0] data_q[$]; 
   
    //push dmac to data_q
    tmp_data = tr.dmac;
    for(int i = 0; i < 6; i++) begin
       data_q.push_back(tmp_data[7:0]);
       tmp_data = (tmp_data >> 8);
    end
    //push smac to data_q
    tmp_data = tr.smac;
    for(int i = 0; i < 6; i++) begin
       data_q.push_back(tmp_data[7:0]);
       tmp_data = (tmp_data >> 8);
    end
    //push ether_type to data_q
    tmp_data = tr.ether_type;
    for(int i = 0; i < 2; i++) begin
       data_q.push_back(tmp_data[7:0]);
       tmp_data = (tmp_data >> 8);
    end
    //push payload to data_q
    for(int i = 0; i < tr.pload.size; i++) begin
       data_q.push_back(tr.pload[i]);
    end
    //push crc to data_q
    tmp_data = tr.crc;
    for(int i = 0; i < 4; i++) begin
       data_q.push_back(tmp_data[7:0]);
       tmp_data = (tmp_data >> 8);
    end
 
    `uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
    repeat(3) @(posedge vif.clk);
 
    while(data_q.size() > 0) begin
       @(posedge vif.clk);
       vif.valid <= 1'b1;
       vif.data <= data_q.pop_front(); 
    end
 
    @(posedge vif.clk);
    vif.valid <= 1'b0;
    `uvm_info("my_driver", "end drive one pkt", UVM_LOW);
endtask: drive_one_pkt


`endif
