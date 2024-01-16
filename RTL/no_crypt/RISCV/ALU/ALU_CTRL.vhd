library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity ALU_CTRL is    
	port (   
		ALU_OP : in std_logic_vector(1 downto 0);
		FUNCT3 : in std_logic_vector(2 downto 0); 
		FUNCT7 : in std_logic;---L'UNICO INTERESSANTE È IL BIT 30 DEL INSTRUCTION INIZIANDO DA 0
		ALU_CTRL_OUT : out std_logic_vector(2 downto 0));
end ALU_CTRL; 
 
architecture Behavior of ALU_CTRL is 

begin 
	process (ALU_OP, FUNCT3, FUNCT7)  
	begin   
		case ALU_OP is
            	when "00" =>	case funct3 is --R type instr
										when "000" =>	if(FUNCT7='0') then
															ALU_CTRL_OUT <= "011"; --add
														else
															ALU_CTRL_OUT <= "100"; --sub
														end if;
										when "100" =>	ALU_CTRL_OUT <= "010"; --xor
										when "111" =>	ALU_CTRL_OUT <= "111"; --and
										when "110" =>	ALU_CTRL_OUT <= "001"; --or
										when "101" =>	ALU_CTRL_OUT <= "101"; --sra
										when "001" =>	ALU_CTRL_OUT <= "110"; --sll
										when others =>	ALU_CTRL_OUT <= (others =>'0'); --default
					        	end case;
            	when "01" =>	case funct3 is -- arithmetic I type instr
										when "000" =>	ALU_CTRL_OUT <= "011"; --add				
										when "100" =>	ALU_CTRL_OUT <= "010"; --xor
										when "111" =>	ALU_CTRL_OUT <= "111"; --and
										when "110" =>	ALU_CTRL_OUT <= "001"; --or
										when "101" =>	ALU_CTRL_OUT <= "101"; --sra
										when "001" =>	ALU_CTRL_OUT <= "110"; --sll
										when others =>	ALU_CTRL_OUT <= (others =>'0'); --default
					        	end case;
            	when "10" =>	ALU_CTRL_OUT <= "011"; --(jalr or lw) I type, S type, u type or UJ type
            	when "11" =>	ALU_CTRL_OUT <= "100"; -- SB TYPE
				when others =>	ALU_CTRL_OUT <= (others =>'0'); --default
        	end case;
	end process; 

end Behavior;   
