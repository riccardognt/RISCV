library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity ID_EX is

	Port (clk : in std_logic;
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
end ID_EX;

architecture Behavioral of ID_EX is
begin

	process(clk, rst_n)
	begin
		if(rst_n = '0') then
		  WB_out <= (others => '0');
		  M_out <= (others => '0');
		  EX_out <= (others => '0');
		  
          seq_out <= (others => '0');
		  pc_old_out <= (others => '0');
		  data_rs1_out <= (others => '0');
		  data_rs2_out <= (others => '0');
		  imm_gen_out <= (others => '0');
		  instr_rs1_out <= (others => '0');
		  instr_rs2_out <= (others => '0');
		  funct_out <= (others => '0');
		  instr_rd_out <= (others => '0');
		  EX_FU_EN_out<='0';
		else
			if(clk = '1' and clk'event) then
				if mem_Vout = '1' then
					WB_out <= WB;
		  			M_out <= M;
		  			EX_out <= EX;
		  
          			seq_out <= seq;
		  			pc_old_out <= pc_old;
		  			data_rs1_out <= data_rs1;
		  			data_rs2_out <= data_rs2;
		  			imm_gen_out <= imm_gen;
		  			instr_rs1_out <= instr_rs1;
		  			instr_rs2_out <= instr_rs2;
		  			funct_out <= funct;
		  			instr_rd_out <= instr_rd;
			
		  			EX_FU_EN_out<=EX_FU_EN_in;
				end if;
			end if;
		end if;

	end process;
end Behavioral;
