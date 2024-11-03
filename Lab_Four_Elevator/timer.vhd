library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mv_ctrl is
    Port (
        clk : in STD_LOGIC;
        clk_en : out STD_LOGIC;
    );
end mv_ctrl;

architecture Behavioral of mv_ctrl is
    signal cnt : integer range 0 to 5000000 := 0;
    
begin
    process(clk)
    begin 
    if rising_edge(clk) then
        if cnt = 5000000 then
            clk_en <= '1';
            cnt <= 0;
        else
            cnt <= cnt + 1;
            clk_en <= '0';
        end if;
    end if;
    end process;

end Behavioral;