LIBRARY ieee;
USE ieee.std_Logic_1164.ALL;

ENTITY Unit_C IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Cin : IN STD_LOGIC;
        SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        DATA : OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
    );
END ENTITY Unit_C;

ARCHITECTURE Unit_C_Dataflow OF Unit_C IS
BEGIN
    PROCESS (A, B, Cin, SEL)
    BEGIN

        CASE SEL IS
            WHEN "00" =>
                DATA(8) <= A(7);
                DATA(7 DOWNTO 0) <= A(6 DOWNTO 0) & '0';

            WHEN "01" =>
                DATA(8) <= A(7);
                DATA(7 DOWNTO 0) <= A(6 DOWNTO 0) & '0';
                DATA(0) <= A(7);

            WHEN "10" =>
                DATA(8) <= A(7);
                DATA(7 DOWNTO 0) <= A(6 DOWNTO 0) & '0';
                DATA(0) <= Cin;

            WHEN "11" =>
                DATA <= (OTHERS => '0');

            WHEN OTHERS =>
                DATA <= (OTHERS => 'X');

        END CASE;
    END PROCESS;
END Unit_C_Dataflow;