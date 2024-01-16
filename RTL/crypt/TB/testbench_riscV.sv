
module testbench_riscV;

	parameter tclk = 4400;
	logic clk_tb;
	logic Rstn_tb;



	riscV UUT(clk_tb,Rstn_tb);
	
	always #(tclk/2) clk_tb = ~clk_tb;

	initial begin
		$readmemh("../RISCV/CRYPT/keys_mem_content/init_K.mem",testbench_riscV.UUT.crypt_un.keyMem.Rom_mem.mem);
		$readmemh("../RISCV/CRYPT/instruction_mem_content/init_I.mem",testbench_riscV.UUT.crypt_un.instrMem.Rom_mem.mem);
		$readmemh("../RISCV/DATA_MEMORY/data_mem_cont/init_ram.mem",testbench_riscV.UUT.data.ram.mem);

		//reset
		clk_tb = 1'b0;
		Rstn_tb = 1'b0;
		#(10*tclk);
		Rstn_tb = 1'b1;
		#(10000*tclk);
		$stop;
	
	end

endmodule
