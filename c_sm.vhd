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
    p_s:  in  std_logic_vector(g_width - 1 downto 0);
    p_co: out std_logic
);
end entity c_sm;

architecture rtl of c_sm is
    signal s_ci: std_logic_vector(g_width - 1 downto 0);
    signal s_co: std_logic_vector(g_width - 1 downto 0);
begin
    p_ci(0) <= p_ci;

    l_cr: for i in 1 to g_width - 1 generate
        s_ci(i) <= s_co(i - 1);
    end generate l_cr;

    p_co <= s_co(g_width - 1);

    l_sm: for i in 0 to g_width - 1 generate
        l_fa: entity work.c_fa
        port map (
            p_ci => s_ci(i),
            p_a  => p_a(i),
            p_b  => p_b(i),
            p_s  => p_s(i),
            p_co => s_co(i)
        );
    end generate l_sm;
end architecture rtl;
