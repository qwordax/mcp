library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_i_add is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_ops: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(36 downto 0);
    p_q:   out std_logic_vector(31 downto 0);
    p_fl:  out std_logic_vector(9 downto 1);
    p_ex:  out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu_i_add;

architecture rtl of e_mcp_cu_i_add is
    signal s_ci: std_logic;
    signal s_a:  std_logic_vector(31 downto 0);
    signal s_b:  std_logic_vector(31 downto 0);
    signal s_q:  std_logic_vector(31 downto 0);
begin
    s_ci <= '1' when p_cmd(22) = '1' else '0';

    s_a <= p_opd;
    s_b <= not p_ops when p_cmd(22) = '1' else p_ops;

    l_sm: entity work.c_sm
    generic map (
        g_width => 32
    )
    port map (
        p_ci => s_ci,
        p_a  => s_a,
        p_b  => s_b,
        p_q  => s_q,
        p_co => open,
        p_o  => p_fl(3),
        p_u  => p_fl(4)
    );

    p_fl(1)          <= '1' when to_integer(unsigned(s_q)) = 0 and (p_cmd(21) = '1' or p_cmd(22) = '1') else '0';
    p_fl(2)          <= s_q(31) when  p_cmd(21) = '1' or p_cmd(22) = '1' else '0';
    p_fl(9 downto 5) <= (others => '0');

    p_q <= s_q when p_cmd(21) = '1' or p_cmd(22) = '1' else (others => '0');

    p_ex <= "0000";
end architecture rtl;
