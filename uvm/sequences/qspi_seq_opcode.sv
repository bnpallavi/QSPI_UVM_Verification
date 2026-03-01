class qspi_seq_opcode extends uvm_sequence #(qspi_item);

  `uvm_object_utils(qspi_seq_opcode)

  function new(string name="qspi_seq_opcode");
    super.new(name);
  endfunction


  task body();

    // ? REAL MX25L6433F commands
    bit [7:0] opcode_list[$] = '{
      8'h03, // READ
      8'h0B, // FAST READ
      8'h02, // PAGE PROGRAM
      8'h20, // SECTOR ERASE
      8'h9F, // READ ID
      8'h05, // READ STATUS
      8'h06  // WRITE ENABLE
    };


    foreach(opcode_list[i]) begin

      qspi_item tr;
      tr = qspi_item::type_id::create("tr");

      start_item(tr);

      tr.opcode     = opcode_list[i];
      tr.address    = 24'h000100;
      tr.write_data = 8'hAA;
      tr.burst_len  = 4'd1;

      finish_item(tr);

      `uvm_info("OPCODE_SEQ",
        $sformatf("QSPI opcode = %02h executed", tr.opcode),
        UVM_LOW)

    end

  endtask

endclass
