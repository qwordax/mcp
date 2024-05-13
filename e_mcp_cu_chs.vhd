library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_chs is
port (
    p_op:  in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(37 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_chs;

architecture rtl of e_mcp_cu_chs is
    signal s_sm: std_logic_vector(31 downto 0);
begin
    l_sm: entity work.c_sm
    generic map (
        g_width => 32
    )
    port map (
        p_ci => '1',
        p_a  => not p_op,
        p_b  => (others => '0'),
        p_s  => s_sm,
        p_co => open,
        p_o  => open,
        p_u  => open
    );

    process (p_cmd) is
    begin
        if p_cmd(19) = '1' then
            p_q <= s_sm;
        elsif p_cmd(24) = '1' then
            p_q <= p_op xor "10000000000000000000000000000000";
        else
            p_q <= (others => '0');
        end if;
    end process;
end architecture rtl;
