class qspi_test_boundary extends qspi_test;

   `uvm_component_utils(qspi_test_boundary)

   function new(string name="qspi_test_boundary", uvm_component parent=null);
      super.new(name,parent);
   endfunction


   task run_phase(uvm_phase phase);

      qspi_seq_boundary seq;

      phase.raise_objection(this);

      seq = qspi_seq_boundary::type_id::create("seq");

      // ??? IMPORTANT ? YOUR REAL PATH
      seq.start(agent.seqr);

      phase.drop_objection(this);

   endtask

endclass

