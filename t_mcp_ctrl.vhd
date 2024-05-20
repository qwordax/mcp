library ieee;

use ieee.std_logic_1164.all;

entity t_mcp_ctrl is
end entity t_mcp_ctrl;

architecture rtl of t_mcp_ctrl is
    signal s_r:    std_logic;
    signal s_cmd:  std_logic_vector(36 downto 0);
    signal s_ex:   std_logic_vector(3 downto 0) := (others => '0');
    signal s_cl:   std_logic := '0';
    signal s_ctrl: std_logic_vector(13 downto 0);
begin
    uut: entity work.e_mcp_ctrl
    port map (
        p_r    => s_r,
        p_cmd  => s_cmd,
        p_ex   => s_ex,
        p_cl   => s_cl,
        p_ctrl => s_ctrl
    );

    s_cl <= not s_cl after 20 ns;

    process is
    begin
        s_r   <= '0';
        s_cmd <= (others => '0');
        wait for 40 ns;

        s_cmd(2) <= '1';
        wait;
    end process;
end architecture rtl;
