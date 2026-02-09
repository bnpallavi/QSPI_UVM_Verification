class qspi_agent extends uvm_agent;

   qspi_driver    drv;
   qspi_sequencer seqr;
   qspi_monitor mon;
   qspi_scoreboard sb;

   `uvm_component_utils(qspi_agent)

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      drv  = qspi_driver   ::type_id::create("drv",  this);
      seqr = qspi_sequencer::type_id::create("seqr", this);
      mon = qspi_monitor::type_id::create("mon", this);
      sb = qspi_scoreboard::type_id::create("sb", this); 
   endfunction

   function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
      mon.ap.connect(sb.imp);
   endfunction

endclass
