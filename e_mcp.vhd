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

    signal s_tri_in_en: std_logic;

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

    l_rg_out: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => s_bus_data,
        p_cl => s_bus_ctrl(7),
        p_en => '1',
        p_q  => p_q
    );
end architecture rtl;
