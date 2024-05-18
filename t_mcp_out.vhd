library ieee;

use ieee.std_logic_1164.all;

entity t_mcp_out is
end entity t_mcp_out;

architecture rtl of t_mcp_out is
    signal s_d:    std_logic_vector(31 downto 0);
    signal s_cl:   std_logic := '0';
    signal s_ctrl: std_logic_vector(13 downto 0) := (others => '0');
    signal s_q:    std_logic_vector(31 downto 0);
begin
    uut: entity work.e_mcp_out
    port map (
        p_d    => s_d,
        p_cl   => s_cl,
        p_ctrl => s_ctrl,
        p_q    => s_q
    );

    s_cl <= not s_cl after 10 ns;

    process is
    begin
        s_d <= "00001111000011111111000011110000";
        wait for 20 ns;

        s_d <= "11111111000011111111111111110000";
        wait for 20 ns;
    end process;

    process is
    begin
        s_ctrl(6) <= '1';
        wait for 40 ns;

        s_ctrl(6) <= '0';
        wait for 40 ns;
    end process;
end architecture rtl;
