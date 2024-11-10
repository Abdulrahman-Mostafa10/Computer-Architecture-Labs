LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fsm IS
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
END fsm;

ARCHITECTURE Behavioral OF fsm IS
    TYPE fsm_state_type IS (up, down, opened, closed);
    SIGNAL state_reg, state_next : fsm_state_type;

    SIGNAL clk_counter : INTEGER RANGE 0 TO 1 := 0;

    SIGNAL current_floor_dff_internal_signal : INTEGER RANGE 0 TO NUM_FLOORS - 1 := 0;
    SIGNAL current_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');

    SIGNAL next_floor_evaluate_internal_signal : INTEGER RANGE 0 TO NUM_FLOORS - 1 := 0;

    SIGNAL is_moving_up_evaluate_internal_signal : STD_LOGIC := '0'; -- Next signal for is_moving_up

    SIGNAL is_moving_down_evaluate_internal_signal : STD_LOGIC := '0'; -- Next signal for is_moving_down

    SIGNAL is_door_open_evaluate_internal_signal : STD_LOGIC := '0';

BEGIN
    -- Flip-flop to store current state, floor, and direction signals
    dff : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            is_moving_up <= '0';
            is_moving_down <= '0';
            is_door_open <= '0';
            state_reg <= closed;
            current_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(current_floor_dff_internal_signal, NUM_BITS));
            reached_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(current_floor_dff_internal_signal, NUM_BITS));

        ELSIF (rising_edge(clk)) THEN
            IF (clk_counter = 1) THEN
                clk_counter <= 0;
                state_reg <= state_next;

                current_floor_dff_internal_signal <= next_floor_evaluate_internal_signal;
                current_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(next_floor_evaluate_internal_signal, NUM_BITS));
                reached_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(next_floor_evaluate_internal_signal, NUM_BITS));

                is_moving_up <= is_moving_up_evaluate_internal_signal;
                is_moving_down <= is_moving_down_evaluate_internal_signal;
                is_door_open <= is_door_open_evaluate_internal_signal;
            ELSE
                clk_counter <= 1;
            END IF;

        END IF;
    END PROCESS;

    -- State evaluation and control logic
    evaluate_state : PROCESS (state_reg, requested_next_floor, current_floor_dff_internal_signal, reset)
    BEGIN
        -- Default outputs for each state
        IF (reset = '1') THEN
            state_next <= closed;
            next_floor_evaluate_internal_signal <= current_floor_dff_internal_signal;
            is_moving_up_evaluate_internal_signal <= '0';
            is_moving_down_evaluate_internal_signal <= '0';
            is_door_open_evaluate_internal_signal <= '0';

        ELSE
            state_next <= state_reg;

            CASE state_reg IS
                WHEN closed =>
                    IF (TO_INTEGER(unsigned(requested_next_floor)) > current_floor_dff_internal_signal) THEN
                        is_moving_up_evaluate_internal_signal <= '1'; -- Enable Moving up
                        is_moving_down_evaluate_internal_signal <= '0'; -- Disable Moving down
                        state_next <= up;
                    ELSIF (TO_INTEGER(unsigned(requested_next_floor)) < current_floor_dff_internal_signal) THEN
                        is_moving_up_evaluate_internal_signal <= '0'; -- Disable Moving up
                        is_moving_down_evaluate_internal_signal <= '1'; -- Enable Moving down
                        state_next <= down;
                    END IF;

                WHEN up =>
                    IF (TO_INTEGER(unsigned(requested_next_floor)) = current_floor_dff_internal_signal) THEN
                        state_next <= opened; -- Arrived at requested floor
                        is_moving_up_evaluate_internal_signal <= '0'; -- Stop moving up
                        is_door_open_evaluate_internal_signal <= '1'; -- Open the door
                        next_floor_evaluate_internal_signal <= current_floor_dff_internal_signal; -- Increment floor
                    ELSE
                        is_moving_up_evaluate_internal_signal <= '1'; -- Continue Moving up
                        next_floor_evaluate_internal_signal <= current_floor_dff_internal_signal + 1; -- Increment floor
                    END IF;

                WHEN down =>
                    IF (TO_INTEGER(unsigned(requested_next_floor)) = current_floor_dff_internal_signal) THEN
                        state_next <= opened; -- Arrived at requested floor
                        is_moving_down_evaluate_internal_signal <= '0'; -- Stop moving down
                        is_door_open_evaluate_internal_signal <= '1'; -- Open the door
                        next_floor_evaluate_internal_signal <= current_floor_dff_internal_signal;
                    ELSE
                        is_moving_down_evaluate_internal_signal <= '1'; -- Continue Moving down
                        next_floor_evaluate_internal_signal <= current_floor_dff_internal_signal - 1; -- Decrement floor
                    END IF;

                WHEN opened =>
                    state_next <= closed; -- After opening, close the door
                    is_door_open_evaluate_internal_signal <= '0'; -- Close the door

                WHEN OTHERS =>
                    state_next <= closed; -- Default case to avoid latch-up
                    is_moving_up_evaluate_internal_signal <= '0';
                    is_moving_down_evaluate_internal_signal <= '0';
                    is_door_open_evaluate_internal_signal <= '0';
            END CASE;
        END IF;

    END PROCESS;
END Behavioral;