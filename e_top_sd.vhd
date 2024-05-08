library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_top_sd is
port (
    p_d:     in  std_logic_vector(31 downto 0);
    p_cs:    in  std_logic_vector(31 downto 0);
    p_ml:    in  std_logic;
    p_cl:    in  std_logic;
    p_sd_sg: out std_logic_vector(7 downto 0);
    p_sd_cs: out std_logic_vector(7 downto 0)
);
end entity e_top_sd;

architecture rtl of e_top_sd is
    signal s_cl_div: std_logic;

    signal s_ctr_q: std_logic_vector(2 downto 0);
    signal s_sg:    std_logic_vector(7 downto 0);
    signal s_cs:    std_logic_vector(7 downto 0);
begin
    l_ctr: entity work.c_ctr
    generic map (
        g_width => 3
    )
    port map (
        p_r  => '0',
        p_cl => p_cl,
        p_en => '1',
        p_q  => s_ctr_q
    );

    l_dc: entity work.c_dc
    generic map (
        g_width => 3
    )
    port map (
        p_d  => s_ctr_q,
        p_en => '1',
        p_q  => s_cs
    );

    l_div: entity work.c_div
    generic map (
        g_divide => 1_000
    )
    port map (
        p_d => p_cl,
        p_q => s_cl_div
    );

    process (s_ctr_q, p_ml, p_d, p_cs, s_cl_div) is
        variable v_ctr: natural;
    begin
        v_ctr := to_integer(unsigned(s_ctr_q));

        if p_ml = '0' then
            s_sg(0) <= '0';

            if p_cs(2 * v_ctr) = '1' then
                s_sg(1) <= p_d(2 * v_ctr) and s_cl_div;
                s_sg(2) <= s_cl_div;
            else
                s_sg(1) <= p_d(2 * v_ctr);
                s_sg(2) <= '1';
            end if;

            s_sg(3) <= '0';

            if p_cs(2 * v_ctr + 1) = '1' then
                s_sg(4) <= s_cl_div;
                s_sg(5) <= p_d(2 * v_ctr + 1) and s_cl_div;
            else
                s_sg(4) <= '1';
                s_sg(5) <= p_d(2 * v_ctr + 1);
            end if;

            s_sg(6) <= '0';

            if v_ctr < 4 then
                s_sg(7) <= '1';
            else
                s_sg(7) <= '0';
            end if;
        else
            s_sg(0) <= '0';

            if p_cs(16 + 2 * v_ctr) = '1' then
                s_sg(1) <= p_d(16 + 2 * v_ctr) and s_cl_div;
                s_sg(2) <= s_cl_div;
            else
                s_sg(1) <= p_d(16 + 2 * v_ctr);
                s_sg(2) <= '1';
            end if;

            s_sg(3) <= '0';

            if p_cs(16 + 2 * v_ctr + 1) = '1' then
                s_sg(4) <= s_cl_div;
                s_sg(5) <= p_d(16 + 2 * v_ctr + 1) and s_cl_div;
            else
                s_sg(4) <= '1';
                s_sg(5) <= p_d(16 + 2 * v_ctr + 1);
            end if;

            s_sg(6) <= '0';

            if v_ctr >= 4 then
                s_sg(7) <= '1';
            else
                s_sg(7) <= '0';
            end if;
        end if;
    end process;

    p_sd_sg <= not s_sg;
    p_sd_cs <= not s_cs;
end architecture rtl;
