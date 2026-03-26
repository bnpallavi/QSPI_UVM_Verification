package qspi_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //-------------------------
  // TRANSACTION
  //-------------------------
  `include "qspi_item.sv"

  //-------------------------
  // COMPONENTS
  //-------------------------
  `include "qspi_driver.sv"
  `include "qspi_monitor.sv"
  `include "qspi_scoreboard.sv"
  `include "qspi_sequencer.sv"
  `include "qspi_agent.sv"

  //-------------------------
 // SEQUENCES
`include "qspi_sequence.sv"
`include "qspi_quad_sequence.sv"
`include "qspi_seq_smoke.sv"
`include "qspi_seq_boundary.sv"
`include "qspi_seq_opcode.sv"
`include "qspi_seq_burst.sv"
`include "qspi_seq_random.sv"
`include "qspi_seq_reset.sv"
`include "qspi_seq_opcode_full.sv"



// TESTS (ALWAYS LAST)
`include "qspi_test.sv"
`include "qspi_test_smoke.sv"
`include "qspi_test_boundary.sv"
`include "qspi_test_opcode.sv"
`include "qspi_test_burst.sv"
`include "qspi_test_random.sv"
`include "qspi_test_reset.sv"
`include "qspi_test_opcode_full.sv"





  

endpackage


