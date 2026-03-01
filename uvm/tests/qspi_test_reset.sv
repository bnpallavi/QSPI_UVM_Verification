class qspi_test_reset extends qspi_test;

  `uvm_component_utils(qspi_test_reset)

  function new(string name="qspi_test_reset", uvm_component parent=null);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);

    qspi_seq_reset seq;

    phase.raise_objection(this);

    seq = qspi_seq_reset::type_id::create("seq");

    seq.start(agent.seqr);

    phase.drop_objection(this);

  endtask

endclass
