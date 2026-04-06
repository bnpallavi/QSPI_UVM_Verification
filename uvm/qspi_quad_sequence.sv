class qspi_quad_sequence extends uvm_sequence #(qspi_item);

   `uvm_object_utils(qspi_quad_sequence)

   function new(string name="qspi_quad_sequence");
      super.new(name);
   endfunction

   task body();
      qspi_item tr;

      repeat(5) begin
         tr = qspi_item::type_id::create("tr");

         start_item(tr);
         assert(tr.randomize() with {
            opcode inside {8'h38, 8'hEB};
         });
         finish_item(tr);
      end
   endtask

endclass