library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hazard_detection_unit is
    Port (InFID_rs1 : in std_logic_vector(4 downto 0);
    InFID_rs2 : in std_logic_vector(4 downto 0);
    IDEX_rd : in std_logic_vector(4 downto 0);
    IDEX_memread : in std_logic;
    branch_CU:in std_logic;  ----hazrd control dei branch
    EXMEM_rd : in std_logic_vector(4 downto 0); ----hazrd control dei branch
 
    PCWrite : out std_logic;
    InFIDWrite : out std_logic;
    Control_mux : out std_logic);
end hazard_detection_unit;

architecture beh of hazard_detection_unit is

begin
    process (InFID_rs1, InFID_rs2, IDEX_rd, IDEX_memread, branch_CU, EXMEM_rd)
    begin
        if ((IDEX_memread = '1' and ((IDEX_rd = InFID_rs1) or (IDEX_rd = InFID_rs2))) or (branch_CU='1' and ((IDEX_rd = InFID_rs1) or (IDEX_rd = InFID_rs2) or (EXMEM_rd = InFID_rs1) or (EXMEM_rd = InFID_rs2)))) then
            Control_mux <= '1';
            PCWrite <= '1';
            InFIDWrite <= '1';
        else
            Control_mux <= '0';
            PCWrite <= '0';
            InFIDWrite <= '0';
        end if;
    end process;
end architecture;
