class qspi_seq_reset extends uvm_sequence #(qspi_item);

  `uvm_object_utils(qspi_seq_reset)

  function new(string name="qspi_seq_reset");
    super.new(name);
  endfunction


  task body();

    qspi_item req;

    // normal transaction
    req = qspi_item::type_id::create("req");

    start_item(req);

    req.opcode   = 8'h03;
    req.address  = 24'h000100;
    req.burst_len = 4;

    finish_item(req);

    `uvm_info("RESET_SEQ", "Normal transaction done", UVM_LOW)


    // simulate reset delay
    #20;

    // transaction after reset
    req = qspi_item::type_id::create("req2");

    start_item(req);

    req.opcode   = 8'h03;
    req.address  = 24'h000200;
    req.burst_len = 4;

    finish_item(req);

    `uvm_info("RESET_SEQ", "Transaction after reset done", UVM_LOW)

  endtask

endclass
