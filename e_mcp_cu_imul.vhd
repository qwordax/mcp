library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_imul is
port (
    p_op0:  in  std_logic_vector(31 downto 0);
    p_op1:  in  std_logic_vector(31 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_imul;

architecture rtl of e_mcp_cu_imul is
    signal s_cl: std_logic_vector(1 downto 0);
    signal s_q:  std_logic_vector(63 downto 0);
begin
    s_cl <= p_ctrl(10) & p_ctrl(9);

    l_mul: entity work.c_mul
    generic map (
        g_width => 32
    )
    port map (
        p_a  => p_op0,
        p_b  => p_op1,
        p_st => p_ctrl(8),
        p_cl => s_cl,
        p_q  => s_q,
        p_o  => open,
        p_u  => open
    );

    p_q <= s_q(31 downto 0);
end architecture rtl;
