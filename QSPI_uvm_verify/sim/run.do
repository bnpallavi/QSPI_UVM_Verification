vlib work
vmap work work

# RTL
vlog +acc ../rtl/master.sv
vlog +acc ../rtl/MX25L6433F.v

# TB
vlog +acc ../tb/qspi_if.sv

# UVM
vlog +acc ../uvm/qspi_pkg.sv

# TOP
vlog +acc ../tb/top.sv

vsim top -voptargs=+acc +UVM_TESTNAME=qspi_test

run -all

