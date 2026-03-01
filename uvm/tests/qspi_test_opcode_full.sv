class qspi_test_opcode_full extends qspi_test;

   `uvm_component_utils(qspi_test_opcode_full)

   function new(string name="qspi_test_opcode_full", uvm_component parent);
      super.new(name,parent);
   endfunction

   task run_phase(uvm_phase phase);

      qspi_seq_opcode_full seq;

      phase.raise_objection(this);

      seq = qspi_seq_opcode_full::type_id::create("seq");

      seq.start(agent.seqr);

      phase.drop_objection(this);

   endtask

endclass

