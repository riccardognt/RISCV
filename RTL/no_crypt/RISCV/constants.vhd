library ieee; 
use ieee.std_logic_1164.all; 

package constants is 


constant parallelism : integer := 32; 
constant add_length : integer := 10;
constant PC_incr : integer := 4;

----------------------------------instructions opcodes ------------------------------------------------------

constant R_opcode : std_logic_vector(6 downto 0) := "0110011";
constant I_and_mem_opcode : std_logic_vector(6 downto 0) := "0000011";
constant I_and_alu_opcode : std_logic_vector(6 downto 0) := "0010011";
constant I_and_jalr_opcode : std_logic_vector(6 downto 0) := "1100111";
constant S_opcode : std_logic_vector(6 downto 0) := "0100011";
constant SB_opcode : std_logic_vector(6 downto 0) := "1100011";
constant U_lui_opcode : std_logic_vector(6 downto 0) := "0110111";
constant U_auipc_opcode : std_logic_vector(6 downto 0) := "0010111";
constant UJ_jal_opcode : std_logic_vector(6 downto 0) := "1101111";
----------------------------------control unit signals ------------------------------------------------------
constant PC_in_sel : integer := 15;
constant jalr_sel : integer := 14;

constant BGE : integer := 13;
constant BLT : integer := 12;
constant BEQ : integer := 11;
constant BNQ : integer := 10;

constant WR_REG_FILE : integer := 9;

constant IN_SEL_A_START : integer := 8;
constant IN_SEL_A_END : integer := 7;

constant IN_SEL_B_START : integer := 6;
constant IN_SEL_B_END : integer := 5;

constant ALU_OP_START : integer := 4;
constant ALU_OP_END : integer := 3;

constant MEM_WR : integer := 2;
constant MEM_RD : integer := 1;
constant MEM_TO_REG : integer := 0;


----------------------------------control unit output ------------------------------------------------------
constant auipc_cu : std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0000" & '1' & "01" & "01" & "10" & "000";
constant imm_alu_cu : std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0000" & '1' & "10" & "01" & "01" & "000";
constant R_instr_cu : std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0000" & '1' & "10" & "00" & "00" & "000";
constant jal_cu : std_logic_vector(15 DOWNTO 0) := '1' & '0' & "0000" & '1' & "00" & "10" & "10" & "000";
constant jalr_cu: std_logic_vector(15 DOWNTO 0) := '1' & '1' & "0000" & '1' & "00" & "10" & "10" & "000";
constant lui_cu : std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0000" & '1' & "11" & "01" & "10" & "000";
constant sw_cu : std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0000" & '0' & "10" & "01" & "10" & "100";
constant lw_cu : std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0000" & '1' & "10" & "01" & "10" & "011";
constant bge_cu: std_logic_vector(15 DOWNTO 0) := '0' & '0' & "1000" & '0' & "10" & "00" & "11" & "000";
constant blt_cu: std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0100" & '0' & "10" & "00" & "11" & "000";
constant beq_cu: std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0010" & '0' & "10" & "00" & "11" & "000";
constant bnq_cu: std_logic_vector(15 DOWNTO 0) := '0' & '0' & "0001" & '0' & "10" & "00" & "11" & "000";
 

end constants;
