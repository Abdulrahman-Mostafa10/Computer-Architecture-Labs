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

        reached_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
        direction_action : OUT STD_LOGIC;
        is_door_open : OUT STD_LOGIC
    );
END fsm;

ARCHITECTURE Behavioral OF fsm IS
    TYPE fsm_state_type IS (up, down, opened, closed);
    SIGNAL clk_counter : INTEGER RANGE 0 TO 1 := 0;
    SIGNAL current_floor_dff_internal_signal : INTEGER RANGE 0 TO NUM_FLOORS - 1 := 0;
    SIGNAL next_floor_evaluate_internal_signal : INTEGER RANGE 0 TO NUM_FLOORS - 1 := 0;
    SIGNAL is_door_open_dff_internal_signal : STD_LOGIC := '0';
    SIGNAL is_door_open_evaluate_internal_signal : STD_LOGIC := '0';
    SIGNAL direction_action_dff_internal_signal : STD_LOGIC := '0';
    SIGNAL direction_action_evaluate_internal_signal : STD_LOGIC := '0'; -- Next signal for direction_action
    SIGNAL current_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL state_reg, state_next : fsm_state_type;
BEGIN
    -- Flip-flop to store current state, floor, and direction signals
    dff : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            current_floor_dff_internal_signal <= 0;
            current_floor <= (OTHERS => '0');
            reached_floor <= (OTHERS => '0');
            direction_action <= '0';
            is_door_open <= '0';
            clk_counter <= 0;
            state_reg <= closed;
        ELSIF (rising_edge(clk)) THEN
            IF (clk_counter = 1) THEN
                clk_counter <= 0;
                state_reg <= state_next;

                current_floor_dff_internal_signal <= next_floor_evaluate_internal_signal;
                direction_action_dff_internal_signal <= direction_action_evaluate_internal_signal; -- Update the temporary direction_action
                is_door_open_dff_internal_signal <= is_door_open_evaluate_internal_signal;

                current_floor <= STD_LOGIC_VECTOR(TO_UNSIGNED(current_floor_dff_internal_signal, NUM_BITS));
                reached_floor <= current_floor;
            ELSE
                clk_counter <= 1;
            END IF;
            is_door_open <= is_door_open_evaluate_internal_signal;
            direction_action <= direction_action_evaluate_internal_signal;
        END IF;
    END PROCESS;

    -- State evaluation and control logic
    evaluate_state : PROCESS (state_reg, requested_next_floor, current_floor_dff_internal_signal)
    BEGIN
        -- Default outputs for each state
        state_next <= state_reg;
        next_floor_evaluate_internal_signal <= current_floor_dff_internal_signal;
        direction_action_evaluate_internal_signal <= direction_action_dff_internal_signal;
        is_door_open_evaluate_internal_signal <= is_door_open_dff_internal_signal;

        CASE state_reg IS
            WHEN closed =>
                is_door_open_evaluate_internal_signal <= '0';
                IF (TO_INTEGER(unsigned(requested_next_floor)) > current_floor_dff_internal_signal) THEN
                    direction_action_evaluate_internal_signal <= '1'; -- Moving up
                    state_next <= up;
                ELSIF (TO_INTEGER(unsigned(requested_next_floor)) < current_floor_dff_internal_signal) THEN
                    direction_action_evaluate_internal_signal <= '0'; -- Moving down
                    state_next <= down;
                END IF;

            WHEN up =>
                IF (TO_INTEGER(unsigned(requested_next_floor)) = current_floor_dff_internal_signal) THEN
                    state_next <= opened; -- Arrived at requested floor
                ELSE
                    direction_action_evaluate_internal_signal <= '1'; -- Continue moving up
                    next_floor_evaluate_internal_signal <= current_floor_dff_internal_signal + 1; -- Increment floor
                END IF;

            WHEN down =>
                IF (TO_INTEGER(unsigned(requested_next_floor)) = current_floor_dff_internal_signal) THEN
                    state_next <= opened; -- Arrived at requested floor
                ELSE
                    direction_action_evaluate_internal_signal <= '0'; -- Continue moving down
                    next_floor_evaluate_internal_signal <= current_floor_dff_internal_signal - 1; -- Decrement floor
                END IF;

            WHEN opened =>
                is_door_open_evaluate_internal_signal <= '1'; -- Door is open when in opened state
                state_next <= closed; -- After opening, close the door

            WHEN OTHERS =>
                is_door_open_evaluate_internal_signal <= '0';
                state_next <= closed; -- Default case to avoid latch-up
        END CASE;
    END PROCESS;
END Behavioral;