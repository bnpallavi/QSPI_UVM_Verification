class qspi_monitor extends uvm_monitor;

   virtual qspi_if vif;

   uvm_analysis_port #(qspi_item) ap;

   // ---------------------------------
   // sampled variables (must be first)
   // ---------------------------------
   bit [7:0]  opcode;
   bit [23:0] address;
   bit [3:0]  burst_len;

   // ---------------------------------
   // covergroup (simplified syntax)
   // ---------------------------------
   covergroup qspi_cg;

      opcode_cp : coverpoint opcode;

      burst_cp : coverpoint burst_len {
         bins b1 = {[1:2]};
         bins b2 = {[3:8]};
         bins b3 = {[9:15]};
      }

      addr_cp : coverpoint address;

      cross opcode_cp, burst_cp;

   endgroup


   `uvm_component_utils(qspi_monitor)

   function new(string name, uvm_component parent);
      super.new(name,parent);

      ap = new("ap", this);
      qspi_cg = new();
   endfunction


   function void build_phase(uvm_phase phase);
      void'(uvm_config_db#(virtual qspi_if)::get(this,"","vif",vif));
   endfunction


   task run_phase(uvm_phase phase);

      qspi_item tr;

      forever begin
         @(posedge vif.start);

         tr = new();

         opcode     = vif.opcode;
         address    = vif.address;
         burst_len  = vif.burst_len;

         tr.opcode  = opcode;
         tr.address = address;
         tr.burst_len = burst_len;

         qspi_cg.sample();

         `uvm_info("MON",
           $sformatf("opcode=%h addr=%h burst=%0d",
                     opcode,address,burst_len),
           UVM_LOW)

         ap.write(tr);
      end

   endtask

endclass
