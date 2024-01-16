library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all; 
use work.components_package.all;

entity riscV_nocrypt is
	port (
		CK, RST_n : in  std_logic);
	end riscV_nocrypt;


architecture Behavior of riscV_nocrypt is 
---------------------------------------------------------------------
-----------------------------  IF Stage -----------------------------
---------------------------------------------------------------------

signal PC_in, PC_out, IF_Instr_out, IF_add_out, add_branch_out : std_logic_vector(31 downto 0);
signal PCWrite, flush_sig, FLSH_SIG, pipe_write, PC_sel : std_logic;
signal Vout_instr, Vout : std_logic;

---------------------------------------------------------------------
-----------------------------  ID Stage -----------------------------
---------------------------------------------------------------------

signal ID_Instr_out, ID_PC_old, ID_PC_new, rs1, rs2, sig4, sig_write, ID_Imm_gen_out, incr : std_logic_vector(31 downto 0);
signal CU_out, CU_mux_out, zeros16 : std_logic_vector(15 downto 0);
signal greater, not_equal, to_control_mux : std_logic;
signal WB_vect : std_logic_vector(1 downto 0);
signal EX_vect : std_logic_vector(9 downto 0);
signal funct_vect : std_logic_vector(3 downto 0);
signal CU_FU_EN: std_logic:='1';
signal haz_ctrl_branch : std_logic;
signal EX_FU_EN : std_logic;


---------------------------------------------------------------------
-----------------------------  EX Stage -----------------------------
---------------------------------------------------------------------

signal EX_seq, EX_old, EX_data_rs1, EX_data_rs2, EX_imm, mux5_out, mux6_out, mux7_out, mux8_out : std_logic_vector(31 downto 0);
signal EX_rs1 : std_logic_vector(4 downto 0);
signal EX_rs2: std_logic_vector(4 downto 0);
signal EX_funct : std_logic_vector(3 downto 0);
signal EX_rd : std_logic_vector(4 downto 0);
signal ALU_out : std_logic_vector(31 downto 0);
signal M_sig, WB_sig : std_logic_vector(1 downto 0);
signal EX_sig : std_logic_vector(9 downto 0);
signal alu_zero_out : std_logic;
signal forwardA, forwardB : std_logic_vector(1 downto 0);
signal ALU_ctrl_sig : std_logic_vector(2 downto 0);



---------------------------------------------------------------------
-----------------------------  MEM Stage ----------------------------
---------------------------------------------------------------------

signal Mem_ALU_out, Mem_write_data, Mem_read_data : std_logic_vector(31 downto 0);
signal MEM_rd : std_logic_vector(4 downto 0);
signal Mem_sig, WB_mem_sig : std_logic_vector(1 downto 0);
signal Vout_data_mem, Vout_data: std_logic;


---------------------------------------------------------------------
-----------------------------  WB Stage -----------------------------
---------------------------------------------------------------------

signal WB_reg : std_logic_vector(1 downto 0);
signal WB_read_data, WB_ALU_out : std_logic_vector(31 downto 0);
signal WB_rd_add : std_logic_vector(4 downto 0);


---------------------------------------------------------------------
------------------------------ Port Map -----------------------------
---------------------------------------------------------------------

begin  

-------------------------------IF STAGE------------------------------

PC_sel <= CU_mux_out(PC_in_sel) or flush_sig; --flush_sig se il conditional branch va fatto è uguale a 1 altrimenti è 0 mentre CU_mux_out(PC_insel) è legato al JAL e JALR
					 
MUX1: mux2_to_1 generic map (Nbit => parallelism)
					 port map(SEL => PC_sel, A => IF_add_out, B => add_branch_out, OUTPUT => PC_in);--					 

Prog_Cnt_reg: PC generic map (Nbit => parallelism)
					  port map (Clock => CK, Resetn  =>RST_n , mem_Vout => Vout, R => PC_in, PCWrite => PCWrite, Q => PC_out);

