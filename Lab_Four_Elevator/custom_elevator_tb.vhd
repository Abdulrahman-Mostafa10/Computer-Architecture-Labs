LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY custom_elevator_tb IS
END custom_elevator_tb;

ARCHITECTURE Behavioral OF custom_elevator_tb IS

    -- Clock period for 50 MHz frequency
    CONSTANT clk_period : TIME := 20 ns;
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL request : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

    SIGNAL seven_segment_display : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL is_moving_up : STD_LOGIC;
    SIGNAL is_moving_down : STD_LOGIC;
    SIGNAL is_door_open : STD_LOGIC;

    COMPONENT custom_elevator
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            request : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            seven_segment_display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            is_moving_up : OUT STD_LOGIC;
            is_moving_down : OUT STD_LOGIC;
            is_door_open : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN

    uut : custom_elevator
    PORT MAP(
        clk => clk,
        reset => reset,
        request => request,
        seven_segment_display => seven_segment_display,
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
        -- Reset the system
        reset <= '1';
        WAIT FOR 200 ms;
        reset <= '0';

        -- Scenario 1: Request floor 7
        request <= "0111";
        WAIT FOR 2000 ns;

        -- Scenario 2: Request floor 5 (should be the next floor to go to then the elevator will go to floor 7)
        request <= "0101";
        WAIT FOR 20000 ms;

        -- Scenario 3: Request floor 0
        request <= "0000";
        WAIT FOR 2000 ns;

        -- Scenario 4: Request floor 3 (should be the next floor to go to then the elevator will go to floor 0)
        request <= "0011";
        WAIT FOR 20000 ns;

        WAIT;
    END PROCESS;

END Behavioral;