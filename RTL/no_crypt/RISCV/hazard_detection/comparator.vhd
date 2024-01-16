library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator is
	Port(data_x : in std_logic_vector(31 downto 0);
		 data_y : in std_logic_vector(31 downto 0);
		 not_equal : out std_logic;
		 greater : out std_logic);
end comparator;

architecture Behavioral of comparator is
begin
	process(data_x, data_y)
	begin
		if(data_x = data_y) then
			not_equal <= '0';
		else
			not_equal <= '1';
		end if;

		if(data_x >= data_y) then
			greater <= '1';
		else
			greater <= '0';
		end if;
	end process;

end Behavioral;
