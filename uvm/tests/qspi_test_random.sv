class qspi_test_random extends qspi_test;

  `uvm_component_utils(qspi_test_random)

  function new(string name="qspi_test_random", uvm_component parent=null);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);

     qspi_seq_random seq;

     phase.raise_objection(this);

     seq = qspi_seq_random::type_id::create("seq");

     seq.start(agent.seqr);   // ? Correct path

     #1000;

     phase.drop_objection(this);

  endtask

endclass

