library ieee; 
use ieee.std_logic_1164.all; 
use work.constants.all;

package components_package is 

--crypt unit--------------------------------------------

	component crypt_unit is
		port (
		CK, RST_n : in  std_logic;
		from_mux : in std_logic_vector(31 downto 0);
		pc_write : in std_logic;
		Vout_data: in std_logic;
		INSTR_OUT : out std_logic_vector(31 downto 0);
		ack: out std_logic;
		seq_out : out std_logic_vector(31 downto 0);
		pc_old : out std_logic_vector(31 downto 0));
		end component;


--------------------------------------------------------

	component PC is  
		generic ( Nbit : integer:=32);  
		port ( 
			Clock : in  std_logic;
			Resetn : in  std_logic;
			mem_Vout : in std_logic; 
			R : in std_logic_vector(Nbit-1 downto 0); 
			PCWrite : in std_logic;
			Q : buffer std_logic_vector(Nbit-1 DOWNTO 0)); 
	end component;

	component ADD is
		generic( Nbit: integer := 32);
		port (
		    A : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); --inputs in 14 bits, datas are already in signed format
		    B : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
		    SUM : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
		    );
	end component;
	component instructions_rom is
		port (
			CK, RST_n : in  std_logic;
			REQ: in  std_logic;
			ADDX: in std_logic_vector(parallelism-1 downto 0);
			ACK: out std_logic;  
			Instr_out : out std_logic_vector(parallelism-1 DOWNTO 0));
	end component;

	component imm_gen is
		port (
			instruction_in: in  std_logic_vector(parallelism-1 DOWNTO 0);  
			gen_value_out : out std_logic_vector(parallelism-1 DOWNTO 0));
	end component;

	component REGISTER_FILE is  
		generic ( N : integer:=32);  
		port (   
			Clock : in  std_logic; 
			Resetn : in  std_logic;
			WR_reg : in  std_logic;
			RD_reg1_add : in std_logic_vector(4 downto 0);
			RD_reg2_add : in std_logic_vector(4 downto 0); 
			WR_reg_add : in std_logic_vector(4 downto 0);
			WR_reg_data : in std_logic_vector(31 downto 0);
			RD_reg1_data : out std_logic_vector(31 downto 0);
			RD_reg2_data : out std_logic_vector(31 downto 0)); 
	end component;

	component ALU_CTRL is    
		port (   
			ALU_OP : in std_logic_vector(1 downto 0);
			FUNCT3 : in std_logic_vector(2 downto 0); 
			FUNCT7 : in std_logic;---L'UNICO INTERESSANTE È IL BIT 30 DEL INSTRUCTION
			ALU_CTRL_OUT : out std_logic_vector(2 downto 0));
	end component;
	component ALU is    
		port (   
			IN_A : in std_logic_vector(31 downto 0);
			IN_B : in std_logic_vector(31 downto 0); 
			ALU_CTRL_IN : in std_logic_vector(2 downto 0);
			ALU_OUT: out std_logic_vector(31 downto 0);
			ZERO_OUT: out std_logic
			--OVF_OUT : out  std_logic
			);
	end component;

	component control_unit is
		port (
			OPCODE : in  std_logic_vector(6 DOWNTO 0);
			FUNCT3 : in  std_logic_vector(2 DOWNTO 0);
			not_equal_comp : in std_logic;
			greater_comp : in std_logic; 
			CU_OUT : out std_logic_vector(15 DOWNTO 0);
			FLUSH : out std_logic;
			EN_FU : out std_logic);
	end component;

	component data_mem is
		port (
			CLK     : in  std_logic;
			RSTn    : in  std_logic;
			WEN     : in  std_logic;
			DIN     : in  std_logic_vector(31 downto 0);
			WADX    : in  std_logic_vector(31 downto 0);
			READ    : in  std_logic;
			ACK		: out std_logic;
			DOUT    : out std_logic_vector(31 downto 0));
	end component;

	component branch_circuit is
		port (
			BEQ, BNQ, BGE, BLT : in STD_LOGIC;
			ALU_OUT_SIGN, ALU_OUT_ZERO : in STD_LOGIC;
			BRANCH : out STD_LOGIC
		    );
	end component;

	component mux2_to_1 is
		generic( Nbit: integer := 32);
		port (
			SEL : in  STD_LOGIC;
		    A : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
		    B : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
		    OUTPUT : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
		    );
	end component;
	component mux3_to_1 is
		generic( Nbit: integer := 32);
		port (
			SEL : in  STD_LOGIC_VECTOR(1 downto 0);
		    A : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); 
		    B : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
		    OUTPUT : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
		    );
	end component;
	component mux4_to_1 is
		generic( Nbit: integer := 32);
		port (
			SEL : in  STD_LOGIC_VECTOR(1 downto 0);
		    A : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
		    B : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
			C : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
		    OUTPUT : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
		    );
	end component;

	component comparator is
		Port(data_x : in std_logic_vector(31 downto 0);
			 data_y : in std_logic_vector(31 downto 0);
			 not_equal : out std_logic;
			 greater : out std_logic);
	end component;

	component forwarding_unit is
		Port(	IDEX_rs1 : in std_logic_vector(4 downto 0);
				IDEX_rs2 : in std_logic_vector(4 downto 0);
				EXMEM_rd : in std_logic_vector(4 downto 0);
				MEMWB_rd : in std_logic_vector(4 downto 0);
				EXMEM_regwrite : in std_logic;
				MEMWB_regwrite: in std_logic;
				FU_EN: in std_logic;
				forwardA : out std_logic_vector(1 downto 0);
				forwardB : out std_logic_vector(1 downto 0));
	end component;

	component hazard_detection_unit is
		Port (InFID_rs1 : in std_logic_vector(4 downto 0);
		    InFID_rs2 : in std_logic_vector(4 downto 0);
		    IDEX_rd : in std_logic_vector(4 downto 0);
		    IDEX_memread : in std_logic;
		    branch_CU:in std_logic;
		    EXMEM_rd : in std_logic_vector(4 downto 0);
		 
		    PCWrite : out std_logic;
		    InFIDWrite : out std_logic;
		    Control_mux : out std_logic);
	end component;

	component IF_ID is
		Port(clk : in std_logic;
		  rst_n : in std_logic;
		  mem_Vout : in std_logic;

		  seq_addr : in std_logic_vector(31 downto 0);
		  from_pc : in std_logic_vector(31 downto 0);
		  from_IM : in std_logic_vector(31 downto 0);

		  IF_flush : in std_logic;
		  IF_ID_write : in std_logic;

		
		  seq_to_ID_EX : out std_logic_vector(31 downto 0);
		  PC_to_ID_EX : out std_logic_vector(31 downto 0);
		  instr : out std_logic_vector(31 downto 0));
	end component;


	component ID_EX is
		Port(clk : in std_logic;
		  rst_n : in std_logic;
		  EX_FU_EN_in : in std_logic;
		  mem_Vout : in std_logic;

		  WB : in std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)
		  M : in std_logic_vector(1 downto 0); -- mem_write + mem_read(ID/EX.MemRead)
		  EX : in std_logic_vector(9 downto 0); -- d1_sel + ALU_src + ALU_op + BEQ,BGE,BLT,BNQ
		  
          seq : in std_logic_vector(31 downto 0);
		  pc_old : in std_logic_vector(31 downto 0);
		  data_rs1 : in std_logic_vector(31 downto 0);
		  data_rs2 : in std_logic_vector(31 downto 0);
		  imm_gen : in std_logic_vector(31 downto 0);
		  instr_rs1 : in std_logic_vector(4 downto 0);
		  instr_rs2 : in std_logic_vector(4 downto 0);
		  funct : in std_logic_vector(3 downto 0);
		  instr_rd : in std_logic_vector(4 downto 0);

		  WB_out : out std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)
		  M_out : out std_logic_vector(1 downto 0); -- mem_write + mem_read(ID/EX.MemRead)
		  EX_out : out std_logic_vector(9 downto 0); -- d1_sel + ALU_src + ALU_op
		  
          seq_out : out std_logic_vector(31 downto 0);
		  pc_old_out : out std_logic_vector(31 downto 0);
		  data_rs1_out : out std_logic_vector(31 downto 0);
		  data_rs2_out : out std_logic_vector(31 downto 0);
		  imm_gen_out : out std_logic_vector(31 downto 0);
		  instr_rs1_out : out std_logic_vector(4 downto 0);
		  instr_rs2_out : out std_logic_vector(4 downto 0);
		  funct_out : out std_logic_vector(3 downto 0);
		  instr_rd_out : out std_logic_vector(4 downto 0);
		  EX_FU_EN_out : out std_logic);
	end component;


	component EX_MEM is
		Port(clk : in std_logic;
		  rst_n : in std_logic;
		  mem_Vout : in std_logic; 

		  WB : in std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)
		  M : in std_logic_vector(1 downto 0); -- mem_write + mem_read(ID/EX.MemRead)
		  
          alu : in std_logic_vector(31 downto 0);
		  to_ram_in : in std_logic_vector(31 downto 0);
		  rd : in std_logic_vector(4 downto 0);

		  WB_out : out std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)
		  M_out : out std_logic_vector(1 downto 0); -- mem_write + mem_read(ID/EX.MemRead)
		  
          alu_out : out std_logic_vector(31 downto 0);
		  to_ram_out : out std_logic_vector(31 downto 0);
		  rd_out : out std_logic_vector(4 downto 0));
	end component;

	component MEM_WB is
	Port (clk : in std_logic;
		  rst_n : in std_logic;
		  mem_Vout : in std_logic; 

		  WB : in std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)
		  
          alu : in std_logic_vector(31 downto 0);
		  data_mem : in std_logic_vector(31 downto 0);
		  rd : in std_logic_vector(4 downto 0);
		  
		  WB_out : out std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)

          alu_out : out std_logic_vector(31 downto 0);
		  data_mem_out : out std_logic_vector(31 downto 0);
		  rd_out : out std_logic_vector(4 downto 0));
	end component;

	component PC_crypt is  
		generic ( Nbit : integer:=32);  
		port (   
			Clock : in  std_logic;
			Resetn : in  std_logic;
			LOAD_PC : in std_logic; --from CU
			R : in std_logic_vector(Nbit-1 downto 0); 
			PCWrite : in std_logic;
			Q : buffer std_logic_vector(Nbit-1 DOWNTO 0)); 
	end component;

	component CU is
		port ( CK, RST_n: in std_logic;
			   ACK: in std_logic;
			   clear: out std_logic;
			   load_add_in: out std_logic;
			   sig_k, sig_i: out std_logic;
			   load_add_mem: out std_logic;
			   sel: out std_logic;
			   load_pc: out std_logic);
	end component;

	component I_decr is
		Port(Clock : in  std_logic;
			Resetn : in  std_logic;
			PC_add : in std_logic_vector(31 downto 0);
			mux_out : in std_logic_vector(31 downto 0);
			SIG_K, SIG_I : in std_logic; --from CU
			LOAD_ADD_IN : in std_logic; -- from CU
			I_Mem_add : out std_logic_vector(31 downto 0);
			K_Mem_add : out std_logic_vector(31 downto 0);
			to_pipe : out std_logic_vector(31 downto 0));
	end component;

	component K_MEM is
		Port(CK, RST_n : in  std_logic;
		ADDX: in std_logic_vector(parallelism-1 downto 0);
		LOAD_ADD_MEM: in std_logic; -- from CU
		ACK: out std_logic;  
		Instr_out : out std_logic_vector(parallelism-1 DOWNTO 0));
	end component;

	component I_MEM is
		Port(CK, RST_n : in  std_logic;
		ADDX: in std_logic_vector(parallelism-1 downto 0);
		LOAD_ADD_MEM: in std_logic; -- from CU
		ACK: out std_logic;  
		Instr_out : out std_logic_vector(parallelism-1 DOWNTO 0));
	end component;

end components_package;
