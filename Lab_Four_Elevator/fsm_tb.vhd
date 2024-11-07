LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fsm_tb IS
END fsm_tb;

ARCHITECTURE Behavioral OF fsm_tb IS

    CONSTANT NUM_FLOORS : INTEGER := 10;
    CONSTANT NUM_BITS : INTEGER := 4;
    CONSTANT clk_period : TIME := 1000000000 ns; -- Clock period of 1 second (1 Hz)

    COMPONENT fsm
        GENERIC (
            NUM_FLOORS : INTEGER := NUM_FLOORS;
            NUM_BITS : INTEGER := NUM_BITS
        );
        PORT (
            reset : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            requested_next_floor : IN STD_LOGIC_VECTOR (NUM_BITS - 1 DOWNTO 0);

            reached_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
            direction_action : OUT STD_LOGIC;
            is_door_open : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0'; -- Clock signal for FSM
    SIGNAL reset : STD_LOGIC := '1'; -- Reset signal, set initially to 1
    SIGNAL requested_next_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0'); -- Requested floor signal
    SIGNAL reached_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
    SIGNAL direction_action : STD_LOGIC;
    SIGNAL is_door_open : STD_LOGIC;

BEGIN
    -- Instantiate the FSM (Under Test)
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
        direction_action => direction_action,
        is_door_open => is_door_open
    );

    -- Clock generation process (1 Hz clock, period = 1 second)
    clk_process : PROCESS
    BEGIN
        -- Toggle the clock every 1 second (1000000000 ns)
        WAIT FOR clk_period / 2;
        clk <= NOT clk;
    END PROCESS;

    -- Test process
    fsm_process : PROCESS
    BEGIN
        -- Apply reset at the beginning
        reset <= '1'; -- Assert reset signal
        WAIT FOR clk_period * 2; -- Wait for a few clock cycles to apply reset

        -- Deassert reset signal to start normal operation
        reset <= '0';
        WAIT FOR clk_period * 2;

        -- End of test
        WAIT;
    END PROCESS;

END Behavioral;