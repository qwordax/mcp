library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_in is
port (
    p_d:    in  std_logic_vector(31 downto 0);
    p_st:   in  std_logic;
    p_ctrl: in  std_logic_vector(9 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_in;

architecture rtl of e_mcp_in is
    signal s_d:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
begin
    l_in: entity work.c_rg
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

    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_ctrl(4),
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
