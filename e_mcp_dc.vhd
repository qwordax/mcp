library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_dc is
port (
    p_op:  in  std_logic_vector(5 downto 0);
    p_cmd: out std_logic_vector(36 downto 0)
);
end entity e_mcp_dc;

architecture rtl of e_mcp_dc is
begin
    process (p_op) is
    begin
        p_cmd <= (others => '0');

        case p_op is
            when "000000" => p_cmd(1)  <= '1';
            when "000001" => p_cmd(2)  <= '1';
            when "000010" => p_cmd(3)  <= '1';
            when "001000" => p_cmd(4)  <= '1';
            when "001001" => p_cmd(5)  <= '1';
            when "001010" => p_cmd(6)  <= '1';
            when "001011" => p_cmd(7)  <= '1';
            when "001101" => p_cmd(8)  <= '1';
            when "001110" => p_cmd(9)  <= '1';
            when "001111" => p_cmd(10) <= '1';
            when "010000" => p_cmd(11) <= '1';
            when "010001" => p_cmd(12) <= '1';
            when "010010" => p_cmd(13) <= '1';
            when "010011" => p_cmd(14) <= '1';
            when "010100" => p_cmd(15) <= '1';
            when "010101" => p_cmd(16) <= '1';
            when "000100" => p_cmd(17) <= '1';
            when "000101" => p_cmd(18) <= '1';
            when "011000" => p_cmd(19) <= '1';
            when "011001" => p_cmd(20) <= '1';
            when "011010" => p_cmd(21) <= '1';
            when "011011" => p_cmd(22) <= '1';
            when "011100" => p_cmd(23) <= '1';
            when "011101" => p_cmd(24) <= '1';
            when "011111" => p_cmd(25) <= '1';
            when "100000" => p_cmd(26) <= '1';
            when "100001" => p_cmd(27) <= '1';
            when "100010" => p_cmd(28) <= '1';
            when "100011" => p_cmd(29) <= '1';
            when "101000" => p_cmd(30) <= '1';
            when "101001" => p_cmd(31) <= '1';
            when "101010" => p_cmd(32) <= '1';
            when "101011" => p_cmd(33) <= '1';
            when "101100" => p_cmd(34) <= '1';
            when "101101" => p_cmd(35) <= '1';
            when "101111" => p_cmd(36) <= '1';
            when others   => p_cmd(0)  <= '1';
        end case;
    end process;
end architecture rtl;
