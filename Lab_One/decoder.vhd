LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Decoder IS
    PORT (
        A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY Decoder;

ARCHITECTURE Decoder_DatafLow OF decoder IS
BEGIN
    PROCESS (A)
    BEGIN
        Y <= "0000";

        CASE A IS
            WHEN "00" =>
                Y(0) <= '1';
            WHEN "01" =>
                Y(1) <= '1';
            WHEN "10" =>
                Y(2) <= '1';
            WHEN "11" =>
                Y(3) <= '1';
            WHEN OTHERS =>
                Y <= "0000";
        END CASE;
    END PROCESS;
END ARCHITECTURE Decoder_DatafLow;