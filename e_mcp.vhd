library ieee;

use ieee.std_logic_1164.all;

entity e_mcp is
port (
    p_op: in  std_logic_vector(5 downto 0);
    p_rs: in  std_logic_vector(2 downto 0);
    p_rd: in  std_logic_vector(2 downto 0);
    p_d:  in  std_logic_vector(31 downto 0);
    p_st: in  std_logic;
    p_cl: in  std_logic;
    p_q:  out std_logic_vector(31 downto 0);
    p_f:  out std_logic_vector(8 downto 0)
);
end entity e_mcp;

architecture rtl of e_mcp is
    signal s_op: std_logic_vector(5 downto 0);
    signal s_rs: std_logic_vector(2 downto 0);
    signal s_rd: std_logic_vector(2 downto 0);
    signal s_d:  std_logic_vector(31 downto 0);

    signal s_cmd:   std_logic_vector(37 downto 0);
    signal s_const: std_logic_vector(31 downto 0);
    signal s_op0:   std_logic_vector(31 downto 0);
    signal s_op1:   std_logic_vector(31 downto 0);
    signal s_q:     std_logic_vector(31 downto 0);

    signal s_tri_in_en:    std_logic;
    signal s_tri_const_en: std_logic;
    signal s_tri_data_en:  std_logic;

    signal s_bus_data: std_logic_vector(31 downto 0);
    signal s_bus_ctrl: std_logic_vector(9 downto 0);
begin
    l_rg_op: entity work.c_rg
    generic map (
        g_width => 6
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_op,
        p_cl => p_st,
        p_en => '1',
        p_q  => s_op
    );

    l_rg_rs: entity work.c_rg
    generic map (
        g_width => 3
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_rs,
        p_cl => p_st,
        p_en => '1',
        p_q  => s_rs
    );

    l_rg_rd: entity work.c_rg
    generic map (
        g_width => 3
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_rd,
        p_cl => p_st,
        p_en => '1',
        p_q  => s_rd
    );

    l_rg_in: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_d,
        p_cl => p_st,
        p_en => '1',
        p_q  => s_d
    );

    l_tri_in: entity work.c_tri
    generic map (
        g_width => 32
    )
    port map (
        p_d  => s_d,
        p_en => s_tri_in_en,
        p_q  => s_bus_data
    );

    l_tri_in_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => s_bus_ctrl(4),
        p_en => '1',
        p_q  => s_tri_in_en
    );

    l_mcp_dc: entity work.e_mcp_dc
    port map (
        p_op  => s_op,
        p_cmd => s_cmd
    );

    l_mcp_const: entity work.e_mcp_const
    port map (
        p_cmd => s_cmd(28 downto 25) & s_cmd(17 downto 16),
        p_q   => s_const
    );

    l_tri_const: entity work.c_tri
    generic map (
        g_width => 32
    )
    port map (
        p_d  => s_const,
        p_en => s_tri_const_en,
        p_q  => s_bus_data
    );

    l_tri_const_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => s_bus_ctrl(3),
        p_en => '1',
        p_q  => s_tri_const_en
    );

    l_mcp_data: entity work.e_mcp_data
    port map (
        p_rs   => s_rs,
        p_rd   => s_rd,
        p_d    => s_bus_data,
        p_ctrl => s_bus_ctrl,
        p_q    => s_q,
        p_op0  => s_op0,
        p_op1  => s_op1
    );

    l_tri_data: entity work.c_tri
    generic map (
        g_width => 32
    )
    port map (
        p_d  => s_q,
        p_en => s_tri_data_en,
        p_q  => s_bus_data
    );

    l_tri_data_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => s_bus_ctrl(1),
        p_en => '1',
        p_q  => s_tri_data_en
    );

    l_mcp_out: entity work.e_mcp_out
    port map (
        p_d    => s_bus_data,
        p_ctrl => s_bus_ctrl,
        p_q    => p_q
    );
end architecture rtl;
