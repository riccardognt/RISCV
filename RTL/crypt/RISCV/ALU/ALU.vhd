library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity ALU is    
	port (   
		IN_A : in std_logic_vector(31 downto 0);
		IN_B : in std_logic_vector(31 downto 0); 
		ALU_CTRL_IN : in std_logic_vector(2 downto 0);
		ALU_OUT: out std_logic_vector(31 downto 0);
		ZERO_OUT: out std_logic
		);
end ALU; 
 
architecture Behavior of ALU is 
constant zero_32_bit : std_logic_vector(31 downto 0):=(others =>'0');
signal output : std_logic_vector(31 downto 0):=(others =>'0');

begin 
	ZERO_OUT <= '1' when (output = zero_32_bit) else '0' ;
	ALU_OUT <= output;

	process (IN_A, IN_B, ALU_CTRL_IN)  
	begin   
		case ALU_CTRL_IN is
            	when "111" => output <= IN_A and IN_B;
            	when "001" => output <= IN_A or IN_B;
		when "010" => output <= IN_A xor IN_B;
            	when "011" => output <= std_logic_vector(signed(IN_A) + signed(IN_B));
            	when "100" => output <= std_logic_vector(signed(IN_A) - signed(IN_B));
		when "101" => output <= to_stdlogicvector(to_bitvector(IN_A) sra to_integer(unsigned(IN_B)));	--srai  
		when "110" => output <= to_stdlogicvector(to_bitvector(IN_A) sll to_integer(unsigned(IN_B)));	--slli
            	when others => output <= (others =>'0');
        	end case;
	end process; 

end Behavior;   
