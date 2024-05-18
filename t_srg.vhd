library ieee;

use ieee.std_logic_1164.all;

entity t_srg is
end entity t_srg;

architecture rtl of t_srg is
    signal s_r:  std_logic;
    signal s_s:  std_logic;
    signal s_di: std_logic;
    signal s_d:  std_logic_vector(3 downto 0);
    signal s_ps: std_logic;
    signal s_lr: std_logic;
    signal s_cl: std_logic := '0';
    signal s_en: std_logic := '1';
    signal s_q:  std_logic_vector(3 downto 0);
begin
    uut: entity work.c_srg
    generic map (
        g_width => 4
    )
    port map (
        p_r  => s_r,
        p_s  => s_s,
        p_di => s_di,
        p_d  => s_d,
        p_ps => s_ps,
        p_lr => s_lr,
        p_cl => s_cl,
        p_en => s_en,
        p_q  => s_q
    );

    s_cl <= not s_cl after 20 ns;

    process is
    begin
        s_r <= '0';
        s_s <= '0';
        wait for 25 ns;

        s_r <= '1';
        wait for 13 ns;

        s_r <= '0';
        wait for 13 ns;

        s_s <= '1';
        wait for 8 ns;

        s_s <= '0';
        wait;
    end process;

    process is
    begin
        s_d  <= "0000";
        s_ps <= '0';
        wait for 80 ns;

        s_d  <= "1001";
        s_ps <= '1';
        wait for 40 ns;

        s_d  <= "0000";
        s_ps <= '0';
        wait;
    end process;

    process is
    begin
        s_di <= '1';
        wait for 80 ns;

        s_di <= '0';
        wait for 40 ns;
    end process;

    process is
    begin
        s_lr <= '0';
        wait for 120 ns;

        s_lr <= '1';
        wait for 80 ns;
    end process;
end architecture rtl;
