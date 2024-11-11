LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY custom_elevator IS
    PORT (
        --Input signals
        clk : IN STD_LOGIC; -- freq=50MHz (the frequency of the FPGA board)
        reset : IN STD_LOGIC; -- asynchronous reset with active high
        request : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --requested floor using push buttons

        --Output signals
        seven_segment_display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --to be displayed on the seven-segment display
        is_moving_up : OUT STD_LOGIC; -- to be displayed on the LEDs
        is_moving_down : OUT STD_LOGIC; -- to be displayed on the LEDs
        is_door_open : OUT STD_LOGIC -- to be displayed on the LEDs
    );
END custom_elevator;

ARCHITECTURE Behavioral OF custom_elevator IS

    SIGNAL clk_out : STD_LOGIC; -- Clock signal for the elevator (1 second period)
    SIGNAL current_floor : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Current floor signal to be displayed on the seven-segment display
    COMPONENT elevator
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
    END COMPONENT;

    COMPONENT timer IS
        PORT (
            clk : IN STD_LOGIC;
            clk_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ssd IS
        PORT (
            BCD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            segments : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
BEGIN
    elevator_inst : elevator
    GENERIC MAP(
        NUM_FLOORS => 10,
        NUM_BITS => 4
    )
    PORT MAP(
        clk => clk_out,
        reset => reset,
        request => request,

        current_floor => current_floor,
        is_moving_up => is_moving_up,
        is_moving_down => is_moving_down,
        is_door_open => is_door_open
    );

    timer_inst : timer
    PORT MAP(
        clk => clk,
        clk_out => clk_out
    );

    ssd_inst : ssd
    PORT MAP(
        BCD => current_floor,
        segments => seven_segment_display
    );
END Behavioral;