--REQ è il segnale per chiedere alla memoria dei dati dato che è una pseudo  ROM può essere messo a 1 sempre
intr_mem: instructions_rom port map (CK => CK, RST_n => RST_n, REQ => '1', ADDX => PC_out, ACK => Vout_instr, Instr_out => IF_instr_out);

Vout <= Vout_instr and Vout_data_mem;
			  
incr <= std_logic_vector(to_unsigned(PC_incr, parallelism));
ADD1: ADD generic map (Nbit => parallelism)
			 port map (A => PC_out, B => incr, SUM => IF_add_out);

FLSH_SIG <= flush_sig;--and Vout;
			 
reg_pipe1: IF_ID port map (clk => CK, rst_n => RST_n, mem_Vout => Vout, seq_addr => IF_add_out, from_pc => PC_out, from_IM => IF_instr_out,
									IF_flush => FLSH_SIG, IF_ID_write => pipe_write, seq_to_ID_EX => ID_PC_new, PC_to_ID_EX => ID_PC_old,
									instr => ID_Instr_out);
					

-------------------------------ID STAGE------------------------------
					  
zeros16 <= (others => '0');

haz_ctrl_branch <= CU_out(13) or  CU_out(12) or CU_out(11) or CU_out(10); 					  

hazard_unit: hazard_detection_unit port map (InFID_rs1 =>ID_Instr_out(19 downto 15), InFID_rs2 =>ID_Instr_out(24 downto 20), IDEX_rd => EX_rd,
															IDEX_memread => M_sig(0),branch_CU=>haz_ctrl_branch,EXMEM_rd=>MEM_rd, PCWrite => PCWrite, InFIDWrite => pipe_write, Control_mux => to_control_mux);
											
											
CU: control_unit port map (OPCODE => ID_Instr_out(6 downto 0) , FUNCT3 => ID_Instr_out(14 downto 12), not_equal_comp => not_equal,
									greater_comp => greater, CU_OUT => CU_out, FLUSH => flush_sig, EN_FU=> CU_FU_EN);
									
									
MUX4: mux2_to_1 generic map (Nbit => 16)
					 port map (SEL => to_control_mux, A => CU_out, B => zeros16, OUTPUT => CU_mux_out);
--CU_mux_out <= CU_out when(to_control_mux='1')  else (others => '0');
					 
MUX3: mux2_to_1 generic map (Nbit => 32)
					 port map (SEL => CU_mux_out(14), A => ID_PC_old, B => rs1, OUTPUT => sig4);
					 
					 
ADD2: ADD generic map (Nbit => parallelism)
			 port map (A => sig4, B => ID_Imm_gen_out, SUM => add_branch_out);
			 
		
Reg_File: REGISTER_FILE generic map (N => 32)
								port map (Clock => CK, Resetn => RST_n, WR_reg => WB_reg(1), RD_reg1_add => ID_Instr_out(19 downto 15), RD_reg2_add => ID_Instr_out(24 downto 20),
											 WR_reg_add => WB_rd_add, WR_reg_data => sig_write, RD_reg1_data => rs1, RD_reg2_data => rs2);
											 
											 
cmp : comparator port map (data_x => rs1, data_y => rs2, not_equal => not_equal, greater=> greater);


Imm_Generator : imm_gen port map (instruction_in => ID_Instr_out, gen_value_out => ID_Imm_gen_out);


WB_vect <= (CU_mux_out(9) & CU_mux_out(0));
EX_vect <= (CU_mux_out(13 downto 10) & CU_mux_out(8 downto 3));
funct_vect <= (ID_Instr_out(30) & ID_Instr_out(14 downto 12));

