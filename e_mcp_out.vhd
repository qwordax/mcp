library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_out is
port (
    p_d:    in  std_logic_vector(31 downto 0);
    p_ctrl: in  std_logic_vector(11 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_out;

architecture rtl of e_mcp_out is
begin
    l_out: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_d,
        p_cl => p_ctrl(6), -- WOUT
        p_en => '1',
        p_q  => p_q
    );
end architecture rtl;
