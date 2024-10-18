LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY adder IS
    GENERIC (n : INTEGER := 8);
    PORT (
        A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        Cin : IN STD_LOGIC;
        S : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        Cout : OUT STD_LOGIC);
END adder;

ARCHITECTURE adder1 OF adder IS
    COMPONENT oneBitAdder
        PORT (
            A, B, Cin : IN STD_LOGIC;
            S, Cout : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL tmp : STD_LOGIC_VECTOR(n DOWNTO 0);
BEGIN
    tmp(0) <= Cin;
    lp : FOR i IN 0 TO n - 1 GENERATE
        ux : oneBitAdder
        PORT MAP(
            A => A(i),
            B => B(i),
            Cin => tmp(i),
            S => S(i),
            Cout => tmp(i + 1));
    END GENERATE;
    Cout <= tmp(n);
END ARCHITECTURE adder1;