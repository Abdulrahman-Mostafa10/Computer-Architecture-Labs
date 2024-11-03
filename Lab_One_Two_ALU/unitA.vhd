LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY unit_A IS
    GENERIC (n : INTEGER := 8);
    PORT (
        A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        Cin : IN STD_LOGIC;
        Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        DATA : OUT STD_LOGIC_VECTOR(n DOWNTO 0));
END unit_A;

ARCHITECTURE unit_A_arch OF unit_A IS
    COMPONENT adder
        GENERIC (n : INTEGER := 8);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Cin : IN STD_LOGIC;
            S : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Cout : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL B_com : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL tmp0 : STD_LOGIC_VECTOR(n DOWNTO 0);
    SIGNAL tmp1 : STD_LOGIC_VECTOR(n DOWNTO 0);
    SIGNAL tmp2 : STD_LOGIC_VECTOR(n DOWNTO 0);
    SIGNAL tmp3 : STD_LOGIC_VECTOR(n DOWNTO 0);
BEGIN
    B_com <= NOT B;

    u0 : adder
    GENERIC MAP(n => n)
    PORT MAP(A, B => (OTHERS => '0'), Cin => Cin, S => tmp0(7 DOWNTO 0), Cout => tmp0(8));

    u1 : adder
    GENERIC MAP(n => n)
    PORT MAP(A, B, Cin => Cin, S => tmp1(7 DOWNTO 0), Cout => tmp1(8));

    u2 : adder
    GENERIC MAP(n => n)
    PORT MAP(A, B_com, Cin => Cin, S => tmp2(7 DOWNTO 0), Cout => tmp2(8));

    u3 : adder
    GENERIC MAP(n => n)
    PORT MAP(A, B => (OTHERS => '1'), Cin => '0', S => tmp3(7 DOWNTO 0), Cout => tmp3(8));

    DATA <=
        tmp0 WHEN Sel = "00"
        ELSE
        tmp1 WHEN Sel = "01"
        ELSE
        tmp2 WHEN Sel = "10"
        ELSE
        tmp3 WHEN Sel = "11" AND Cin = '0'
        ELSE
        '0' & B;

END unit_A_arch;