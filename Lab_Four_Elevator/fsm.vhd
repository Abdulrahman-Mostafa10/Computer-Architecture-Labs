LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY fsm IS
    GENERIC (
        NUM_FLOORS : INTEGER := 10;
        NUM_BITS : INTEGER := 4
    );
    PORT (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        requested_next_floor : IN STD_LOGIC_VECTOR (NUM_BITS - 1 DOWNTO 0);
        reached_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
        direction_action : OUT STD_LOGIC;
        is_door_open : OUT STD_LOGIC
    );
END fsm;

ARCHITECTURE Behavioral OF fsm IS
    TYPE fsm_state_type IS
    (up, down, opened, closed);
    SIGNAL old_direction : STD_LOGIC := '0';
    SIGNAL clk_counter : STD_LOGIC := '0';
    SIGNAL current_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL state_reg, state_next : fsm_state_type;
BEGIN
    dff : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            current_floor <= (OTHERS => '0');
            reached_floor <= (OTHERS => '0');
            direction_action <= '0';
            old_direction <= '0';
            is_door_open <= '0';
            state_reg <= closed;
        ELSIF (rising_edge(clk)) THEN
            IF (clk_counter = '0') THEN
                clk_counter <= '1';
            ELSE
                clk_counter <= '0';
                state_reg <= state_next;
                reached_floor <= current_floor;
            END IF;
        ELSE
            clk_counter <= '1';
            state_reg <= state_next;
            reached_floor <= current_floor;
        END IF;
    END PROCESS;

    evaluate_state : PROCESS (state_reg, requested_next_floor)
    BEGIN
        reached_floor <= current_floor;
        CASE state_reg IS
            WHEN closed =>
                IF (requested_next_floor > current_floor) THEN
                    state_next <= up;
                    old_direction <= '1';
                    direction_action <= '1';
                    current_floor <= current_floor + 1;
                ELSIF (requested_next_floor = current_floor) THEN
                    state_next <= closed;
                    direction_action <= old_direction;
                ELSE
                    state_next <= down;
                    old_direction <= '0';
                    direction_action <= '0';
                    current_floor <= current_floor - 1;
                END IF;
            WHEN up =>
                IF (requested_next_floor = current_floor) THEN
                    state_next <= opened;
                    direction_action <= old_direction;
                ELSE
                    direction_action <= '1';
                    current_floor <= current_floor + 1;
                END IF;
            WHEN down =>
                IF (requested_next_floor = current_floor) THEN
                    state_next <= opened;
                ELSIF (requested_next_floor < current_floor) THEN
                    direction_action <= '0';
                    current_floor <= current_floor - 1;
                END IF;
            WHEN opened =>
                is_door_open <= '1';
                state_next <= closed;
        END CASE;
    END PROCESS;
END Behavioral;