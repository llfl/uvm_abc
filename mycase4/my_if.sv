`ifndef __MY_IF_SV
`define __MY_IF_SV

//  Interface: my_if
//
interface my_if(
        input clk,
        input rst_n
    );

    logic [7:0] data;
    logic valid;
endinterface: my_if


`endif
