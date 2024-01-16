library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity data_mem is
  port (
    CLK     : in  std_logic;
    RSTn    : in  std_logic;
    WEN     : in  std_logic;
    DIN     : in  std_logic_vector(31 downto 0);
    WADX    : in  std_logic_vector(31 downto 0);
    READ    : in  std_logic;
	ACK		: out std_logic;
    DOUT    : out std_logic_vector(31 downto 0));
end data_mem;

architecture beh of data_mem is

  constant tco : time := 1 ns;
  constant tpd : time := 1 ns;

  --constant DATA_LAST_ADX : std_logic_vector(10 downto 0) := (others => '1');
  --constant STACK_LAST_ADX : std_logic_vector(10 downto 0) := (others => '1');
  
  component sram_32_1024_freepdk45 is
    port (
      clk0 : in std_logic;
      csb0 : in std_logic;
      web0 : in std_logic;
      addr0 : in std_logic_vector(9 downto 0);
      din0  : in std_logic_vector(31 downto 0);
      dout0 : out std_logic_vector(31 downto 0));
  end component;

  signal s_csb : std_logic; 
  signal s_web : std_logic;

  signal req, req1 : std_logic;
  
begin  -- architecture beh
 
  s_csb <= not(READ xor WEN);
  s_web <= not(WEN);
  req <= READ or WEN;

  ram : sram_32_1024_freepdk45
    port map (
      clk0  => CLK,
      csb0  => s_csb,
      web0  => s_web,
      addr0 => WADX(11 downto 2),
      din0  => DIN,
      dout0 => DOUT);

	process (CLK, RSTn) is
  	begin  -- process
    	if RSTn = '0' then                  -- asynchronous reset (active low)
      		req1 <= '0';
    	elsif CLK'event and CLK = '1' then  -- rising clock edge
			req1 <=req;
		end if;
	end process;

	process (CLK, RSTn) is
  	begin  -- process
    	if RSTn = '0' then                  -- asynchronous reset (active low)
      		ACK <='0';
    	elsif (CLK'event and CLK = '1') then  -- rising clock edge
			ACK <=req1;
		end if;
	end process;
end beh;
