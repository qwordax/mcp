library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_i_abs is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(37 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_i_abs;

architecture rtl of e_mcp_cu_i_abs is
    signal s_opd: std_logic_vector(31 downto 0);
    signal s_q:   std_logic_vector(31 downto 0);
begin
    l_opd: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_opd,
        p_cl => p_ctrl(8), -- CU0
        p_en => p_cmd(19), -- IABS
        p_q  => s_opd
    );

    l_chs: entity work.c_chs
    generic map (
        g_width => 32
    )
    port map (
        p_d  => s_opd,
        p_np => s_opd(31),
        p_q  => s_q
    );

    p_q <= s_q when p_cmd(19) = '1' else (others => '0');
end architecture rtl;
