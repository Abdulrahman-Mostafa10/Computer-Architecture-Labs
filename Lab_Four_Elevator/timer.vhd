LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY mv_ctrl IS

    PORT (
        clk : IN STD_LOGIC;
        clk_out : OUT STD_LOGIC
    );
END mv_ctrl;

ARCHITECTURE Behavioral OF mv_ctrl IS
    CONSTANT half_cycle : INTEGER := 25_000_000; -- 50 MHz / 2 = 25 MHz
    SIGNAL cnt : INTEGER RANGE 0 TO half_cycle - 1 := 0;
    SIGNAL clk_out_reg : STD_LOGIC := '0';
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF cnt = half_cycle - 1 THEN
                cnt <= 0;
                clk_out_reg <= NOT clk_out_reg;
            ELSE
                cnt <= cnt + 1;
            END IF;
        END IF;
    END PROCESS;

    clk_out <= clk_out_reg;

END Behavioral;