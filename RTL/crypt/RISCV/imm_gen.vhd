library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.constants.all;


entity imm_gen is
	port (
		instruction_in: in  std_logic_vector(parallelism-1 DOWNTO 0);  
		gen_value_out : out std_logic_vector(parallelism-1 DOWNTO 0));
end imm_gen; 
 
architecture Behavior of imm_gen is 

begin  

	process (instruction_in)  
	begin   
		case instruction_in(6 DOWNTO 0) is
            	WHEN I_and_mem_opcode | I_and_jalr_opcode  =>	IF(instruction_in(31)='1') THEN
																						gen_value_out(31 DOWNTO 12) <= (OTHERS=>'1');
																						gen_value_out(11 DOWNTO 0)  <= instruction_in(31 DOWNTO 20);
																					ELSE 
																						gen_value_out(31 DOWNTO 12) <= (OTHERS=>'0');
																						gen_value_out(11 DOWNTO 0)  <= instruction_in(31 DOWNTO 20); 																						END IF;
				WHEN I_and_alu_opcode =>	IF(instruction_in(14 DOWNTO 12)="001" OR instruction_in(14 DOWNTO 12)="101" ) THEN 
												-- SRAI SLLI E SRLI HANNO L'IMMEDIATE NEI BITDA 24 A 20 SOLO CONTROLLA IL MANUALE
												gen_value_out(31 DOWNTO 5) <= (OTHERS=>'0');
												gen_value_out(4 DOWNTO 0)  <= instruction_in(24 DOWNTO 20);
											ELSE
												IF(instruction_in(31)='1') THEN
													gen_value_out(31 DOWNTO 12) <= (OTHERS=>'1');
													gen_value_out(11 DOWNTO 0)  <= instruction_in(31 DOWNTO 20);
												ELSE 
													gen_value_out(31 DOWNTO 12) <= (OTHERS=>'0');
													gen_value_out(11 DOWNTO 0)  <= instruction_in(31 DOWNTO 20); 												
												END IF;
											END IF;

				WHEN S_opcode =>	IF(instruction_in(31)='1') THEN
										gen_value_out(31 DOWNTO 12) <= (OTHERS=>'1');
										gen_value_out(11 DOWNTO 0) <= instruction_in(31 DOWNTO 25) & instruction_in(11 DOWNTO 7);
									ELSE
										gen_value_out(31 DOWNTO 12) <= (OTHERS=>'0');
										gen_value_out(11 DOWNTO 0) <= instruction_in(31 DOWNTO 25) & instruction_in(11 DOWNTO 7);
									END IF;
            	WHEN SB_opcode =>	IF(instruction_in(31)='1') THEN 
										gen_value_out(31 DOWNTO 13) <= (OTHERS=>'1');
										gen_value_out(12 DOWNTO 0) <= instruction_in(31) & instruction_in(7) & instruction_in(30 DOWNTO 25) & instruction_in(11 DOWNTO 8) & '0';
									ELSE 
										gen_value_out(31 DOWNTO 13) <= (OTHERS=>'0');
										gen_value_out(12 DOWNTO 0) <= instruction_in(31) & instruction_in(7) & instruction_in(30 DOWNTO 25) & instruction_in(11 DOWNTO 8) & '0';
									END IF;
				WHEN U_lui_opcode | U_auipc_opcode => 	gen_value_out(31 DOWNTO 12) <= instruction_in(31 DOWNTO 12); 
														gen_value_out(11 DOWNTO 0) <= (OTHERS => '0');
            	WHEN UJ_jal_opcode =>	IF(instruction_in(31)='1') THEN 
											gen_value_out(31 DOWNTO 21)<= (OTHERS => '1'); 
											gen_value_out(20 DOWNTO 0) <= instruction_in(31) & instruction_in(19 DOWNTO 12) & instruction_in(20) & instruction_in(30 DOWNTO 21) & '0';
										ELSE 
											gen_value_out(31 DOWNTO 21)<= (OTHERS => '0'); 
											gen_value_out(20 DOWNTO 0) <= instruction_in(31) & instruction_in(19 DOWNTO 12) & instruction_in(20) & instruction_in(30 DOWNTO 21) & '0';
										END IF;
            	WHEN OTHERS => gen_value_out <= (OTHERS => '0');
		end case;
	end process; 
	
end Behavior;    
