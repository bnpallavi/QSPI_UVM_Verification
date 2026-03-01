class qspi_test_smoke extends uvm_test;

   `uvm_component_utils(qspi_test_smoke)

   qspi_agent agent;

   function new(string name, uvm_component parent);
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

      // USE CORRECT NAME HERE
      seq.start(agent.seqr);

      phase.drop_objection(this);

   endtask

endclass
