LIBRARY ieee;
USE ieee.std_Logic_1164.ALL;

ENTITY PartD IS
    PORT (
        A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cin : IN STD_LOGIC;
        Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        F : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cout : OUT STD_LOGIC;
    );
END PartD;

ARCHITECTURE part_d OF PartD IS
BEGIN
    F <=
        '0' & A(7 DOWNTO 1) WHEN Sel = "00"
        ELSE
        A(0) & A(7 DOWNTO 1) WHEN Sel = "01"
        ELSE
        Cin & A(7 DOWNTO 1) WHEN Sel = "10"
        ELSE
        A(7) & A(7 DOWNTO 1);

    Cout <= A(0);
END part_d;