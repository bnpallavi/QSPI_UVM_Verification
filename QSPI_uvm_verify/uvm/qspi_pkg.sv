package qspi_pkg;

   import uvm_pkg::*;
   `include "uvm_macros.svh"

   `include "qspi_item.sv"
   `include "qspi_driver.sv"
   `include "qspi_monitor.sv"
   `include "qspi_scoreboard.sv"   // NEW
   `include "qspi_sequencer.sv"
   `include "qspi_agent.sv"
   `include "qspi_sequence.sv"
   `include "qspi_test.sv"

endpackage

