library ieee;

use ieee.std_logic_1164.all;

entity t_sm is
end entity t_sm;

architecture rtl of t_sm is
    signal s_ci: std_logic;
    signal s_a:  std_logic_vector(3 downto 0);
    signal s_b:  std_logic_vector(3 downto 0);
    signal s_q:  std_logic_vector(3 downto 0);
    signal s_co: std_logic;
    signal s_o:  std_logic;
    signal s_u:  std_logic;
begin
    uut: entity work.c_sm
    generic map (
        g_width => 4
    )
    port map (
        p_ci => s_ci,
        p_a  => s_a,
        p_b  => s_b,
        p_q  => s_q,
        p_co => s_co,
        p_o  => s_o,
        p_u  => s_u
    );

    process is
    begin
        s_ci <= '0';
        wait for 40 ns;

        s_ci <= '1';
        wait for 20 ns;
    end process;

    process is
    begin
        s_a <= "0110";
        s_b <= "0011";
        wait for 20 ns;

        s_a <= "0110";
        s_b <= "0001";
        wait for 20 ns;

        s_a <= "0110";
        s_b <= "1011";
        wait for 20 ns;

        s_a <= "1000";
        s_b <= "1110";
        wait for 20 ns;
    end process;
end architecture rtl;
