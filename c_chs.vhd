library ieee;

use ieee.std_logic_1164.all;

entity c_chs is
generic (
    g_width: natural
);
port (
    p_d:  in  std_logic_vector(g_width - 1 downto 0);
    p_np: in  std_logic;
    p_q:  out std_logic_vector(g_width - 1 downto 0)
);
end entity c_chs;

architecture rtl of c_chs is
    signal s_d_p: std_logic_vector(g_width - 1 downto 0);
    signal s_d_n: std_logic_vector(g_width - 1 downto 0);

    signal s_sm_a: std_logic_vector(g_width - 1 downto 0);
begin
    s_d_p <= p_d;

    s_sm_a <= not s_d_p;

    l_sm: entity work.c_sm
    generic map (
        g_width => g_width
    )
    port map (
        p_ci => '1',
        p_a  => s_sm_a,
        p_b  => (others => '0'),
        p_q  => s_d_n,
        p_co => open,
        p_o  => open,
        p_u  => open
    );

    p_q <= s_d_n when p_np = '1' xor p_d(g_width - 1) = '1' else s_d_p;
end architecture rtl;
