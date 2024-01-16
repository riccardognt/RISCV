
module testbench_riscV_nocrypt;

	parameter tclk = 4400;
	logic clk_tb;
	logic Rstn_tb;



	riscV_nocrypt UUT(clk_tb,Rstn_tb);
	
	always #(tclk/2) clk_tb = ~clk_tb;

	initial begin
		$readmemh("../RISCV/INSTRUCTION_MEMORY/memory_cont/init_rom.mem",testbench_riscV_nocrypt.UUT.intr_mem.Rom_mem.mem);
		$readmemh("../RISCV/DATA_MEMORY/data_mem_cont/init_ram.mem",testbench_riscV_nocrypt.UUT.data.ram.mem);

		//reset
		clk_tb = 1'b0;
		Rstn_tb = 1'b0;
		#(10*tclk);
		Rstn_tb = 1'b1;
		#(10000*tclk);
		$stop;
	
	end

endmodule
