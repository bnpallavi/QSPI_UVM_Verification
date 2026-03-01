class qspi_seq_random extends uvm_sequence #(qspi_item);

  `uvm_object_utils(qspi_seq_random)

  function new(string name="qspi_seq_random");
    super.new(name);
  endfunction


  task body();

    qspi_item req;

    repeat(50) begin   // run 50 random transactions

      req = qspi_item::type_id::create("req");

      start_item(req);

      assert(req.randomize());

      finish_item(req);

      `uvm_info("RAND_SEQ",
        $sformatf("Random txn opcode=%02h addr=%06h burst=%0d",
        req.opcode, req.address, req.burst_len),
        UVM_LOW)

    end

  endtask

endclass
