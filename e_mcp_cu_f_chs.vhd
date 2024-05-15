library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_f_chs is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_f_chs;

architecture rtl of e_mcp_cu_f_chs is
    signal s_opd: std_logic_vector(31 downto 0);
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
        p_en => p_cmd(31), -- FCHS
        p_q  => s_opd
    );

    p_q <= not s_opd(31) & s_opd(30 downto 0);
end architecture rtl;