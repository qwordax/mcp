library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_abs is
port (
    p_op:  in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(37 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_abs;

architecture rtl of e_mcp_cu_abs is
    signal s_ci: std_logic;
    signal s_op: std_logic_vector(31 downto 0);
    signal s_sm: std_logic_vector(31 downto 0);

    signal s_q: std_logic_vector(31 downto 0);
begin
    s_ci <= '1' when p_op(31) = '1' else '0';
    s_op <= not p_op when s_ci = '1' else p_op;

    l_sm: entity work.c_sm
    generic map (
        g_width => 32
    )
    port map (
        p_ci => s_ci,
        p_a  => s_op,
        p_b  => (others => '0'),
        p_s  => s_sm,
        p_co => open
    );

    process (p_cmd) is
    begin
        if p_cmd(18) = '1' then
            s_q <= s_sm;
        elsif p_cmd(29) = '1' then
            s_q <= '0' & p_op(30 downto 0);
        else
            s_q <= (others => '0');
        end if;
    end process;

    p_q <= s_q;
end architecture rtl;
