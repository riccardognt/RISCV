library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

--senza read enable
entity REGISTER_FILE is  
	generic ( N : integer:=32);  
	port (   
		Clock : in  std_logic; 
		Resetn : in  std_logic;
		WR_reg : in  std_logic;
		RD_reg1_add : in std_logic_vector(4 downto 0);
		RD_reg2_add : in std_logic_vector(4 downto 0); 
		WR_reg_add : in std_logic_vector(4 downto 0);
		WR_reg_data : in std_logic_vector(31 downto 0);
		RD_reg1_data : out std_logic_vector(31 downto 0);
		RD_reg2_data : out std_logic_vector(31 downto 0)); 
end REGISTER_FILE; 
 
architecture Behavior of REGISTER_FILE is 
	type reg_array is array(0 to 31) of std_logic_vector (31 downto 0);
	signal reg_file: reg_array := (others => x"00000000"); -- assign all 0

begin
	RD_reg1_data <= reg_file(to_integer(unsigned(RD_reg1_add)));
	RD_reg2_data <= reg_file(to_integer(unsigned(RD_reg2_add)));
	process (Clock, Resetn)  
	begin   
		if (Resetn = '0') then --reset asincrono
			reg_file(0 to 1)<= (others => x"00000000");
			reg_file(2)<= x"7fffeffc";
			reg_file(3)<= x"10008000";
			reg_file(4 to N-1) <= (others => x"00000000");   
		elsif (Clock'event and Clock = '1') then  	
			if (WR_reg ='1' and to_integer(unsigned(WR_reg_add))/=0) then
		            reg_file(to_integer(unsigned(WR_reg_add))) <= WR_reg_data;
		    end if;
		end if;  
	end process; 
end Behavior;   
