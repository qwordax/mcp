library ieee;

use ieee.std_logic_1164.all;

entity e_mcp is
port (
    p_op: in  std_logic_vector(5 downto 0);
    p_rd: in  std_logic_vector(2 downto 0);
    p_rs: in  std_logic_vector(2 downto 0);
    p_d:  in  std_logic_vector(31 downto 0);
    p_st: in  std_logic;
    p_cl: in  std_logic;
    p_q:  out std_logic_vector(31 downto 0);
    p_fl: out std_logic_vector(9 downto 0)
);
end entity e_mcp;

architecture rtl of e_mcp is
    signal s_en:   std_logic;
    signal s_en_p: std_logic;

    signal s_op: std_logic_vector(5 downto 0);
    signal s_rd: std_logic_vector(2 downto 0);
    signal s_rs: std_logic_vector(2 downto 0);
    signal s_d:  std_logic_vector(31 downto 0);
    signal s_q:  std_logic_vector(31 downto 0);
    signal s_fl: std_logic_vector(8 downto 0);

    signal s_cmd: std_logic_vector(36 downto 0);
    signal s_opd: std_logic_vector(31 downto 0);
    signal s_ops: std_logic_vector(31 downto 0);

    signal s_bus_d:    std_logic_vector(31 downto 0);
    signal s_bus_ctrl: std_logic_vector(11 downto 0);
begin
    l_mcp_op: entity work.c_rg
    generic map (
        g_width => 6
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_op,
        p_cl => p_cl,
        p_en => s_en,
        p_q  => s_op
    );

    l_mcp_rd: entity work.c_rg
    generic map (
        g_width => 3
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_rd,
        p_cl => p_cl,
        p_en => s_en,
        p_q  => s_rd
    );

    l_mcp_rs: entity work.c_rg
    generic map (
        g_width => 3
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_rs,
        p_cl => p_cl,
        p_en => s_en,
        p_q  => s_rs
    );

    s_en_p <= not s_en;

    l_en: entity work.c_dff
    port map (
        p_r  => s_bus_ctrl(11),
        p_s  => '0',
        p_d  => s_en_p,
        p_cl => p_st,
        p_en => '1',
        p_q  => s_en
    );

    l_mcp_ctrl: entity work.e_mcp_ctrl
    port map (
        p_r    => '0',
        p_cmd  => s_cmd,
        p_cl   => p_cl,
        p_en   => s_en,
        p_ctrl => s_bus_ctrl
    );

    l_mcp_dc: entity work.e_mcp_dc
    port map (
        p_op  => s_op,
        p_cmd => s_cmd
    );

    l_mcp_in: entity work.e_mcp_in
    port map (
        p_d    => p_d,
        p_ctrl => s_bus_ctrl,
        p_q    => s_bus_d
    );

    l_mcp_cu: entity work.e_mcp_cu
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => s_cmd,
        p_ctrl => s_bus_ctrl,
        p_q    => s_bus_d,
        p_fl   => s_fl
    );

    l_mcp_const: entity work.e_mcp_const
    port map (
        p_cmd  => s_cmd,
        p_ctrl => s_bus_ctrl,
        p_q    => s_bus_d
    );

    l_mcp_drg: entity work.e_mcp_drg
    port map (
        p_rs   => s_rs,
        p_rd   => s_rd,
        p_ctrl => s_bus_ctrl,
        p_d    => s_bus_d,
        p_opd  => s_opd,
        p_ops  => s_ops
    );

    l_mcp_out: entity work.e_mcp_out
    port map (
        p_d    => s_bus_d,
        p_ctrl => s_bus_ctrl,
        p_q    => p_q
    );

    l_fl: entity work.c_rg
    generic map (
        g_width => 9
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => s_fl,
        p_cl => s_bus_ctrl(7),
        p_en => '1',
        p_q  => p_fl(9 downto 1)
    );

    p_fl(0) <= s_en;
end architecture rtl;
