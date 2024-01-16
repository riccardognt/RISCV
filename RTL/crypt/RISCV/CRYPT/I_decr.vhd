library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.constants.all;
 
entity I_decr is    
	port (   
		Clock : in  std_logic;
		Resetn : in  std_logic;
		PC_add : in std_logic_vector(31 downto 0);
		mux_out : in std_logic_vector(31 downto 0);
		SIG_K, SIG_I : in std_logic; --from CU
		LOAD_ADD_IN : in std_logic; -- from CU
		I_Mem_add : out std_logic_vector(31 downto 0);
		K_Mem_add : out std_logic_vector(31 downto 0);
		to_pipe : out std_logic_vector(31 downto 0)); 
end I_decr; 
 
architecture Behavior of I_decr is

signal stored_key, stored_instr : std_logic_vector(31 downto 0);

begin

-- address process
	process (Clock, Resetn)
	begin
		if(Resetn = '0') then
			K_Mem_add <= (others => '0');
			I_Mem_add <= (others => '0');
			to_pipe <= (others => '0');
			stored_key <= (others => '0');
			stored_instr <= (others => '0');

		elsif rising_edge(Clock) then
			if(LOAD_ADD_IN = '1') then -- and gate between the ACK of the 2 memories
				K_Mem_add <= PC_Add;
				I_Mem_add <= PC_Add;
			end if;
			if (SIG_K = '1') then
				stored_key <= mux_out;
			end if;
			if (SIG_I = '1') then
				to_pipe <= (stored_key xor mux_out);
			end if;


		end if;
	end process;

end Behavior;   
