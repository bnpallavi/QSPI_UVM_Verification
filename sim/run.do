############################################################
# QSPI INTERACTIVE RUN SCRIPT (GUI SAFE)
############################################################

echo "========================================="
echo " QSPI INTERACTIVE SIMULATION"
echo "========================================="

############################################################
# Clean and create library
############################################################

if {[file exists work]} {
    vdel -all
}

vlib work
vmap work work

############################################################
# Compile RTL + TB + UVM
############################################################

echo "Compiling RTL and UVM..."

vlog -cover bcst ../rtl/master.sv
vlog -cover bcst ../rtl/MX25L6433F.v
vlog -cover bcst ../tb/qspi_if.sv
vlog -cover bcst ../uvm/qspi_pkg.sv
vlog -cover bcst ../tb/top.sv

echo "Compilation Done."

############################################################
# Ask User Which Test To Run
############################################################

echo ""
echo "Select Test To Run:"
echo "1 -> Smoke Test"
echo "2 -> Boundary Test"
echo "3 -> Opcode Test"
echo "4 -> Opcode Full Test"
echo "5 -> Burst Test"
echo "6 -> Random Test"
echo "7 -> Reset Test"
echo ""

puts -nonewline "Enter choice: "
flush stdout
gets stdin choice

set testname ""

switch $choice {
    1 { set testname "qspi_test_smoke" }
    2 { set testname "qspi_test_boundary" }
    3 { set testname "qspi_test_opcode" }
    4 { set testname "qspi_test_opcode_full" }
    5 { set testname "qspi_test_burst" }
    6 { set testname "qspi_test_random" }
    7 { set testname "qspi_test_reset" }
    default {
        echo "Invalid choice."
        return
    }
}

echo "Running $testname..."

############################################################
# Start Simulation (GUI Safe)
############################################################

vsim -coverage -voptargs="+acc=rmb" -classdebug top \
    +UVM_TESTNAME=$testname \
    +UVM_VERBOSITY=UVM_LOW \
    +UVM_NO_RELNOTES

############################################################
# Add Waveforms
############################################################

view wave
delete wave *

add wave -divider "INPUT (TB -> DUT)"
add wave /top/vif/clk
add wave /top/vif/reset_n
add wave /top/vif/start
add wave /top/vif/opcode
add wave /top/vif/address
add wave /top/vif/write_data
add wave /top/vif/burst_len

add wave -divider "DUT FSM"
add wave /top/dut/state
add wave /top/dut/bit_cnt
add wave /top/dut/byte_cnt
add wave /top/dut/sh24
add wave /top/dut/sh8
add wave /top/dut/rd_shift
add wave /top/dut/si

add wave -divider "SPI BUS"
add wave /top/dut/CS
add wave /top/dut/SCLK
add wave /top/vif/IO

add wave -divider "FLASH RESPONSE"
add wave /top/flash/SO

############################################################
# Run Simulation
############################################################

run -all

############################################################
# DO NOT QUIT TOOL
############################################################

echo "========================================="
echo "Simulation Completed for $testname"
echo "========================================="

wave zoom full
configure wave -timelineunits ns
update

# Keep simulator open after finish
