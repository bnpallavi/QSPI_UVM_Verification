`timescale 1ns/1ps

interface qspi_if(input logic clk);

   logic reset_n;
   logic start;

   logic [7:0]  opcode;
   logic [23:0] address;
   logic [7:0]  write_data;
   logic [3:0]  burst_len;

   logic CS;
   logic SCLK;
   tri   [3:0] IO;

   clocking drv_cb @(posedge clk);
      output start, opcode, address, write_data, burst_len;
   endclocking

   clocking mon_cb @(posedge clk);
      input start, opcode, address, write_data, CS, SCLK, IO;
   endclocking

endinterface

