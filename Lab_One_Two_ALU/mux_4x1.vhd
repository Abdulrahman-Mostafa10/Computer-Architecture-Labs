LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_4x1 IS
    PORT (
        In0, In1, In2, In3 : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
        Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        Out1 : OUT STD_LOGIC_VECTOR (8 DOWNTO 0));
END mux_4x1;

ARCHITECTURE mux4 OF mux_4x1 IS
BEGIN
    Out1 <= In0 WHEN Sel = "00"
        ELSE
        In1 WHEN Sel = "01"
        ELSE
        In2 WHEN Sel = "10"
        ELSE
        In3;
END mux4;