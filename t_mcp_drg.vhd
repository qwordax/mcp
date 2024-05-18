library ieee;

use ieee.std_logic_1164.all;

entity t_mcp_drg is
end entity t_mcp_drg;

architecture rtl of t_mcp_drg is
    signal s_rd:   std_logic_vector(2 downto 0);
    signal s_rs:   std_logic_vector(2 downto 0);
    signal s_cl:   std_logic := '0';
    signal s_ctrl: std_logic_vector(13 downto 0);
    signal s_d:    std_logic_vector(31 downto 0);
    signal s_opd:  std_logic_vector(31 downto 0);
    signal s_ops:  std_logic_vector(31 downto 0);
begin
    uut: entity work.e_mcp_drg
    port map (
        p_rd   => s_rd,
        p_rs   => s_rs,
        p_cl   => s_cl,
        p_ctrl => s_ctrl,
        p_d    => s_d,
        p_opd  => s_opd,
        p_ops  => s_ops
    );

    s_cl <= not s_cl after 10 ns;

    process is
    begin
        s_rd   <= (others => '0');
        s_rs   <= (others => '0');
        s_d    <= (others => 'Z');
        s_ctrl <= (others => '0');
        wait for 20 ns;

        s_rd      <= "011";
        s_d       <= "00000000111111110000000011111111";
        s_ctrl(5) <= '1'; -- WDR
        wait for 20 ns;

        s_rd   <= (others => '0');
        s_rs   <= (others => '0');
        s_d    <= (others => 'Z');
        s_ctrl <= (others => '0');
        wait for 20 ns;

        s_rd      <= "101";
        s_d       <= "11111111111111110000000011111111";
        s_ctrl(5) <= '1'; -- WDR
        wait for 20 ns;

        s_rd   <= (others => '0');
        s_rs   <= (others => '0');
        s_d    <= (others => 'Z');
        s_ctrl <= (others => '0');
        wait for 20 ns;

        s_rd      <= "111";
        s_rs      <= "011";
        s_ctrl(2) <= '1'; -- RDR
        wait for 20 ns;

        s_ctrl(2) <= '0'; -- RDR
        s_ctrl(5) <= '1'; -- WDR
        wait for 20 ns;

        s_ctrl(2) <= '1'; -- RDR
        s_ctrl(5) <= '0'; -- WDR
        wait for 20 ns;
    end process;
end architecture rtl;
