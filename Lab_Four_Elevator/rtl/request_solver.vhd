LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY request_solver IS
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
END request_solver;

ARCHITECTURE Behavioral OF request_solver IS
    SIGNAL floors_bit_set : STD_LOGIC_VECTOR(NUM_FLOORS - 1 DOWNTO 0) := (OTHERS => '0'); -- Bit set for requested floors
    SIGNAL next_floor_reg : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL last_requested_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL last_sent_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0) := (OTHERS => '0'); -- Last sent to fsm
BEGIN

    -- Assign next_floor signal at the end of the process to propagate changes
    next_floor <= next_floor_reg;

    PROCESS (clk, reset)
        VARIABLE found_floor : INTEGER := 0; -- Found floor as a variable to be used in the process loop
        VARIABLE current_floor_integer : INTEGER := 0; -- Current floor as an integer to be used in the process easily
    BEGIN
        IF reset = '1' THEN
            next_floor_reg <= current_floor;
            floors_bit_set <= (OTHERS => '0'); -- Initialize floors_bit_set to all '0'
            last_requested_floor <= current_floor;
        ELSIF request /= last_requested_floor THEN
            last_requested_floor <= request; -- Update last requested floor
            floors_bit_set(to_integer(unsigned(request))) <= '1'; -- Mark the requested floor in floors_bit_set
        ELSIF rising_edge(clk) THEN
            current_floor_integer := to_integer(unsigned(current_floor)); -- Convert current_floor to an integer
            found_floor := current_floor_integer; -- Initialize the found_floor variable to the current floor
            -- Check upper floors if the elevator is moving up
            IF is_moving_up = '1' THEN
                -- Search for higher floors
                IF floors_bit_set(current_floor_integer) = '1' THEN
                    found_floor := current_floor_integer;
                ELSE
                    FOR i IN current_floor_integer + 1 TO NUM_FLOORS - 1 LOOP
                        IF floors_bit_set(i) = '1' THEN
                            found_floor := i;
                            EXIT;
                        END IF;
                    END LOOP;

                    -- If no higher floor request is found, check lower floors
                    IF found_floor = current_floor_integer THEN
                        FOR i IN current_floor_integer - 1 DOWNTO 0 LOOP
                            IF floors_bit_set(i) = '1' THEN
                                found_floor := i;
                                EXIT;
                            END IF;
                        END LOOP;
                    END IF;
                END IF;
            ELSE

                IF floors_bit_set(current_floor_integer) = '1' THEN
                    found_floor := current_floor_integer;
                ELSE
                    -- Check lower floors if the elevator is moving down
                    FOR i IN current_floor_integer - 1 DOWNTO 0 LOOP
                        IF floors_bit_set(i) = '1' THEN
                            found_floor := i;
                            EXIT;
                        END IF;
                    END LOOP;

                    -- If no lower floor request is found, check higher floors
                    IF found_floor = current_floor_integer THEN
                        FOR i IN current_floor_integer + 1 TO NUM_FLOORS - 1 LOOP
                            IF floors_bit_set(i) = '1' THEN
                                found_floor := i;
                                EXIT;
                            END IF;
                        END LOOP;
                    END IF;
                END IF;
            END IF;
            -- Set the next floor output using proper signal assignment
            floors_bit_set(current_floor_integer) <= '0'; -- Mark the requested floor in floors_bit_set
            next_floor_reg <= STD_LOGIC_VECTOR(to_unsigned(found_floor, NUM_BITS));
            last_sent_floor <= STD_LOGIC_VECTOR(to_unsigned(found_floor, NUM_BITS));
        END IF;
    END PROCESS;

END Behavioral;