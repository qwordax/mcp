library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_i_comp is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_ops: in  std_logic_vector(31 downto 0);
    p_fl:  out std_logic_vector(9 downto 1)
);
end entity e_mcp_cu_i_comp;

architecture rtl of e_mcp_cu_i_comp is
begin
    l_comp: entity work.c_comp
    generic map (
        g_width => 32
    )
    port map (
        p_a  => p_opd,
        p_b  => p_ops,
        p_en => '1',
        p_l  => p_fl(5),
        p_e  => p_fl(6),
        p_g  => p_fl(7)
    );

    p_fl(4 downto 1) <= (others => '0');
    p_fl(9 downto 8) <= (others => '0');
end architecture rtl;
