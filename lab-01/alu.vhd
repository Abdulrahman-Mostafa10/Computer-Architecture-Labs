LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Cin : IN STD_LOGIC
        F : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cout : OUT STD_LOGIC);
END alu;

ARCHITECTURE alu1 OF alu IS
    -- COMPONENT PartB
    --     PORT ()
    -- END COMPONENT;
    -- COMPONENT PartC
    --     PORT ()
    -- END COMPONENT;
    COMPONENT PartD
        PORT (
            A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Cin : IN STD_LOGIC;
            Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            F : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            Cout : OUT STD_LOGIC;
        );
    END COMPONENT;
    COMPONENT mux_4x1
        PORT (
            In0, In1, In2, In3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Out1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
    END COMPONENT;

    -- SIGNAL F_B : STD_LOGIC_VECTOR(7 DOWNTO 0);
    -- SIGNAL Cout_B : STD_LOGIC;

    -- SIGNAL F_C : STD_LOGIC_VECTOR(7 DOWNTO 0);
    -- SIGNAL Cout_C : STD_LOGIC;

    SIGNAL F_D : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Cout_D : STD_LOGIC;

BEGIN
    -- PartB : PartB PORT MAP (A, B, Sel, F);
    -- PartC : PartC PORT MAP (A, Sel, F);
    PartD : PartD PORT MAP(A, Cin, Sel, F_D, Cout_D);
    mux : mux_4x1 PORT MAP(F_B, F_B, F_C, F_D, Sel(3 DOWNTO 2), F); -- the 1st F_B will be replaced with the F_A in next lab
    Cout <= Cout_B WHEN Sel = "00" -- to be replaced with the Cout_A in next lab
        ELSE
        Cout_B WHEN Sel = "01"
        ELSE
        Cout_C WHEN Sel = "10"
        ELSE
        Cout_D;
END alu1;