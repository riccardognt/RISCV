
#quit -sim
rm -r work_net_nocrypt
vlib work_net_nocrypt 


vlog -reportprogress 300 -work work_net_nocrypt ../RISCV/INSTRUCTION_MEMORY/sram_32_1024_freepdk45/sram_32_1024_freepdk45.v

vlog -reportprogress 300 -work work_net_nocrypt ../netlist/riscV_nocrypt.v
vlog -reportprogress 300 -work work_net_nocrypt ../TB/testbench_riscV_nocrypt.sv

vsim -t ps -L /eda/dk/nangate45/verilog/qsim2020.4 work_net_nocrypt.testbench_riscV_nocrypt 

add wave -position insertpoint sim:/testbench_riscV_nocrypt/UUT/*

add wave -position insertpoint sim:/testbench_riscV_nocrypt/UUT/for_unit/*
add wave -position insertpoint sim:/testbench_riscV_nocrypt/UUT/ALUnit/*
add wave -position insertpoint sim:/testbench_riscV_nocrypt/UUT/Reg_File/*
add wave -position insertpoint sim:/testbench_riscV_nocrypt/UUT/data/*



run 5 us

