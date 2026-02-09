class qspi_driver extends uvm_driver #(qspi_item);

   virtual qspi_if vif;

   `uvm_component_utils(qspi_driver)

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      if(!uvm_config_db#(virtual qspi_if)::get(this,"","vif",vif))
         `uvm_fatal("NOVIF","Interface not set")
   endfunction

   task run_phase(uvm_phase phase);
      qspi_item tr;

      forever begin
         seq_item_port.get_next_item(tr);

         vif.start      <= 1;
         vif.opcode     <= tr.opcode;
         vif.address    <= tr.address;
         vif.write_data <= tr.write_data;
         vif.burst_len  <= tr.burst_len;

         @(posedge vif.clk);
         vif.start <= 0;

         seq_item_port.item_done();
      end
   endtask

endclass
