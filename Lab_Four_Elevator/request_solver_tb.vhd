LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY request_solver_tb IS
END request_solver_tb;

ARCHITECTURE behavior OF request_solver_tb IS

    -- Clock period
    CONSTANT clk_period : TIME := 10 ns;
    CONSTANT NUM_FLOORS : INTEGER := 10;
    CONSTANT NUM_BITS : INTEGER := 4;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL is_moving_up : STD_LOGIC := '1';
    SIGNAL request : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL current_floor : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

    SIGNAL next_floor : STD_LOGIC_VECTOR(3 DOWNTO 0);

    COMPONENT request_solver
        GENERIC (
            NUM_FLOORS : INTEGER := 10;
            NUM_BITS : INTEGER := 4
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            is_moving_up : IN STD_LOGIC;
            request : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
            current_floor : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);

            next_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0)
        );
    END COMPONENT;
BEGIN

    uut : request_solver
    GENERIC MAP(
        NUM_FLOORS => NUM_FLOORS,
        NUM_BITS => NUM_BITS
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        is_moving_up => is_moving_up,
        request => request,
        current_floor => current_floor,
        next_floor => next_floor
    );

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
        WAIT FOR 20 ns;
        reset <= '0';

        -- Scenario 1: Request floor 5 from floor 0, moving up
        current_floor <= "0000"; -- Starting at floor 0
        request <= "0101"; -- Request for floor 5
        WAIT FOR 120 ns;

        -- Scenario 2: Request floor 8, elevator should continue moving up
        request <= "1000"; -- Request for floor 8
        WAIT FOR 100 ns;

        -- Scenario 3: Change to moving down and request lower floor
        is_moving_up <= '0'; -- Change direction to down
        current_floor <= "1000"; -- Assume elevator is at floor 8
        request <= "0011"; -- Request for floor 3
        WAIT FOR 120 ns;

        -- Scenario 4: Request floor 1 from floor 3, moving down
        current_floor <= "0011"; -- Current floor is now 3
        request <= "0001"; -- Request for floor 1
        WAIT FOR 100 ns;

        -- Scenario 5: Request floor 7, moving up again
        is_moving_up <= '1'; -- Change direction back to up
        request <= "0111"; -- Request for floor 7
        WAIT FOR 150 ns;

        WAIT;
    END PROCESS;

END behavior;