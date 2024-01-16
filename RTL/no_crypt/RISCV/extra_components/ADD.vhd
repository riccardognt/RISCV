LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
use work.constants.all;

entity ADD is
    generic( Nbit: integer := 32);
    port (
        A : in  STD_LOGIC_VECTOR(Nbit-1 downto 0); --inputs in 14 bits, datas are already in signed format
        B : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
        SUM : out  STD_LOGIC_VECTOR(Nbit-1 downto 0)
        );
end ADD;

architecture Behavioral of ADD is
begin			
		SUM <= std_logic_vector(unsigned(A)+unsigned(B));
end Behavioral;
