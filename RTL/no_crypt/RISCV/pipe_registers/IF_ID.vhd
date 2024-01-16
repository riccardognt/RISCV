library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity IF_ID is

	Port (clk : in std_logic;
		  rst_n : in std_logic;
		  mem_Vout : in std_logic;

		  seq_addr : in std_logic_vector(31 downto 0);
		  from_pc : in std_logic_vector(31 downto 0);
		  from_IM : in std_logic_vector(31 downto 0);

		  IF_flush : in std_logic;
		  IF_ID_write : in std_logic;

		
		  
		  seq_to_ID_EX : out std_logic_vector(31 downto 0);
		  PC_to_ID_EX : out std_logic_vector(31 downto 0);
		  instr : out std_logic_vector(31 downto 0));
end IF_ID;

architecture Behavioral of IF_ID is
signal LOAD : std_logic;

begin
	LOAD <= not(IF_ID_write) and (mem_Vout);

	process(clk, rst_n)
	begin
		if(rst_n = '0') then
			seq_to_ID_EX <= (others => '0');
			PC_to_ID_EX <= (others => '0');
			instr <= (others => '0');
		else
			if(clk = '1' and clk'event) then
				if IF_FLUSH = '1' and LOAD = '1' then
					seq_to_ID_EX <= (others => '0');
					PC_to_ID_EX <= (others => '0');
					instr <= (others => '0');
				else
					if LOAD = '1' then 
						seq_to_ID_EX <= seq_addr;
						PC_to_ID_EX <= from_pc;
						instr <= from_IM;
					end if;
				end if;
			end if;
		end if;

	end process;
end Behavioral;

