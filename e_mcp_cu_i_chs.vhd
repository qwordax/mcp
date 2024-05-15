library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_i_chs is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_i_chs;

architecture rtl of e_mcp_cu_i_chs is
begin
    l_chs: entity work.c_chs
    generic map (
        g_width => 32
    )
    port map (
        p_d  => p_opd,
        p_np => '1',
        p_q  => p_q
    );
end architecture rtl;
