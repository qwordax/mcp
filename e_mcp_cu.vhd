library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_ctrl: in  std_logic_vector(11 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_fl:   out std_logic_vector(9 downto 1)
);
end entity e_mcp_cu;

architecture rtl of e_mcp_cu is
    signal s_opd: std_logic_vector(31 downto 0);
    signal s_ops: std_logic_vector(31 downto 0);

    signal s_f_comp_fl: std_logic_vector(7 downto 5);
    signal s_i_comp_fl: std_logic_vector(7 downto 5);

    signal s_i_add_fl: std_logic_vector(4 downto 3);
    signal s_i_mul_fl: std_logic_vector(4 downto 3);

    signal s_d:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
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
        p_en => '1',
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
        p_en => '1',
        p_q  => s_ops
    );

    l_f_abs: entity work.e_mcp_cu_f_abs
    port map (
        p_opd => s_opd,
        p_q   => open
    );

    l_f_chs: entity work.e_mcp_cu_f_chs
    port map (
        p_opd => s_opd,
        p_q   => open
    );

    l_f_comp: entity work.e_mcp_cu_f_comp
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_fl  => s_i_comp_fl
    );

    l_i_abs: entity work.e_mcp_cu_i_abs
    port map (
        p_opd => s_opd,
        p_q   => open
    );

    l_i_add: entity work.e_mcp_cu_i_add
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => open,
        p_fl  => s_i_add_fl
    );

    l_i_chs: entity work.e_mcp_cu_i_chs
    port map (
        p_opd => s_opd,
        p_q   => open
    );

    l_i_comp: entity work.e_mcp_cu_i_comp
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_fl  => s_i_comp_fl
    );

    l_i_mul: entity work.e_mcp_cu_i_mul
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_ctrl => p_ctrl,
        p_q    => open,
        p_fl   => s_i_mul_fl
    );

    l_logic: entity work.e_mcp_cu_logic
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => open
    );

    l_shift: entity work.e_mcp_cu_shift
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => open
    );

    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_ctrl(3), -- RCU
        p_en => '1',
        p_q  => s_en
    );

    l_tri: entity work.c_tri
    generic map (
        g_width => 32
    )
    port map (
        p_d  => s_d,
        p_en => s_en,
        p_q  => p_q
    );
end architecture rtl;
