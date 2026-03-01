class qspi_seq_burst extends uvm_sequence #(qspi_item);

  `uvm_object_utils(qspi_seq_burst)

  function new(string name="qspi_seq_burst");
    super.new(name);
  endfunction


  task body();

    for(int b=1; b<=15; b++) begin

      qspi_item tr;
      tr = qspi_item::type_id::create("tr");

      start_item(tr);

      tr.opcode     = 8'h03;      // READ
      tr.address    = 24'h001000;
      tr.write_data = 8'hAA;
      tr.burst_len  = b;

      finish_item(tr);

      `uvm_info("BURST_SEQ",
        $sformatf("Burst length = %0d", b),
        UVM_LOW)

    end

  endtask

endclass
