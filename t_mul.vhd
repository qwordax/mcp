library ieee;

use ieee.std_logic_1164.all;

entity t_mul is
end entity t_mul;

architecture rtl of t_mul is
    signal s_a:  std_logic_vector(3 downto 0);
    signal s_b:  std_logic_vector(3 downto 0);
    signal s_cl: std_logic := '0';
    signal s_en: std_logic;
    signal s_q:  std_logic_vector(7 downto 0);
begin
    uut: entity work.c_mul
    generic map (
        g_width => 4
    )
    port map (
        p_a  => s_a,
        p_b  => s_b,
        p_cl => s_cl,
        p_en => s_en,
        p_q  => s_q
    );

    s_cl <= not s_cl after 20 ns;

    process is
    begin
        s_a  <= "0011";
        s_b  <= "0101";
        s_en <= '0';
        wait for 40 ns;

        s_en <= '1';
        wait for 40 * 9 ns;

        s_en <= '0';
        wait for 40 ns;

        s_a  <= "1101";
        s_b  <= "0101";
        s_en <= '0';
        wait for 40 ns;

        s_en <= '1';
        wait for 40 * 9 ns;

        s_en <= '0';
        wait for 40 ns;

        s_a  <= "0011";
        s_b  <= "1011";
        s_en <= '0';
        wait for 40 ns;

        s_en <= '1';
        wait for 40 * 9 ns;

        s_en <= '0';
        wait for 40 ns;

        s_a  <= "1101";
        s_b  <= "1011";
        s_en <= '0';
        wait for 40 ns;

        s_en <= '1';
        wait for 40 * 9 ns;

        s_en <= '0';
        wait;
    end process;
end architecture rtl;
