`ifndef __MY_TRANSACTION_SV
`define __MY_TRANSACTION_SV

//  Class: my_transaction
//
class my_transaction extends uvm_sequence_item;
    //typedef my_transaction this_type_t; //not necessary right now
    `uvm_object_utils(my_transaction);

    //  Group: Variables
    rand bit [47:0] dmac;
    rand bit [47:0] smac;
    rand bit [15:0] ether_type;
    rand byte pload[];
    rand bit [31:0] crc;

    //  Group: Constraints
    //  Constraint: pload_cons
    extern constraint pload_cons;

    //  Group: Functions
    function bit[31:0] calc_crc();
        return 32'b0;
    endfunction

    function void post_randomize();
        crc = calc_crc;
    endfunction
    

    //  Constructor: new
    function new(string name = "my_transaction");
        super.new(name);
    endfunction: new

    //  Function: do_copy
    // extern function void do_copy(uvm_object rhs);
    //  Function: do_compare
    // extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //  Function: convert2string
    // extern function string convert2string();
    //  Function: do_print
    // extern function void do_print(uvm_printer printer);
    //  Function: do_record
    // extern function void do_record(uvm_recorder recorder);
    //  Function: do_pack
    // extern function void do_pack();
    //  Function: do_unpack
    // extern function void do_unpack();
    
endclass: my_transaction


/*----------------------------------------------------------------------------*/
/*  Constraints                                                               */
/*----------------------------------------------------------------------------*/
constraint my_transaction::pload_cons {
    pload.size >= 46;
    pload.size <= 1500;
}




/*----------------------------------------------------------------------------*/
/*  Functions                                                                 */
/*----------------------------------------------------------------------------*/




`endif
