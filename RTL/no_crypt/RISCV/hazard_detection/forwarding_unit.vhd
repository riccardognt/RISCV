library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity forwarding_unit is
    Port (IDEX_rs1 : in std_logic_vector(4 downto 0);
		IDEX_rs2 : in std_logic_vector(4 downto 0);
		EXMEM_rd : in std_logic_vector(4 downto 0);
		MEMWB_rd : in std_logic_vector(4 downto 0);
		EXMEM_regwrite : in std_logic;
		MEMWB_regwrite: in std_logic;
		
		FU_EN: in std_logic;
		forwardA : out std_logic_vector(1 downto 0);
		forwardB : out std_logic_vector(1 downto 0));
end forwarding_unit;

architecture beh of forwarding_unit is

begin
    process (IDEX_rs1, IDEX_rs2, EXMEM_rd, MEMWB_rd, EXMEM_regwrite, MEMWB_regwrite)
    begin

		if EXMEM_rd = IDEX_rs1 and EXMEM_regwrite = '1' and EXMEM_rd /= "00000" and FU_EN = '1' then
			forwardA <= "10";
			if EXMEM_rd = IDEX_rs2 and EXMEM_regwrite = '1' and EXMEM_rd /= "00000" and FU_EN = '1' then
		    	forwardB <= "10";
			elsif MEMWB_rd = IDEX_rs2 and MEMWB_regwrite = '1' and MEMWB_rd /= "00000" and FU_EN = '1' then
		    	forwardB <= "01";
			else
				forwardB <= "00";
			end if;       
		elsif MEMWB_rd = IDEX_rs1 and MEMWB_regwrite = '1' and MEMWB_rd /= "00000" and FU_EN = '1' then
			forwardA <= "01";
			if EXMEM_rd = IDEX_rs2 and EXMEM_regwrite = '1' and EXMEM_rd /= "00000" and FU_EN = '1' then
		    	forwardB <= "10";
			elsif MEMWB_rd = IDEX_rs2 and MEMWB_regwrite = '1' and MEMWB_rd /= "00000" and FU_EN = '1' then
		    	forwardB <= "01";
			else
				forwardB <= "00";
			end if; 
		else 
			forwardA <= "00";
			if EXMEM_rd = IDEX_rs2 and EXMEM_regwrite = '1' and EXMEM_rd /= "00000" and FU_EN = '1' then
		    	forwardB <= "10";
			elsif MEMWB_rd = IDEX_rs2 and MEMWB_regwrite = '1' and MEMWB_rd /= "00000" and FU_EN = '1' then
		    	forwardB <= "01";
			else
				forwardB <= "00";
			end if;
		end if;


		
    end process;
        
end architecture;

    
