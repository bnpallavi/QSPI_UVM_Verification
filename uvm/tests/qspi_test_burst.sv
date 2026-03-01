class qspi_test_burst extends qspi_test;

  `uvm_component_utils(qspi_test_burst)

  function new(string name="qspi_test_burst", uvm_component parent);
    super.new(name,parent);
  endfunction


  task run_phase(uvm_phase phase);

    qspi_seq_burst seq;

    phase.raise_objection(this);

    seq = qspi_seq_burst::type_id::create("seq");

    seq.start(agent.seqr);

    phase.drop_objection(this);

  endtask

endclass
