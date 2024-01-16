
#quit -sim
rm -r work_net
vlib work_net 


vlog -reportprogress 300 -work work_net ../RISCV/INSTRUCTION_MEMORY/sram_32_1024_freepdk45/sram_32_1024_freepdk45.v

vlog -reportprogress 300 -work work_net ../netlist/riscV.v
vlog -reportprogress 300 -work work_net ../TB/testbench_riscV.sv

vsim -t ps -L /eda/dk/nangate45/verilog/qsim2020.4 work_net.testbench_riscV 

add wave -position insertpoint sim:/testbench_riscV/UUT/*

run 10 us

