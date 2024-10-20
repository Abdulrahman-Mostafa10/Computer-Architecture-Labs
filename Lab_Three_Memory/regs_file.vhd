LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY regs_file IS
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
END regs_file;

ARCHITECTURE Regs_File_Behavioral OF regs_file IS
    TYPE regs_file_type IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL unit_regs_file : regs_file_type;
BEGIN

    PROCESS (clk, reset) IS
    BEGIN
        IF (reset = '1') THEN
            unit_regs_file <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN
            IF (we = '1') THEN
                unit_regs_file(to_integer(unsigned(w_addr))) <= write_data;
            END IF;
        END IF;
    END PROCESS;
    read_data0 <= unit_regs_file(to_integer(unsigned(r_addr0)));
    read_data1 <= unit_regs_file(to_integer(unsigned(r_addr1)));
END Regs_File_Behavioral;