library ieee;

use ieee.std_logic_1164.all;

entity t_mul is
end entity t_mul;

architecture rtl of t_mul is
    signal s_a:  std_logic_vector(3 downto 0);
    signal s_b:  std_logic_vector(3 downto 0);
    signal s_st: std_logic;
    signal s_cl: std_logic_vector(1 downto 0);
    signal s_q:  std_logic_vector(7 downto 0);
    signal s_o:  std_logic;
    signal s_u:  std_logic;
begin
    uut: entity work.c_mul
    generic map (
        g_width => 4
    )
    port map (
        p_a  => s_a,
        p_b  => s_b,
        p_st => s_st,
        p_cl => s_cl,
        p_q  => s_q,
        p_o  => s_o,
        p_u  => s_u
    );

    process is
    begin
        s_a  <= "0010";
        s_b  <= "0101";
        s_st <= '0';
        s_cl <= "00";
        wait for 20 ns;

        s_st <= '1';
        wait for 10 ns;

        s_st <= '0';
        wait for 10 ns;

        for i in 1 to 4 loop
            s_cl(0) <= '1';
            wait for 10 ns;

            s_cl(0) <= '0';
            wait for 10 ns;

            s_cl(1) <= '1';
            wait for 10 ns;

            s_cl(1) <= '0';
            wait for 10 ns;
        end loop;

        s_a  <= "1110";
        s_b  <= "1011";
        s_st <= '0';
        s_cl <= "00";
        wait for 20 ns;

        s_st <= '1';
        wait for 10 ns;

        s_st <= '0';
        wait for 10 ns;

        for i in 1 to 4 loop
            s_cl(0) <= '1';
            wait for 10 ns;

            s_cl(0) <= '0';
            wait for 10 ns;

            s_cl(1) <= '1';
            wait for 10 ns;

            s_cl(1) <= '0';
            wait for 10 ns;
        end loop;

        s_a  <= "0010";
        s_b  <= "1011";
        s_st <= '0';
        s_cl <= "00";
        wait for 20 ns;

        s_st <= '1';
        wait for 10 ns;

        s_st <= '0';
        wait for 10 ns;

        for i in 1 to 4 loop
            s_cl(0) <= '1';
            wait for 10 ns;

            s_cl(0) <= '0';
            wait for 10 ns;

            s_cl(1) <= '1';
            wait for 10 ns;

            s_cl(1) <= '0';
            wait for 10 ns;
        end loop;

        s_a  <= "0010";
        s_b  <= "1101";
        s_st <= '0';
        s_cl <= "00";
        wait for 20 ns;

        s_st <= '1';
        wait for 10 ns;

        s_st <= '0';
        wait for 10 ns;

        for i in 1 to 4 loop
            s_cl(0) <= '1';
            wait for 10 ns;

            s_cl(0) <= '0';
            wait for 10 ns;

            s_cl(1) <= '1';
            wait for 10 ns;

            s_cl(1) <= '0';
            wait for 10 ns;
        end loop;

        wait;
    end process;
end architecture rtl;
