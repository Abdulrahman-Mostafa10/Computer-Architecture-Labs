LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SSD IS
    PORT (
        BCD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        segments : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END SSD;

ARCHITECTURE Behavioral OF SSD IS
BEGIN
    PROCESS (BCD)
    BEGIN
        CASE BCD IS
            WHEN "0000" => segments <= "1111110";
            WHEN "0001" => segments <= "0110000";
            WHEN "0010" => segments <= "1101101";
            WHEN "0011" => segments <= "1111001";
            WHEN "0100" => segments <= "0110011";
            WHEN "0101" => segments <= "1011011";
            WHEN "0110" => segments <= "1011111";
            WHEN "0111" => segments <= "1110000";
            WHEN "1000" => segments <= "1111111";
            WHEN "1001" => segments <= "1111011";
            WHEN OTHERS => segments <= "0000000";
        END CASE;
    END PROCESS;
END Behavioral;