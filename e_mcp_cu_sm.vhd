library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_sm is
port (
    p_op0: in  std_logic_vector(31 downto 0);
    p_op1: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(37 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_sm;

architecture rtl of e_mcp_cu_sm is
    signal s_ci: std_logic;

    signal s_a: std_logic_vector(31 downto 0);
    signal s_b: std_logic_vector(31 downto 0);
begin
    s_ci <= '1' when p_cmd(21) = '1' else '0';

    s_a <= p_op1;
    s_b <= not p_op0 when p_cmd(21) = '1' else p_op0;

    l_sm: entity work.c_sm
    generic map (
        g_width => 32
    )
    port map (
        p_ci => s_ci,
        p_a  => s_a,
        p_b  => s_b,
        p_s  => p_q,
        p_co => open
    );
end architecture rtl;
