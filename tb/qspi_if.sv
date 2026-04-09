`timescale 1ns/1ps

interface qspi_if(input logic clk);

   //-----------------------------------
   // CONTROL SIGNALS
   //-----------------------------------

   logic reset_n;
   logic start;

   //-----------------------------------
   // INPUT DATA
   //-----------------------------------

   logic [7:0]  opcode;
   logic [23:0] address;
   logic [7:0]  write_data;
   logic [3:0]  burst_len;

   //-----------------------------------
   // SPI OUTPUT
   //-----------------------------------

   logic CS;
   logic SCLK;

   tri [3:0] IO;

   //-----------------------------------
   // DRIVER CLOCKING BLOCK
   //-----------------------------------

   clocking drv_cb @(posedge clk);

      output start;
      output opcode;
      output address;
      output write_data;
      output burst_len;

   endclocking


   //-----------------------------------
   // MONITOR CLOCKING BLOCK
   //-----------------------------------

   clocking mon_cb @(posedge clk);

      input start;
      input opcode;
      input address;
      input write_data;
      input burst_len;

      input CS;
      input SCLK;
      input IO;

   endclocking

endinterface
