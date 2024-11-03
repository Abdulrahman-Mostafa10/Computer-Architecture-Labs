library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port (
        BCD : in STD_LOGIC_VECTOR(3 downto 0);  
        segments : out STD_LOGIC_VECTOR(6 downto 0)  
    );
end SSD;

architecture Behavioral of SSD is
begin
    process(BCD)
    begin
        case BCD is
            when "0000" => segments <= "1111110";  
            when "0001" => segments <= "0110000";  
            when "0010" => segments <= "1101101";  
            when "0011" => segments <= "1111001";  
            when "0100" => segments <= "0110011";  
            when "0101" => segments <= "1011011";  
            when "0110" => segments <= "1011111";  
            when "0111" => segments <= "1110000";  
            when "1000" => segments <= "1111111";  
            when "1001" => segments <= "1111011";  
            when others => segments <= "0000000";
        end case;
    end process;
end Behavioral;
