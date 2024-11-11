LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fsm_tb IS
    -- Testbench does not have any ports
END fsm_tb;

ARCHITECTURE behavior OF fsm_tb IS

    -- Constants
    CONSTANT clk_period : TIME := 20 ns;
    CONSTANT NUM_FLOORS : INTEGER := 10;
    CONSTANT NUM_BITS : INTEGER := 4;

    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL requested_next_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reached_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
    SIGNAL is_moving_up : STD_LOGIC;
    SIGNAL is_moving_down : STD_LOGIC;
    SIGNAL is_door_open : STD_LOGIC;

    COMPONENT fsm
        GENERIC (
            NUM_FLOORS : INTEGER := 10;
            NUM_BITS : INTEGER := 4
        );
        PORT (
            reset : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            requested_next_floor : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);

            reached_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0); -- will be displayed on the seven-segment display
            is_moving_up : OUT STD_LOGIC;
            is_moving_down : OUT STD_LOGIC;
            is_door_open : OUT STD_LOGIC
        );
    END COMPONENT;
BEGIN

    uut : fsm
    GENERIC MAP(
        NUM_FLOORS => NUM_FLOORS,
        NUM_BITS => NUM_BITS
    )
    PORT MAP(
        reset => reset,
        clk => clk,
        requested_next_floor => requested_next_floor,
        reached_floor => reached_floor,
        is_moving_up => is_moving_up,
        is_moving_down => is_moving_down,
        is_door_open => is_door_open
    );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    stimulus_process : PROCESS
    BEGIN
        -- Reset the FSM
        reset <= '1';
        WAIT FOR 50 ns;
        reset <= '0';
        WAIT FOR 50 ns;

        -- Scenario 1: Move from floor 0 to floor 5
        requested_next_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, NUM_BITS));
        WAIT FOR 300 ns; -- Allow time for the elevator to reach the floor

        -- Scenario 2: Move down from floor 5 to floor 2
        requested_next_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, NUM_BITS));
        WAIT FOR 300 ns; -- Allow time for the elevator to reach the floor

        -- Scenario 3: Move up to top floor (floor 9)
        requested_next_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(9, NUM_BITS));
        WAIT FOR 300 ns; -- Allow time for the elevator to reach the floor

        -- Scenario 4: Move down to floor 0
        requested_next_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, NUM_BITS));
        WAIT FOR 300 ns; -- Allow time for the elevator to reach the floor

        WAIT;
    END PROCESS;

END behavior;