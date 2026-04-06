class qspi_quad_test extends qspi_test;

   `uvm_component_utils(qspi_quad_test)

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   task run_phase(uvm_phase phase);
      qspi_quad_sequence seq;

      phase.raise_objection(this);

      seq = qspi_quad_sequence::type_id::create("seq");
      seq.start(env.agent.sequencer);

      phase.drop_objection(this);
   endtask

endclass