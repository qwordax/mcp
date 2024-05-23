library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_f_chs is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(36 downto 0);
    p_q:   out std_logic_vector(31 downto 0);
    p_fl:  out std_logic_vector(9 downto 1);
    p_ex:  out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu_f_chs;

architecture rtl of e_mcp_cu_f_chs is
    signal s_q: std_logic_vector(31 downto 0);
begin
    s_q <= not p_opd(31) & p_opd(30 downto 0);

    p_fl(1)          <= '1' when to_integer(unsigned(s_q(30 downto 0))) = 0 and p_cmd(31) = '1' else '0';
    p_fl(2)          <= s_q(31) when p_cmd(31) = '1' else '0';
    p_fl(9 downto 3) <= (others => '0');

    p_q <= s_q when p_cmd(31) = '1' else (others => '0');

    p_ex <= "0000";
end architecture rtl;
