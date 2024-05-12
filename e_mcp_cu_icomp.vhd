library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_icomp is
port (
    p_op0: in  std_logic_vector(31 downto 0);
    p_op1: in  std_logic_vector(31 downto 0);
    p_f:   out std_logic_vector(7 downto 0)
);
end entity e_mcp_cu_icomp;

architecture rtl of e_mcp_cu_icomp is
begin
    l_comp: entity work.c_comp
    generic map (
        g_width => 32
    )
    port map (
        p_a => p_op0,
        p_b => p_op1,
        p_l => p_f(3),
        p_e => p_f(4),
        p_g => p_f(5)
    );

    p_f(2 downto 0) <= (others => '0');
    p_f(7 downto 6) <= (others => '0');
end architecture rtl;
