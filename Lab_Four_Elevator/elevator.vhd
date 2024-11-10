LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY elevator IS
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
END elevator;

ARCHITECTURE Behavioral OF elevator IS

    COMPONENT request_solver IS
        GENERIC (
            NUM_FLOORS : INTEGER := 10; -- Number of floors
            NUM_BITS : INTEGER := 4 -- Number of bits for addressing
        );
        PORT (
            clk : IN STD_LOGIC; -- Clock signal (the FPGA board will provide this signal)
            reset : IN STD_LOGIC;

            is_moving_up : IN STD_LOGIC; -- Direction signal for moving up coming from the FSM
            request : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0); -- Requested floor signal
            current_floor : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0); -- Current floor signal coming from the FSM

            next_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) -- Next floor signal to be sent to the FSM
        );
    END COMPONENT;
    COMPONENT fsm IS
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

    COMPONENT mv_ctrl IS

        PORT (
            clk : IN STD_LOGIC;
            clk_out : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL next_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL is_moving_up_action : STD_LOGIC := '0';
    SIGNAL clk_out : STD_LOGIC;
    SIGNAL current_floor_inside : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN
    request_solver_inst : request_solver
    GENERIC MAP(
        NUM_FLOORS => NUM_FLOORS,
        NUM_BITS => NUM_BITS
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        is_moving_up => is_moving_up_action,
        request => request,
        current_floor => current_floor_inside,
        next_floor => next_floor
    );

    fsm_inst : fsm
    GENERIC MAP(
        NUM_FLOORS => NUM_FLOORS,
        NUM_BITS => NUM_BITS
    )
    PORT MAP(
        reset => reset,
        clk => clk_out,
        requested_next_floor => next_floor,
        reached_floor => current_floor_inside,
        is_moving_up => is_moving_up_action,
        is_moving_down => is_moving_down,
        is_door_open => is_door_open
    );
    timer : mv_ctrl
    PORT MAP(
        clk => clk,
        clk_out => clk_out
    );
    is_moving_up <= is_moving_up_action;
    current_floor <= current_floor_inside;
END Behavioral;