class qspi_monitor extends uvm_monitor;

   virtual qspi_if vif;

   uvm_analysis_port #(qspi_item) ap;

   `uvm_component_utils(qspi_monitor)

   function new(string name, uvm_component parent);
      super.new(name,parent);
      ap = new("ap", this);
   endfunction

   function void build_phase(uvm_phase phase);
      uvm_config_db#(virtual qspi_if)::get(this,"","vif",vif);
   endfunction

   task run_phase(uvm_phase phase);

      qspi_item tr;

      forever begin
         @(posedge vif.start);

         tr = new();

         tr.opcode  = vif.opcode;
         tr.address = vif.address;

         `uvm_info("MON",
            $sformatf("Captured opcode=%h addr=%h", tr.opcode, tr.address),
            UVM_LOW)

         ap.write(tr);   // send to scoreboard
      end

   endtask

endclass

