LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cin : IN STD_LOGIC;
        Sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        F : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cout : OUT STD_LOGIC);
END alu;

ARCHITECTURE alu1 OF alu IS
    COMPONENT Unit_B
        PORT (
            A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            SEL : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            DATA : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Unit_C
        PORT (
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Cin : IN STD_LOGIC;
            SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            DATA : OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Unit_D
        PORT (
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Cin : IN STD_LOGIC;
            Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            F : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux_4x1
        PORT (
            In0, In1, In2, In3 : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
            Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Out1 : OUT STD_LOGIC_VECTOR (8 DOWNTO 0));
    END COMPONENT;

    SIGNAL DATA_B, DATA_C, DATA_D, MUX_F : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN

    ub : Unit_B PORT MAP(A, B, Sel(1 DOWNTO 0), DATA_B);
    uc : Unit_C PORT MAP(A, Cin, Sel(1 DOWNTO 0), DATA_C);
    ud : Unit_D PORT MAP(A, Cin, Sel(1 DOWNTO 0), DATA_D);

    mux : mux_4x1 PORT MAP(DATA_B, DATA_B, DATA_C, DATA_D, Sel(3 DOWNTO 2), MUX_F);
    F <= MUX_F(7 DOWNTO 0);
    Cout <= MUX_F(8);
END alu1;