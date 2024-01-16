library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.constants.all;
 
entity PC_crypt is  
	generic ( Nbit : integer:=32);  
	port (   
		Clock : in  std_logic;
		Resetn : in  std_logic;
		LOAD_PC : in std_logic; --from CU
		R : in std_logic_vector(Nbit-1 downto 0); 
		PCWrite : in std_logic;
		Q : buffer std_logic_vector(Nbit-1 DOWNTO 0)); 
end PC_crypt; 
 
architecture Behavior of PC_crypt is

	signal LOAD : std_logic;
	signal stored_data : std_logic_vector(Nbit-1 downto 0);
begin 
	LOAD <= not(PCWrite) and LOAD_PC;

	process (Clock, Resetn)  
	begin   
	if (Resetn = '0') then    
		stored_data <= x"00400000";  
	elsif rising_edge(Clock) then
			stored_data <= R;
	end if;
	end process;

	process (Clock, Resetn)
	begin
	
	if(Resetn = '0') then
		Q <= stored_data;
	elsif rising_edge(Clock) then
		if(LOAD = '1') then
			Q <= stored_data;
		end if;
	end if;
  
	end process; 
end Behavior;   
