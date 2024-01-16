library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all; 
use work.components_package.all;

entity crypt_unit is
	port (
		CK, RST_n : in  std_logic;
		from_mux : in std_logic_vector(31 downto 0);
		pc_write : in std_logic;
		Vout_data: in std_logic;
		INSTR_OUT : out std_logic_vector(31 downto 0);
		ack: out std_logic;
		seq_out : out std_logic_vector(31 downto 0);
		pc_old : out std_logic_vector(31 downto 0));
	end crypt_unit;



architecture Behavior of crypt_unit is 
---------------------------------------------------------------------
------------------------------ signals ------------------------------
---------------------------------------------------------------------
signal CU_clear, sig_ACK, sig_ACK_K, sig_ACK_I, cu_sel, load_decr, store_k, store_i, load_mem, sig_load_pc, vout_sig : std_logic;
signal to_decr, from_mux_K, add_i, mux0, mux1 : std_logic_vector(31 downto 0);
signal add_k : std_logic_vector (31 downto 0);
signal incr: std_logic_vector(31 downto 0);

---------------------------------------------------------------------
------------------------------ Port Map -----------------------------
---------------------------------------------------------------------
begin 

control_unit: CU port map(CK => CK,
						  RST_n => RST_n,
		   				  ACK => sig_ACK, 
		   				  clear => CU_clear,
		  				  load_add_in => load_decr, 
		   				  sig_k => store_k,
					      sig_i => store_i,
		   				  load_add_mem => load_mem,
		                  sel => cu_sel,
		                  load_pc => sig_load_pc);

vout_sig<= Vout_data  and sig_load_pc;
ack <= vout_sig;


Progr_cnt: PC_crypt	generic map (Nbit => 32)
					port map (Clock =>CK,
						Resetn => CU_clear,
						LOAD_PC => vout_sig,
						R => from_mux,
						PCWrite => pc_write,
						Q => to_decr);

incr <= std_logic_vector(to_unsigned(PC_incr, parallelism));
ADD1: ADD generic map (Nbit => parallelism)
			 port map (A => to_decr, B => incr, SUM => seq_out);

pc_old <= to_decr;

sig_ACK<=  sig_ACK_K and sig_ACK_I;

decr: I_decr port map (Clock =>CK,
					   Resetn =>CU_clear,
					   PC_add => to_decr,
					   mux_out => from_mux_K,
					   SIG_K => store_k,
					   SIG_I => store_i,
					   LOAD_ADD_IN => load_decr, 
					   I_Mem_add => add_i,
					   K_Mem_add => add_k,
					   to_pipe => INSTR_OUT);

keyMem: K_MEM port map (CK => CK,
						RST_n =>CU_clear,
						LOAD_ADD_MEM => load_mem,
						ADDX => add_k,
						ACK => sig_ACK_K,
    					Instr_out => mux0);

instrMem: I_MEM port map (CK => CK,
						  RST_n => CU_clear,
						  LOAD_ADD_MEM => load_mem,
						  ADDX => add_i,
						  ACK => sig_ACK_I,
    					  Instr_out => mux1);

mux: mux2_to_1 generic map( Nbit => 32)
			   port map (SEL => cu_sel,
        				 A => mux0,
        				 B => mux1,
        				 OUTPUT => from_mux_K);



end Behavior; 
