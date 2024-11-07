LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY elevator_tb IS
END elevator_tb;

ARCHITECTURE Behavioral OF elevator_tb IS

    -- Constants for the test
    CONSTANT NUM_FLOORS : INTEGER := 10;
    CONSTANT NUM_BITS : INTEGER := 4;

    -- Component under test
    COMPONENT elevator
        GENERIC (
            NUM_FLOORS : INTEGER := NUM_FLOORS;
            NUM_BITS : INTEGER := NUM_BITS
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

    -- Signals for input/output ports of the elevator
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL request : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');

    SIGNAL current_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
    SIGNAL is_moving_up : STD_LOGIC;
    SIGNAL is_moving_down : STD_LOGIC;
    SIGNAL is_door_open : STD_LOGIC;

    -- Clock generation process
    CONSTANT clk_period : TIME := 20 ns;

BEGIN

    -- Instantiate the elevator
    uut : elevator
    GENERIC MAP(
        NUM_FLOORS => NUM_FLOORS,
        NUM_BITS => NUM_BITS
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        request => request,
        current_floor => current_floor,
        is_moving_up => is_moving_up,
        is_moving_down => is_moving_down,
        is_door_open => is_door_open
    );

    -- Clock generation
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Test procedure
    test_process : PROCESS
    BEGIN
        -- Initialize signals
        WAIT FOR clk_period * 2;

        reset <= '1';
        WAIT FOR clk_period * 2;
        reset <= '0';

        -- Test case 1: Request on the 5th floor
        request <= STD_LOGIC_VECTOR(to_unsigned(5, NUM_BITS));
        WAIT FOR clk_period * 10; -- Wait to observe behavior

        -- Test case 2: Request on the 2nd floor
        request <= STD_LOGIC_VECTOR(to_unsigned(2, NUM_BITS));
        WAIT FOR clk_period * 10;

        -- Test case 3: Reset the system
        reset <= '1';
        WAIT FOR clk_period * 2;
        reset <= '0';

        -- Test case 4: Request on the top floor
        request <= STD_LOGIC_VECTOR(to_unsigned(NUM_FLOORS - 1, NUM_BITS));
        WAIT FOR clk_period * 10;

        -- End of test
        WAIT;
    END PROCESS;

END Behavioral;