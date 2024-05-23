library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_i_abs is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(36 downto 0);
    p_q:   out std_logic_vector(31 downto 0);
    p_fl:  out std_logic_vector(9 downto 1);
    p_ex:  out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu_i_abs;

architecture rtl of e_mcp_cu_i_abs is
    signal s_q: std_logic_vector(31 downto 0);
begin
    l_chs: entity work.c_chs
    generic map (
        g_width => 32
    )
    port map (
        p_d  => p_opd,
        p_np => p_opd(31),
        p_q  => s_q
    );

    p_fl(1)          <= '1' when to_integer(unsigned(s_q(31 downto 0))) = 0 and p_cmd(19) = '1' else '0';
    p_fl(9 downto 2) <= (others => '0');

    p_q <= s_q when p_cmd(19) = '1' else (others => '0');

    p_ex <= "0000";
end architecture rtl;
