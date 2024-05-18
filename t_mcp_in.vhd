library ieee;

use ieee.std_logic_1164.all;

entity t_mcp_in is
end entity t_mcp_in;

architecture rtl of t_mcp_in is
    signal s_d:    std_logic_vector(31 downto 0);
    signal s_cl:   std_logic := '0';
    signal s_ctrl: std_logic_vector(13 downto 0) := (others => '0');
    signal s_q:    std_logic_vector(31 downto 0);
begin
    uut: entity work.e_mcp_in
    port map (
        p_d    => s_d,
        p_cl   => s_cl,
        p_ctrl => s_ctrl,
        p_q    => s_q
    );

    s_cl <= not s_cl after 10 ns;

    process is
    begin
        s_d <= "00001111000011110101010100110011";
        wait for 60 ns;

        s_d <= "00000000111111110000000011111111";
        wait for 60 ns;
    end process;

    process is
    begin
        s_ctrl(0) <= '1';
        s_ctrl(1) <= '0';
        wait for 20 ns;

        s_ctrl(0) <= '0';
        s_ctrl(1) <= '1';
        wait for 40 ns;
    end process;
end architecture rtl;
