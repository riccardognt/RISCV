library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity K_MEM is
  port( 
    CK, RST_n : in  std_logic;
	ADDX: in std_logic_vector(parallelism-1 downto 0);
	LOAD_ADD_MEM: in std_logic; -- from CU
	ACK: out std_logic;  
    Instr_out : out std_logic_vector(parallelism-1 DOWNTO 0));
end K_MEM;

architecture beh of K_MEM is  
  component sram_32_1024_freepdk45 is
    port (
      clk0 : in std_logic;
      csb0 : in std_logic;
      web0 : in std_logic;
      addr0 : in std_logic_vector(9 downto 0);
      din0  : in std_logic_vector(31 downto 0);
      dout0 : out std_logic_vector(31 downto 0));
  end component;

  signal s_csb0, s_web: std_logic;
  signal address : std_logic_vector(9 downto 0);
  signal add_old: std_logic_vector(31 downto 0):= (others => '0');
  signal s_ACK: std_logic := '1';
  signal d_out: std_logic_vector(31 downto 0);
  
begin  -- architecture beh

	s_csb0<= '0';
	s_web<= '1';

 --      address process
  	process(CK, RST_n)
	  begin
		  if(RST_n = '0') then
			  address <= (others => '0');
		  elsif rising_edge(CK) then
		  	if(LOAD_ADD_MEM = '1') then
				address <= "000000" & ADDX(7 downto 4);
		  	end if;
		  end if;
	  end process;
		
	Rom_mem:
		sram_32_1024_freepdk45 
			port map (
				clk0 => CK,
      			csb0 =>s_csb0,
      			web0 =>s_web,
     			addr0 =>address,
      			din0  =>(others => '0'),
      			dout0 =>d_out);

	--ACK <= s_ACK;

	process (CK, RST_n)
	begin
		if(RST_n = '0') then
			ACK <= '0';
			Instr_out <= (others => '0');


		elsif (rising_edge(CK)) then
			if(ADDX /= add_old ) then
				ACK <= '0';
			add_old <= ADDX;
			Instr_out <= d_out;
			else 
				ACK <= '1';
			add_old <= ADDX;
			Instr_out <= d_out;
			end if;

		end if;
	end process;
			
	
end beh;