reg_pipe2 : ID_EX port map (clk => CK, rst_n => RST_n, EX_FU_EN_in => CU_FU_EN, mem_Vout => Vout, WB => WB_vect, M => CU_mux_out(2 downto 1), EX => EX_vect,
									 seq => ID_PC_new, pc_old => ID_PC_old, data_rs1 => rs1, data_rs2 => rs2, imm_gen => ID_Imm_gen_out, instr_rs1 => ID_Instr_out(19 downto 15),
									 instr_rs2 => ID_Instr_out(24 downto 20), funct => funct_vect, instr_rd => ID_Instr_out(11 downto 7),
									 WB_out => WB_sig, M_out => M_sig, EX_out => EX_sig,
									 seq_out =>EX_seq, pc_old_out => EX_old, data_rs1_out => EX_data_rs1, data_rs2_out => EX_data_rs2, imm_gen_out => EX_imm, instr_rs1_out => EX_rs1, instr_rs2_out => EX_rs2,
									 funct_out => EX_funct, instr_rd_out => EX_rd, EX_FU_EN_out=> EX_FU_EN);


-------------------------------EX STAGE------------------------------	
												
MUX5: mux4_to_1 generic map (Nbit => 32)
					 port map (SEL => EX_sig(5 downto 4), A => EX_seq, B => EX_old, C => EX_data_rs1, OUTPUT => mux5_out);

MUX6: mux3_to_1 generic map (Nbit => 32)
					 port map (SEL => EX_sig(3 downto 2), A => EX_data_rs2, B => EX_imm, OUTPUT => mux6_out);

MUX7: mux4_to_1 generic map (Nbit => 32)
					 port map (SEL => forwardA, A => mux5_out, B => sig_write, C => Mem_ALU_out, OUTPUT => mux7_out);

MUX8: mux4_to_1 generic map (Nbit => 32)
					 port map (SEL => forwardB, A => mux6_out, B => sig_write, C => Mem_ALU_out, OUTPUT => mux8_out);

ALUnit: ALU port map (IN_A => mux7_out, IN_B => mux8_out, ALU_CTRL_IN => ALU_ctrl_sig, ALU_OUT => ALU_out, ZERO_OUT => alu_zero_out);

ALUControl: ALU_CTRL port map (ALU_OP => EX_sig(1 downto 0), FUNCT3 => EX_funct(2 downto 0), FUNCT7 => EX_funct(3), ALU_CTRL_OUT => ALU_ctrl_sig);

for_unit: forwarding_unit port map (IDEX_rs1 => EX_rs1, IDEX_rs2 => EX_rs2, EXMEM_rd => MEM_rd, MEMWB_rd => WB_rd_add, EXMEM_regwrite => WB_mem_sig(1), MEMWB_regwrite => WB_reg(1), FU_EN => EX_FU_EN, forwardA => forwardA, forwardB => forwardB);

reg_pipe3: EX_MEM port map (clk => CK, rst_n => RST_n, mem_Vout => Vout, WB => WB_sig, M => M_sig, alu => ALU_out, to_ram_in => EX_data_rs2, rd => EX_rd, WB_out => WB_mem_sig, M_out => MEM_sig, alu_out => Mem_ALU_out, to_ram_out => MEM_write_data, rd_out => MEM_rd);


-------------------------------MEM STAGE-----------------------------

data: data_mem port map (clk => CK, RSTn => RST_n, WEN =>  MEM_sig(1), DIN => Mem_write_data, WADX => Mem_ALU_out, READ => MEM_sig(0), ACK => Vout_data, DOUT => Mem_read_data);


Vout_data_mem <= (Vout_data or (not(MEM_sig(1)) and not(MEM_sig(0)))) ;
reg_pipe4: MEM_WB port map (clk => CK, rst_n => RST_n, mem_Vout => Vout , WB => WB_mem_sig, alu => Mem_ALU_out, data_mem => Mem_read_data, rd => MEM_rd, WB_out => WB_reg, alu_out => WB_ALU_out,  data_mem_out => WB_read_data, rd_out => WB_rd_add);

-------------------------------WB STAGE------------------------------

MUX9: mux2_to_1 generic map (Nbit => 32)
					 port map(SEL => WB_reg(0), A => WB_ALU_out, B => WB_read_data, OUTPUT => sig_write);


end Behavior; 
