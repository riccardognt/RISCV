library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity instructions_rom is
  port (
    CK, RST_n : in  std_logic;
    REQ: in  std_logic;
	ADDX: in std_logic_vector(parallelism-1 downto 0);
	ACK: out std_logic;  
    Instr_out : out std_logic_vector(parallelism-1 DOWNTO 0));
end instructions_rom;

architecture beh of instructions_rom is  
  component sram_32_1024_freepdk45 is
    port (
      clk0 : in std_logic;
      csb0 : in std_logic;
      web0 : in std_logic;
      addr0 : in std_logic_vector(9 downto 0);
      din0  : in std_logic_vector(31 downto 0);
      dout0 : out std_logic_vector(31 downto 0));
  end component;

  signal s_csb0, s_web, s_ACK: std_logic;  
  
begin  -- architecture beh

	s_csb0<=not(REQ);
	s_web<=REQ;
	
	Rom_mem:
		sram_32_1024_freepdk45 
			port map (
				clk0 => CK,
      			csb0 =>s_csb0,
      			web0 =>s_web,
     			addr0 =>ADDX(add_length+1 downto 2),
      			din0  =>(others => '0'),
      			dout0 =>Instr_out);

	process(CK,RST_n)
	begin
		if(RST_n='0') then
			s_ACK<='0';
		elsif (CK'event and CK='1') then
			s_ACK<= s_ACK xor REQ;
		end if;
	end process;

	process(CK,RST_n)
	begin
		if(RST_n='0') then
			ACK<='0';
		elsif (CK'event and CK='1') then
			ACK<=s_ACK;
		end if;
	end process;
  
end beh;
