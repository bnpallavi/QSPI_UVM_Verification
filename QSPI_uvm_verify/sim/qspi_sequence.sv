class qspi_sequence extends uvm_sequence #(qspi_item);

   `uvm_object_utils(qspi_sequence)

   function new(string name="qspi_sequence");
      super.new(name);
   endfunction

   task body();

      qspi_item tr;

      repeat(5) begin
         tr = qspi_item::type_id::create("tr");

         start_item(tr);
         assert(tr.randomize());
         finish_item(tr);
      end

   endtask

endclass
