class qspi_seq_opcode_full extends uvm_sequence #(qspi_item);

   `uvm_object_utils(qspi_seq_opcode_full)

   function new(string name="qspi_seq_opcode_full");
      super.new(name);
   endfunction

   task body();

      qspi_item tr;

      for(int i=0; i<256; i++) begin

         tr = qspi_item::type_id::create("tr");

         start_item(tr);

         tr.opcode    = i;
         tr.address   = $urandom;
         tr.write_data= $urandom;
         tr.burst_len = $urandom_range(1,15);

         finish_item(tr);

         `uvm_info("OPCODE_FULL",
            $sformatf("Opcode tested = %0h", i),
            UVM_LOW)

      end

   endtask

endclass

