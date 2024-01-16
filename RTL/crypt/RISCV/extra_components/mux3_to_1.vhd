LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
use work.constants.all;

entity mux3_to_1 is
    generic( Nbit: integer := 32);
    port (
		SEL : in  STD_LOGIC_VECTOR(1 downto 0);
        A : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); 
        B : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        OUTPUT : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
        );
end mux3_to_1;

architecture Behavioral of mux3_to_1 is
begin			
		process(SEL,A,B)
		begin
			case SEL is
				when "00" => OUTPUT <= A ;
				when "01" => OUTPUT <= B ;
				when others => OUTPUT <= (others=>'0'); --nel caso del jal e del jalr
			end case;
		end process;		
end Behavioral;
