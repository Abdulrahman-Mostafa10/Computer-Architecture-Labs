LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Unit_B IS
    GENERIC (n : INTEGER := 8);
    PORT (
        A, B : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        DATA : OUT STD_LOGIC_VECTOR (n DOWNTO 0)
    );
END ENTITY Unit_B;

ARCHITECTURE Unit_B_Dataflow OF Unit_B IS
BEGIN
    DATA(n - 1 DOWNTO 0) <= (A XOR B) WHEN Sel(0) = '0' AND Sel(1) = '0'
ELSE
    (A NAND B) WHEN Sel(1) = '0' AND Sel(0) = '1'
ELSE
    (A OR B) WHEN Sel(1) = '1' AND Sel(0) = '0'
ELSE
    (NOT A) WHEN Sel(1) = '1' AND Sel(0) = '1'
ELSE
    (OTHERS => 'X');

    DATA(n) <= '0';

END Unit_B_Dataflow;