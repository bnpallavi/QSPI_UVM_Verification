`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
import qspi_pkg::*;

module top;


   // -------------------------
   // Clock
   // -------------------------
   logic clk = 0;
   always #5 clk = ~clk;

   // -------------------------
   // Interface
   // -------------------------
   qspi_if vif(clk);

   // -------------------------
   // DUT : QSPI Master
   // -------------------------
   master dut (
      .clk        (clk),
      .reset_n    (vif.reset_n),
      .start      (vif.start),
      .opcode     (vif.opcode),
      .address    (vif.address),
      .write_data (vif.write_data),
      .burst_len  (vif.burst_len),
      .CS         (vif.CS),
      .SCLK       (vif.SCLK),
      .IO         (vif.IO)
   );

   // -------------------------
   // Flash Model
   // -------------------------
   MX25L6433F flash (
      .SCLK (vif.SCLK),
      .CS   (vif.CS),
      .SI   (vif.IO[0]),
      .SO   (vif.IO[1]),
      .WP   (vif.IO[2]),
      .SIO3 (vif.IO[3])
   );

   // -------------------------
   // Start UVM
   // -------------------------
   initial begin
      uvm_config_db#(virtual qspi_if)::set(null, "*", "vif", vif);
      run_test("qspi_test");
   end

endmodule

