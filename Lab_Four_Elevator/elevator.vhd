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
            NUM_FLOORS : INTEGER := 10;
            NUM_BITS : INTEGER := 4
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            direction : IN STD_LOGIC;
            request : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
            current_floor : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);

            next_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT fsm IS
        GENERIC (
            NUM_FLOORS : INTEGER := 10;
            NUM_BITS : INTEGER := 4
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            requested_next_floor : IN STD_LOGIC_VECTOR (NUM_BITS - 1 DOWNTO 0);

            reached_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
            direction_action : OUT STD_LOGIC;
            is_door_open : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL next_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL direction_action : STD_LOGIC := '0';
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
        direction => direction_action,
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
        clk => clk,
        requested_next_floor => next_floor,
        reached_floor => current_floor_inside,
        direction_action => direction_action,
        is_door_open => is_door_open
    );
    is_moving_up <= direction_action AND '1';
    is_moving_down <= direction_action XOR '1';
    current_floor <= current_floor_inside;
END Behavioral;