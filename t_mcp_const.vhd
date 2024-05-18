library ieee;

use ieee.std_logic_1164.all;

entity t_mcp_const is
end entity t_mcp_const;

architecture rtl of t_mcp_const is
    signal s_cmd:  std_logic_vector(36 downto 0) := (others => '0');
    signal s_cl:   std_logic := '0';
    signal s_ctrl: std_logic_vector(13 downto 0) := (others => '0');
    signal s_q:    std_logic_vector(31 downto 0);
begin
    uut: entity work.e_mcp_const
    port map (
        p_cmd  => s_cmd,
        p_cl   => s_cl,
        p_ctrl => s_ctrl,
        p_q    => s_q
    );

    s_cl <= not s_cl after 10 ns;

    process is
    begin
        s_cmd(26) <= '1'; -- FWR0
        s_cmd(28) <= '0'; -- FWRP
        wait for 60 ns;

        s_cmd(26) <= '0'; -- IWR0
        s_cmd(28) <= '1'; -- FWRP
        wait for 60 ns;
    end process;

    process is
    begin
        s_ctrl(4) <= '1';
        wait for 20 ns;

        s_ctrl(4) <= '0';
        wait for 20 ns;

        s_ctrl(4) <= '1';
        wait for 20 ns;
    end process;
end architecture rtl;
