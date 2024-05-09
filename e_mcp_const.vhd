library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_const is
port (
    p_cmd: in  std_logic_vector(5 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_const;

architecture rtl of e_mcp_const is
begin
    process (p_cmd) is
    begin
        case p_cmd is
            when "000001" => p_q <= "00000000000000000000000000000000";
            when "000010" => p_q <= "00000000000000000000000000000001";
            when "000100" => p_q <= "00000000000000000000000000000000";
            when "001000" => p_q <= "00111111100000000000000000000000";
            when "010000" => p_q <= "01000000010010010000111111011011";
            when "100000" => p_q <= "01000000001011011111100001010100";
            when others   => p_q <= "00000000000000000000000000000000";
        end case;
    end process;
end architecture rtl;
