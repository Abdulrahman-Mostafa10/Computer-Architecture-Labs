LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitAdder IS
    PORT (
        A, B, Cin : IN STD_LOGIC;
        S, Cout : OUT STD_LOGIC);
END oneBitAdder;

ARCHITECTURE oneBitAdder_arch OF oneBitAdder IS
BEGIN
    S <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (Cin AND (B XOR A));
END oneBitAdder_arch;