LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY memory IS
    PORT (
        we : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        w_addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_addr0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        r_addr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        read_data0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        read_data1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END memory;

ARCHITECTURE Behavioral OF memory IS
    TYPE memory_array IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL mem : memory_array;
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            mem <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN
            IF we = '1' THEN
                mem(to_integer(unsigned(w_addr))) <= write_data;
            END IF;
        END IF;
    END PROCESS;
    read_data0 <= mem(to_integer(unsigned(r_addr0)));
    read_data1 <= mem(to_integer(unsigned(r_addr1)));
END Behavioral;