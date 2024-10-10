LIBRARY ieee;
USE ieee.std_Logic_1164.ALL;

ENTITY Unit_D IS
    PORT (
        A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cin : IN STD_LOGIC;
        Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        DATA : OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
END Unit_D;

ARCHITECTURE Unit_D_arch OF Unit_D IS
BEGIN
    DATA(7 DOWNTO 0) <=
    '0' & A(7 DOWNTO 1) WHEN Sel = "00"
ELSE
    A(0) & A(7 DOWNTO 1) WHEN Sel = "01"
ELSE
    Cin & A(7 DOWNTO 1) WHEN Sel = "10"
ELSE
    A(7) & A(7 DOWNTO 1);

    DATA(8) <= A(0);
END Unit_D_arch;