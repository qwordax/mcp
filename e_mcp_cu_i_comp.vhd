library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_i_comp is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_fl:   out std_logic_vector(7 downto 5)
);
end entity e_mcp_cu_i_comp;

architecture rtl of e_mcp_cu_i_comp is
    signal s_opd: std_logic_vector(31 downto 0);
    signal s_ops: std_logic_vector(31 downto 0);
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
        p_en => p_cmd(25), -- ICMP
        p_q  => s_opd
    );

    l_ops: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_ops,
        p_cl => p_ctrl(8), -- CU0
        p_en => p_cmd(25), -- ICMP
        p_q  => s_ops
    );

    l_comp: entity work.c_comp
    generic map (
        g_width => 32
    )
    port map (
        p_a  => s_opd,
        p_b  => s_ops,
        p_en => p_cmd(25), -- ICMP
        p_l  => p_fl(5),
        p_e  => p_fl(6),
        p_g  => p_fl(7)
    );
end architecture rtl;
