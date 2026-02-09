class qspi_scoreboard extends uvm_scoreboard;

   uvm_analysis_imp #(qspi_item, qspi_scoreboard) imp;

   int count = 0;

   `uvm_component_utils(qspi_scoreboard)

   function new(string name, uvm_component parent);
      super.new(name,parent);
      imp = new("imp", this);
   endfunction

   // called automatically when monitor sends transaction
   function void write(qspi_item tr);

      count++;

      `uvm_info("SCOREBOARD",
         $sformatf("Checking txn %0d opcode=%h addr=%h",
                    count, tr.opcode, tr.address),
         UVM_LOW)

      // simple example check
      if(tr.opcode === 'hx)
         `uvm_error("SCOREBOARD","Opcode is X!")

   endfunction

endclass
