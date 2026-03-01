class qspi_test_opcode extends qspi_test;

  `uvm_component_utils(qspi_test_opcode)

  function new(string name="qspi_test_opcode", uvm_component parent);
    super.new(name,parent);
  endfunction


  task run_phase(uvm_phase phase);

    qspi_seq_opcode seq;

    phase.raise_objection(this);

    seq = qspi_seq_opcode::type_id::create("seq");

    // IMPORTANT (your agent structure)
    seq.start(agent.seqr);

    phase.drop_objection(this);

  endtask

endclass
 