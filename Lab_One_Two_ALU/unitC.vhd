LIBRARY ieee;
USE ieee.std_Logic_1164.ALL;

ENTITY Unit_C IS
    GENERIC (n : INTEGER := 8);
    PORT (
        A : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        Cin : IN STD_LOGIC;
        Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        DATA : OUT STD_LOGIC_VECTOR (n DOWNTO 0)
    );
END ENTITY Unit_C;

ARCHITECTURE Unit_C_Dataflow OF Unit_C IS
BEGIN
    PROCESS (A, Cin, Sel)
    BEGIN

        CASE Sel IS
            WHEN "00" =>
                DATA(n) <= A(n - 1);
                DATA(n - 1 DOWNTO 0) <= A(n - 2 DOWNTO 0) & '0';

            WHEN "01" =>
                DATA(n) <= A(n - 1);
                DATA(n - 1 DOWNTO 0) <= A(n - 2 DOWNTO 0) & '0';
                DATA(0) <= A(n - 1);

            WHEN "10" =>
                DATA(n) <= A(n - 1);
                DATA(n - 1 DOWNTO 0) <= A(n - 2 DOWNTO 0) & '0';
                DATA(0) <= Cin;

            WHEN "11" =>
                DATA <= (OTHERS => '0');

            WHEN OTHERS =>
                DATA <= (OTHERS => 'X');

        END CASE;
    END PROCESS;
END Unit_C_Dataflow;