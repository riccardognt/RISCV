LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
use work.constants.all;

entity mux2_to_1 is
    generic( Nbit: integer := 32);
    port (
		SEL : in  STD_LOGIC;
        A : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        B : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        OUTPUT : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
        );
end mux2_to_1;

architecture Behavioral of mux2_to_1 is
begin			
		process(SEL,A,B)
		begin
			if SEL='1' then 
				OUTPUT <= B;
			else
				OUTPUT <= A ;
			end if;
		end process;		
end Behavioral;
