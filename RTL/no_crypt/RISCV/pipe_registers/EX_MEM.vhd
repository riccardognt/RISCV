library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity EX_MEM is

	Port (clk : in std_logic;
		  rst_n : in std_logic;
		  mem_Vout : in std_logic; 

		  WB : in std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)
		  M : in std_logic_vector(1 downto 0); -- mem_write + mem_read(ID/EX.MemRead)
		  
          alu : in std_logic_vector(31 downto 0);
		  to_ram_in : in std_logic_vector(31 downto 0);
		  rd : in std_logic_vector(4 downto 0);

		  WB_out : out std_logic_vector(1 downto 0); -- mem_to_reg + EX_MEM_regwrite(MEM_WB_regwrite)
		  M_out : out std_logic_vector(1 downto 0); -- mem_write + mem_read(ID/EX.MemRead)
		  
          alu_out : out std_logic_vector(31 downto 0);
		  to_ram_out : out std_logic_vector(31 downto 0);
		  rd_out : out std_logic_vector(4 downto 0));
end EX_MEM;

architecture Behavioral of EX_MEM is
begin

	process(clk, rst_n)
	begin
		if(rst_n = '0') then
		  WB_out <= (others => '0');
		  M_out <= (others => '0');

		  alu_out <= (others => '0');
		  to_ram_out <= (others => '0');
		  rd_out <= (others => '0');
		  
		else
			if(clk = '1' and clk'event) then
				if mem_Vout = '1' then
					WB_out <= WB;
		  			M_out <= M;
		  			alu_out <= alu;
		  			to_ram_out <= to_ram_in;
		  			rd_out <= rd;
				end if;
			end if;
		end if;

	end process;
end Behavioral;
