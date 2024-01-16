
#quit -sim
rm -r work
vlib work

vcom -reportprogress 300 -work work ../RISCV/constants.vhd
vcom -reportprogress 300 -work work ../RISCV/components_package.vhd

vlog -reportprogress 300 -work work ../RISCV/INSTRUCTION_MEMORY/sram_32_1024_freepdk45/sram_32_1024_freepdk45.v
vcom -reportprogress 300 -work work ../RISCV/INSTRUCTION_MEMORY/instuctions_rom.vhd

vcom -reportprogress 300 -work work ../RISCV/extra_components/ADD.vhd
vcom -reportprogress 300 -work work ../RISCV/extra_components/mux2_to_1.vhd
vcom -reportprogress 300 -work work ../RISCV/extra_components/mux3_to_1.vhd
vcom -reportprogress 300 -work work ../RISCV/extra_components/mux4_to_1.vhd

vcom -reportprogress 300 -work work ../RISCV/DATA_MEMORY/data_mem.vhd

vcom -reportprogress 300 -work work ../RISCV/ALU/ALU_CTRL.vhd
vcom -reportprogress 300 -work work ../RISCV/ALU/ALU.vhd

vcom -reportprogress 300 -work work ../RISCV/hazard_detection/comparator.vhd
vcom -reportprogress 300 -work work ../RISCV/hazard_detection/forwarding_unit.vhd
vcom -reportprogress 300 -work work ../RISCV/hazard_detection/hazard_detection_unit.vhd
#vcom -reportprogress 300 -work work ../RISCV/extra_components/branch_circuit.vhd

vcom -reportprogress 300 -work work ../RISCV/imm_gen.vhd
vcom -reportprogress 300 -work work ../RISCV/REGISTER_FILE.vhd
vcom -reportprogress 300 -work work ../RISCV/control_unit.vhd

vcom -reportprogress 300 -work work ../RISCV/pipe_registers/ID_EX.vhd
vcom -reportprogress 300 -work work ../RISCV/pipe_registers/IF_ID.vhd
vcom -reportprogress 300 -work work ../RISCV/pipe_registers/EX_MEM.vhd
vcom -reportprogress 300 -work work ../RISCV/pipe_registers/MEM_WB.vhd

vcom -reportprogress 300 -work work ../RISCV/CRYPT/CU.vhd
vcom -reportprogress 300 -work work ../RISCV/CRYPT/I_decr.vhd
vcom -reportprogress 300 -work work ../RISCV/CRYPT/I_MEM.vhd
vcom -reportprogress 300 -work work ../RISCV/CRYPT/K_MEM.vhd
vcom -reportprogress 300 -work work ../RISCV/CRYPT/PC_crypt.vhd
vcom -reportprogress 300 -work work ../RISCV/CRYPT/crypt_unit.vhd


vcom -reportprogress 300 -work work ../RISCV/riscV.vhd

vlog -reportprogress 300 -work work ../TB/testbench_riscV.sv

vsim -t ps -voptargs=+acc work.testbench_riscV

add wave -position insertpoint sim:/testbench_riscV/UUT/*

add wave -position insertpoint sim:/testbench_riscV/UUT/for_unit/*
add wave -position insertpoint sim:/testbench_riscV/UUT/ALUnit/*
add wave -position insertpoint sim:/testbench_riscV/UUT/Reg_File/*
add wave -position insertpoint sim:/testbench_riscV/UUT/data/*



run 6 us

