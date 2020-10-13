`ifndef __MY_MONITOR_SV
`define __MY_MONITOR_SV

//  Class: my_monitor
//
class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor);

    virtual my_if vif;

    //  Constructor: new
    function new(string name = "my_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);

    //  Function: main_phase
    extern task main_phase(uvm_phase phase);

    //  Task: collect_one_pkt
    extern task collect_one_pkt(my_transaction tr);
    
endclass: my_monitor

function void my_monitor::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    super.build_phase(phase);
    assert (uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
        `uvm_info(get_name(), "vif has been found in ConfigDB.", UVM_LOW)
    end else `uvm_fatal(get_name(), "vif cannot be found in ConfigDB!")
    
endfunction: build_phase

task my_monitor::main_phase(uvm_phase phase);
    my_transaction tr;

    while (1) begin
        tr = new("tr");
        collect_one_pkt(tr);
    end

endtask: main_phase

task my_monitor::collect_one_pkt(my_transaction tr);
    bit[7:0] data_q[$]; 
    int psize;
    while(1) begin
       @(posedge vif.clk);
       if(vif.valid) break;
    end
 
    `uvm_info("my_monitor", "begin to collect one pkt", UVM_LOW);
    while(vif.valid) begin
       data_q.push_back(vif.data);
       @(posedge vif.clk);
    end
    //pop dmac
    for(int i = 0; i < 6; i++) begin
       tr.dmac = {tr.dmac[39:0], data_q.pop_front()};
    end
    //pop smac
    for(int i = 0; i < 6; i++) begin
       tr.smac = {tr.smac[39:0], data_q.pop_front()};
    end
    //pop ether_type
    for(int i = 0; i < 2; i++) begin
       tr.ether_type = {tr.ether_type[7:0], data_q.pop_front()};
    end
 
    psize = data_q.size() - 4;
    tr.pload = new[psize];
    //pop payload
    for(int i = 0; i < psize; i++) begin
       tr.pload[i] = data_q.pop_front();
    end
    //pop crc
    for(int i = 0; i < 4; i++) begin
       tr.crc = {tr.crc[23:0], data_q.pop_front()};
    end
    `uvm_info("my_monitor", "end collect one pkt, print it:", UVM_LOW);
     tr.my_print();
endtask: collect_one_pkt


`endif
