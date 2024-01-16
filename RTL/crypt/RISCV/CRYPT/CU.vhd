library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all; 

ENTITY CU IS
	 
	PORT ( CK, RST_n: in std_logic;
		   ACK: in std_logic;
			 
			 -- To Datapath
			 
		   clear: out std_logic;
		   load_add_in: out std_logic;
		   sig_k, sig_i: out std_logic;
		   load_add_mem: out std_logic;
		   sel: out std_logic;
		   load_pc: out std_logic);
			 
END CU;

ARCHITECTURE Behavioral OF CU IS
	
	TYPE state IS (RESET, ACK_state, ACK_state2, X, Y, Z, A, B, C, D, E);
	SIGNAL current,future: state;
   
BEGIN

	fsm1: process(CK, RST_n)
	begin

		if(RST_n = '0') then
			current <= RESET;
		elsif rising_edge(CK) then
			current <= future;
		end if;
	end process;

	
	fsm2: process(current, RST_n, ACK)
	begin
		
		case current is
	
				when RESET =>
		
					if (RST_n = '1') then
						future <= ACK_state;
					else
						future <= RESET;
					end if;
				
				when ACK_state =>
					if(ACK = '1') then
						future <= X;
					else
						future <= ACK_state;
					end if;

				when X =>
		
						future <= Y;

				when Y =>
					
						future <= Z;
					

				when Z =>
						future <= A;
			
				when A =>
					if (ACK = '1') then
						future <= B;
					else
						future <= A;
					end if;
			
				when B => 
						future <= ACK_state2;

				when ACK_state2 =>
						if(ACK ='1') then
						future <= C;
						else
						future <= ACK_state2;
						end if;
			
				when C =>
						future <= D;
					
					
				when D =>
					
						future <= E;
					

			
				when E =>
						future <= A;
				
		
				when others =>
					
					future <= RESET;
					
			end case;
	end process;
	
	fsm3: process(current)
	begin
		
		
		CASE current is
				
	
				WHEN RESET =>
					clear <= '0';
					load_add_in <= '0';
					sig_k <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';
					load_pc <= '0';

				when ACK_state =>
					clear <= '1';
					load_add_in <= '0';
					sig_k <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';
					load_pc <= '0';
				
				WHEN X =>
					sig_k <= '1';
					clear <= '1';
					load_add_in <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';
					load_pc <= '0';

				WHEN Y => 
					sel <= '1';
					sig_i <= '1';
					clear <= '1';
					load_add_in <= '0';
					sig_k <= '0';
					load_add_mem <= '0';
					load_pc <= '0';

				WHEN Z => 
					load_pc <= '1';
					clear <= '1';
					load_add_in <= '0';
					sig_k <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';

				WHEN A => 
					load_add_in <= '1';
					clear <= '1';
					sig_k <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';
					load_pc <= '0';
			
				WHEN B => 
					load_add_mem <= '1';
					clear <= '1';
					load_add_in <= '0';
					sig_k <= '0';
					sig_i <= '0';
					sel <= '0';
					load_pc <= '0';

				when ACK_state2 =>
					clear <= '1';
					load_add_in <= '0';
					sig_k <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';
					load_pc <= '0';
			
				WHEN C =>
					sig_k <= '1';
					clear <= '1';
					load_add_in <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';
					load_pc <= '0';
					
				WHEN D => 
					sel <= '1';
					sig_i <= '1';
					load_add_mem <= '0';
					clear <= '1';
					load_add_in <= '0';
					sig_k <= '0';
					load_pc <= '0';
			
				WHEN E => 
					load_pc <= '1';
					clear <= '1';
					load_add_in <= '0';
					sig_k <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';

		
				WHEN OTHERS =>
					clear <= '1';
					load_add_in <= '0';
					sig_k <= '0';
					sig_i <= '0';
					load_add_mem <= '0';
					sel <= '0';
					load_pc <= '0';
					
			END CASE;
		
	END PROCESS;
	
END Behavioral;
