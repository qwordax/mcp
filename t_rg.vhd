library ieee;

use ieee.std_logic_1164.all;

entity t_rg is
end entity t_rg;

architecture rtl of t_rg is
    signal s_r:  std_logic;
    signal s_s:  std_logic;
    signal s_d:  std_logic_vector(3 downto 0);
    signal s_cl: std_logic := '0';
    signal s_en: std_logic;
    signal s_q:  std_logic_vector(3 downto 0);
begin
    uut: entity work.c_rg
    generic map (
        g_width => 4
    )
    port map (
        p_r  => s_r,
        p_s  => s_s,
        p_d  => s_d,
        p_cl => s_cl,
        p_en => s_en,
        p_q  => s_q
    );

    s_cl <= not s_cl after 10 ns;

    process is
    begin
        s_r <= '0';
        s_s <= '0';
        wait for 24 ns;

        s_r <= '1';
        wait for 7 ns;

        s_r <= '0';
        wait for 19 ns;

        s_s <= '1';
        wait for 4 ns;

        s_s <= '0';
        wait for 14 ns;
    end process;

    process is
    begin
        s_d <= "0101";
        wait for 20 ns;

        s_d <= "0111";
        wait for 20 ns;

        s_d <= "0001";
        wait for 20 ns;

        s_d <= "1100";
        wait for 20 ns;

        s_d <= "0110";
        wait for 20 ns;
    end process;

    process is
    begin
        s_en <= '0';
        wait for 40 ns;

        s_en <= '1';
        wait for 60 ns;
    end process;
end architecture rtl;
