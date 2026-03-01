class qspi_seq_smoke extends qspi_sequence;

   `uvm_object_utils(qspi_seq_smoke)

   function new(string name="qspi_seq_smoke");
      super.new(name);
   endfunction

   // --------------------------------
   // Smoke = few random transactions
   // --------------------------------
   task body();

      repeat (5) begin
         super.body();   // reuse base sequence logic
      end

   endtask

endclass

