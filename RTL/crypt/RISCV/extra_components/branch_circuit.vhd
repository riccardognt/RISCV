LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
use work.constants.all;

entity branch_circuit is
    port (
		BEQ, BNQ, BGE, BLT : in STD_LOGIC;
		ALU_OUT_SIGN, ALU_OUT_ZERO : in STD_LOGIC;
		BRANCH : out STD_LOGIC
        );
end branch_circuit;

architecture Behavioral of branch_circuit is
	signal BEQ_S, BNQ_S, BGE_S, BLT_S : STD_LOGIC :='0';
begin			
	BEQ_S <= BEQ and ALU_OUT_ZERO;
	BNQ_S <= BNQ and not(ALU_OUT_ZERO);
	BGE_S <= BGE and not(ALU_OUT_SIGN);
	BLT_S <= BLT and (ALU_OUT_SIGN);
	BRANCH <= BEQ_S or BNQ_S or BGE_S or BLT_S;
end Behavioral;
