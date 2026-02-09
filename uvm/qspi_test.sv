class qspi_test extends uvm_test;

   qspi_agent agent;

   `uvm_component_utils(qspi_test)

   function new(string name="qspi_test", uvm_component parent=null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      agent = qspi_agent::type_id::create("agent", this);
   endfunction

   task run_phase(uvm_phase phase);

      qspi_sequence seq;

      phase.raise_objection(this);

      seq = qspi_sequence::type_id::create("seq");
      seq.start(agent.seqr);

      #100;

      phase.drop_objection(this);

   endtask

endclass

