library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
--use work.constants.all;
 
entity PC is  
	generic ( Nbit : integer:=32);  
	port (   
		Clock : in  std_logic;
		Resetn : in  std_logic;
		mem_Vout : in std_logic; 
		R : in std_logic_vector(Nbit-1 downto 0); 
		PCWrite : in std_logic;
		Q : buffer std_logic_vector(Nbit-1 DOWNTO 0)); 
end PC; 
 
architecture Behavior of PC is

	signal LOAD : std_logic;
begin 
	LOAD <= not(PCWrite) and (mem_Vout);

	process (Clock, Resetn)  
	begin   
	if (Resetn = '0') then    
		Q <= x"00400000";   
	elsif (Clock'event and Clock = '1') then
		if LOAD = '1' then 
			Q <= R;  
		end if;
	end if;  
	end process; 
end Behavior;   
