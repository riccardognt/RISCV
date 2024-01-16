library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity MEM_WB is

	Port (clk : in std_logic;
		  rst_n : in std_logic;
		  mem_Vout : in std_logic; 

		  WB : in std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)
		  
          alu : in std_logic_vector(31 downto 0);
		  data_mem : in std_logic_vector(31 downto 0);
		  rd : in std_logic_vector(4 downto 0);
		  
		  WB_out : out std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)

          alu_out : out std_logic_vector(31 downto 0);
		  data_mem_out : out std_logic_vector(31 downto 0);
		  rd_out : out std_logic_vector(4 downto 0));
end MEM_WB;

architecture Behavioral of MEM_WB is
begin

	process(clk, rst_n)
	begin
		if(rst_n = '0') then
		  WB_out <= (others => '0');

		  alu_out <= (others => '0');
		  data_mem_out <= (others => '0');
		  rd_out <= (others => '0');
		  
		else
			if(clk = '1' and clk'event) then
				if mem_Vout = '1' then
					WB_out <= WB;

		  			alu_out <= alu;
		  			data_mem_out <= data_mem;
		  			rd_out <= rd;
				end if;
			end if;
		end if;

	end process;
end Behavioral;
