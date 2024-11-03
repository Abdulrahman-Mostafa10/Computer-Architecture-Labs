LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
    GENERIC (n : INTEGER := 8);
    PORT (
        A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cin : IN STD_LOGIC;
        Sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        F : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cout : OUT STD_LOGIC);
END alu;

ARCHITECTURE alu1 OF alu IS
    COMPONENT Unit_A
        GENERIC (n : INTEGER := 8);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Cin : IN STD_LOGIC;
            Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            DATA : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT Unit_B
        GENERIC (n : INTEGER := 8);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            DATA : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Unit_C
        GENERIC (n : INTEGER := 8);
        PORT (
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Cin : IN STD_LOGIC;
            Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            DATA : OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Unit_D
        GENERIC (n : INTEGER := 8);
        PORT (
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Cin : IN STD_LOGIC;
            Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Data : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux_4x1
        PORT (
            In0, In1, In2, In3 : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
            Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Out1 : OUT STD_LOGIC_VECTOR (8 DOWNTO 0));
    END COMPONENT;

    SIGNAL DATA_A, DATA_B, DATA_C, DATA_D, MUX_F : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN

    ua : Unit_A PORT MAP(A => A, B => B, Cin => Cin, Sel => Sel(1 DOWNTO 0), DATA => DATA_A);
    ub : Unit_B PORT MAP(A => A, B => B, Sel => Sel(1 DOWNTO 0), Data => DATA_B);
    uc : Unit_C PORT MAP(A => A, Cin => Cin, Sel => Sel(1 DOWNTO 0), DATA => DATA_C);
    ud : Unit_D PORT MAP(A => A, Cin => Cin, Sel => Sel(1 DOWNTO 0), DATA => DATA_D);

    mux : mux_4x1 PORT MAP(In0 => DATA_A, In1 => DATA_B, In2 => DATA_C, In3 => DATA_D, Sel => Sel(3 DOWNTO 2), Out1 => MUX_F);
    F <= MUX_F(7 DOWNTO 0);
    Cout <= MUX_F(8);
END alu1;