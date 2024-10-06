LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Unit_B IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        Cin : IN STD_LOGIC;
        SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        DATA : OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
    );
END ENTITY Unit_B;

ARCHITECTURE Unit_B_Dataflow OF Unit_B IS
BEGIN
    DATA(7 DOWNTO 0) <= (A XOR B) WHEN SEL(0) = '0' AND SEL(1) = '0'
ELSE
    (A NAND B) WHEN SEL(1) = '0' AND SEL(0) = '1'
ELSE
    (A OR B) WHEN SEL(1) = '1' AND SEL(0) = '0'
ELSE
    (NOT A) WHEN SEL(1) = '1' AND SEL(0) = '1'
ELSE
    (OTHERS => 'X');

    DATA(8) <= '0';

END Unit_B_Dataflow;