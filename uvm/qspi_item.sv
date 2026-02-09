class qspi_item extends uvm_sequence_item;

   rand bit [7:0]  opcode;
   rand bit [23:0] address;
   rand bit [7:0]  write_data;
   rand bit [3:0]  burst_len;

   `uvm_object_utils(qspi_item)

   function new(string name="qspi_item");
      super.new(name);
   endfunction

endclass
