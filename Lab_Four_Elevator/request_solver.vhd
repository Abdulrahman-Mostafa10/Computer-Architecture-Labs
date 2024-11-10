LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY request_solver IS
    GENERIC (
        NUM_FLOORS : INTEGER := 10; -- Number of floors
        NUM_BITS : INTEGER := 4 -- Number of bits for addressing
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        direction : IN STD_LOGIC;
        request : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
        current_floor : IN STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);

        next_floor : OUT STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0)
    );
END request_solver;

ARCHITECTURE Behavioral OF request_solver IS
    SIGNAL floors_bit_set : STD_LOGIC_VECTOR(NUM_FLOORS - 1 DOWNTO 0);
    SIGNAL next_floor_reg : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
    SIGNAL last_requested_floor : STD_LOGIC_VECTOR(NUM_BITS - 1 DOWNTO 0);
BEGIN

    -- Assign next_floor signal at the end of the process to propagate changes
    next_floor <= next_floor_reg;

    PROCESS (clk, reset)
        VARIABLE found_floor : INTEGER := 0; -- Found floor as a variable
        VARIABLE current_floor_integer : INTEGER := 0;
    BEGIN
        IF reset = '1' THEN
            -- Reset all signals on reset
            next_floor_reg <= current_floor; -- Initialize next_floor_reg to all '0'
            floors_bit_set <= (OTHERS => '0'); -- Initialize floors_bit_set to all '0'
            last_requested_floor <= current_floor; -- Initialize last_requested_floor to all '0'
        ELSIF request /= last_requested_floor THEN
            -- Mark the requested floor in floors_bit_set
            last_requested_floor <= request;
            floors_bit_set(to_integer(unsigned(request)) - 1) <= '1';
        ELSIF rising_edge(clk) THEN
            -- Convert current_floor to an integer
            current_floor_integer := to_integer(unsigned(current_floor));

            -- Handle request updates (mark requested floors)

            -- Initialize the found_floor variable to the current floor
            found_floor := current_floor_integer;

            -- Check floors in the requested direction
            IF direction = '1' THEN
                -- Search for higher floors
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
            ELSE
                -- Search for lower floors
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

            -- Set the next floor output using proper signal assignment
            next_floor_reg <= STD_LOGIC_VECTOR(to_unsigned(found_floor, NUM_BITS));
        END IF;
    END PROCESS;

END Behavioral;