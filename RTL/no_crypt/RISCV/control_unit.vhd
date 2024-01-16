library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.constants.all;


entity control_unit is
	port (
		OPCODE : in  std_logic_vector(6 DOWNTO 0);
		FUNCT3 : in  std_logic_vector(2 DOWNTO 0);
		not_equal_comp : in std_logic;
		greater_comp : in std_logic; 
		CU_OUT : out std_logic_vector(15 DOWNTO 0);
		FLUSH : out std_logic;
		EN_FU : out std_logic --ENABLE FORWARDING UNIT
		);
end control_unit; 
 
architecture Behavior of control_unit is 

begin  

	process (OPCODE,FUNCT3, not_equal_comp, greater_comp)  
	begin   
		CASE OPCODE IS
            			WHEN U_auipc_opcode  =>	
							CU_OUT <= auipc_cu;
							EN_FU <= '0';
							FLUSH <= '0';
				WHEN I_and_alu_opcode =>	CU_OUT <= imm_alu_cu;
								EN_FU <= '1';
								FLUSH <= '0';

				WHEN R_opcode =>	CU_OUT <= R_instr_cu;
							EN_FU <= '1';
							FLUSH <= '0';
            			WHEN UJ_jal_opcode =>	CU_OUT <= jal_cu;
							FLUSH <= '1';
							EN_FU <= '0';
				WHEN I_and_jalr_opcode =>	CU_OUT <= jalr_cu;
								FLUSH <= '1';
								EN_FU <= '0';
            			WHEN U_lui_opcode =>	CU_OUT <= lui_cu;
							EN_FU <= '0';
							FLUSH <= '0';
            			WHEN S_opcode =>	CU_OUT <= sw_cu;
							EN_FU <= '1';
							FLUSH <= '0';
				WHEN I_and_mem_opcode =>	CU_OUT <= lw_cu;
								EN_FU <= '1';
								FLUSH <= '0';
				WHEN SB_opcode => CASE FUNCT3 IS 
							WHEN "000" => 	CU_OUT <= beq_cu;
									EN_FU <= '1';
									FLUSH <= '0';
							WHEN "001" => 	if(not_equal_comp = '1') then
										CU_OUT <= bnq_cu;
										EN_FU <= '1';
										FLUSH <= '1';
									else
										CU_OUT <= bnq_cu;
										EN_FU <= '1';
										FLUSH <= '0';
									end if;
							WHEN "101" =>	CU_OUT <= bge_cu;
									EN_FU <= '1';
									if(greater_comp = '1') then
										CU_OUT <= bge_cu;
										EN_FU <= '1';
										FLUSH <= '1';
									else
										CU_OUT <= bge_cu;
										EN_FU <= '1';
										FLUSH <= '0';
									end if;
							WHEN "100" =>	CU_OUT <= blt_cu;
									EN_FU <= '1';
									FLUSH <= '0';
							WHEN OTHERS => 	CU_OUT <= (OTHERS => '0');
									EN_FU <= '1';
									FLUSH <= '0';
							END CASE;
				WHEN OTHERS =>	CU_OUT <= (OTHERS => '0');
						FLUSH <= '0';
						EN_FU <= '0';

		END CASE;
	end process; 
	
end Behavior;    
