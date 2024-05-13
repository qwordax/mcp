library ieee;

use ieee.std_logic_1164.all;

entity c_sm is
generic (
    g_width: natural
);
port (
    p_ci: in  std_logic;
    p_a:  in  std_logic_vector(g_width - 1 downto 0);
    p_b:  in  std_logic_vector(g_width - 1 downto 0);
    p_q:  out std_logic_vector(g_width - 1 downto 0);
    p_co: out std_logic;
    p_o:  out std_logic;
    p_u:  out std_logic
);
end entity c_sm;

architecture rtl of c_sm is
    signal s_ci: std_logic_vector(g_width downto 0);
    signal s_co: std_logic_vector(g_width downto 0);

    signal s_a: std_logic_vector(g_width downto 0);
    signal s_b: std_logic_vector(g_width downto 0);
    signal s_q: std_logic_vector(g_width downto 0);
begin
    s_a <= p_a(g_width - 1) & p_a;
    s_b <= p_b(g_width - 1) & p_b;

    s_ci(0) <= p_ci;

    l_cr: for i in 1 to g_width generate
        s_ci(i) <= s_co(i - 1);
    end generate l_cr;

    p_co <= s_co(g_width - 1);

    l_sm: for i in 0 to g_width generate
        l_fa: entity work.c_fa
        port map (
            p_ci => s_ci(i),
            p_a  => s_a(i),
            p_b  => s_b(i),
            p_q  => s_q(i),
            p_co => s_co(i)
        );
    end generate l_sm;

    p_q <= s_q(g_width - 1 downto 0);

    p_o <= '1' when s_q(g_width downto g_width - 1) = "01" else '0';
    p_u <= '1' when s_q(g_width downto g_width - 1) = "10" else '0';
end architecture rtl;
