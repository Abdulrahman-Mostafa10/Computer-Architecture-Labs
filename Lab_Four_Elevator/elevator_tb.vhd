LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY elevator_tb IS
END elevator_tb;

ARCHITECTURE Behavioral OF elevator_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT elevator
        GENERIC (
            NUM_FLOORS : INTEGER := 10;
            NUM_BITS : INTEGER := 4
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            request : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);

            current_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
            is_moving_up : OUT STD_LOGIC;
            is_moving_down : OUT STD_LOGIC;
            is_door_open : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Testbench Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL request : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL current_floor : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL is_moving_up : STD_LOGIC;
    SIGNAL is_moving_down : STD_LOGIC;
    SIGNAL is_door_open : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : TIME := 100 ps;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : elevator
    PORT MAP(
        clk => clk,
        reset => reset,
        request => request,

        current_floor => current_floor,
        is_moving_up => is_moving_up,
        is_moving_down => is_moving_down,
        is_door_open => is_door_open
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Reset system
        reset <= '1';
        WAIT FOR clk_period * 2;
        reset <= '0';
        WAIT FOR clk_period * 2;

        -- Apply initial request (no floor selected)
        request <= "0000";
        WAIT FOR clk_period * 10;

        -- Request floor 2
        request <= "0010";
        WAIT FOR clk_period * 20;

        -- Request floor 1
        request <= "0001";
        WAIT FOR clk_period * 20;

        -- Request floor 3
        request <= "0011";
        WAIT FOR clk_period * 20;

        -- Simulate multiple floors requested in succession
        request <= "0100";
        WAIT FOR clk_period * 30;
        WAIT;
    END PROCESS;

END Behavioral;