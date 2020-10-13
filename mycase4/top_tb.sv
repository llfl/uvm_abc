`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;
`include "my_if.sv"
`include "my_transaction.sv" //it has to place befor driver
`include "my_driver.sv"

module top_tb;

reg clk;
reg rst_n;

my_if input_if(clk, rst_n);
my_if output_if(clk, rst_n);

dut my_dut(.clk(clk),
           .rst_n(rst_n),
           .rxd(input_if.data),
           .rx_dv(input_if.valid),
           .txd(output_if.data),
           .tx_en(output_if.valid));

initial begin
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top", "vif", input_if);
end

initial begin
   run_test("my_driver");
end

initial begin
   clk = 0;
   forever begin
      #100 clk = ~clk;
   end
end

initial begin
   rst_n = 1'b0;
   #1000;
   rst_n = 1'b1;
   #1000;
   rst_n = 1'b0;
   #1000;
   rst_n = 1'b1;
end

endmodule
