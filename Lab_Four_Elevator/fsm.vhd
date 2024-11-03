LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STDLOGIC_UNSIGNED.ALL;

ENTITY fsm IS
    PORT (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        requested_next_floor : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        reached_floor : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        direction_action : OUT STD_LOGIC
    );
END fsm;

ARCHITECTURE Behavioral OF fsm IS
    TYPE fsm_state_type IS
    (up, down, opened, closed);
    VARIABLE old_direction : STD_LOGIC := 1;
    VARIABLE clk_counter : STD_LOGIC(1 DOWNTO 0) := 00;
    VARIABLE current_floor : STD_LOGIC_VECTOR(9 DOWNTO 0) := 0000000000;
    SIGNAL state_reg, state_next : fsm_state_type
BEGIN
    dff : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            current_floor := 0000000000;
        ELSIF (rising_edge(clk)) THEN
            IF (clk_counter = '0') THEN
                clk_counter := clk_counter + 1;
            ELSE
                clk_counter := 0;
                state_reg <= state_next;
            END IF;
        END IF;
    END PROCESS;

    evaluate_state : PROCESS (state_reg, requested_next_floor)
    BEGIN
        reached_floor <= old_direction;
        CASE state_reg IS
            WHEN close =>
                IF (requested_next_floor > current_floor) THEN
                    state_next <= UP;
                ELSIF (requested_next_floor = reached_floor) THEN
                    state_next <= close;
                ELSE
                    state_next <= down;
                END IF;
            WHEN up =>
                IF (requested_next_floor = reached_floor) THEN
                    state_next <= opened;
                ELSIF (requested_next_floor > reached_floor) THEN
                    state_next <= up;
                END IF;
            WHEN down =>
                IF (requested_next_floor = reached_floor) THEN
                    state_next <= opened;
                ELSIF (requested_next_floor < reached_floor) THEN
                    state_next <= down;
                END IF;
            WHEN OPEN =>
                state_reg <= close;
        END CASE;
    END PROCESS