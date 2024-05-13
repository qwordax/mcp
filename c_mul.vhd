library ieee;

use ieee.std_logic_1164.all;

entity c_mul is
generic (
    g_width: natural
);
port (
    p_a:  in  std_logic_vector(g_width - 1 downto 0);
    p_b:  in  std_logic_vector(g_width - 1 downto 0);
    p_st: in  std_logic;
    p_cl: in  std_logic_vector(1 downto 0);
    p_q:  out std_logic_vector(2 * g_width - 1 downto 0);
    p_o:  out std_logic;
    p_u:  out std_logic
);
end entity c_mul;

architecture rtl of c_mul is
    subtype ctr_type is natural range 0 to g_width - 1;

    signal s_a: std_logic_vector(g_width - 1 downto 0);
    signal s_b: std_logic_vector(g_width - 1 downto 0);
    signal s_p: std_logic_vector(g_width - 1 downto 0);
    signal s_q: std_logic_vector(2 * g_width - 1 downto 0);

    signal s_sm_ci: std_logic;
    signal s_sm_a:  std_logic_vector(g_width - 1 downto 0);
    signal s_sm_b:  std_logic_vector(g_width - 1 downto 0);
    signal s_sm_q:  std_logic_vector(g_width - 1 downto 0);
    signal s_sm_co: std_logic;

    signal s_ff: std_logic;

    signal s_sd: std_logic;
begin
    l_a: entity work.c_rg
    generic map (
        g_width => g_width
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_a,
        p_cl => p_st,
        p_en => '1',
        p_q  => s_a
    );

    l_b: entity work.c_srg
    generic map (
        g_width => g_width
    )
    port map (
        p_r  => '0',
        p_s  => p_st,
        p_pd => p_b,
        p_sd => s_p(0),
        p_lr => '0',
        p_cl => p_cl(1),
        p_en => '1',
        p_q  => s_b
    );

    l_p: entity work.c_srg
    generic map (
        g_width => g_width
    )
    port map (
        p_r  => p_st,
        p_s  => p_cl(0),
        p_pd => s_sm_q,
        p_sd => s_sd,
        p_lr => '0',
        p_cl => p_cl(1),
        p_en => '1',
        p_q  => s_p
    );

    process (p_cl, s_b, s_p, s_ff) is
        variable v_ctr: ctr_type := 0;
    begin
        if p_st = '1' then
            v_ctr := 0;
        elsif p_cl(1)'event and p_cl(1) = '1' then
            if v_ctr = ctr_type'high then
                v_ctr := 0;
            else
                v_ctr := v_ctr + 1;
            end if;
        end if;

        if v_ctr = ctr_type'high and s_b(0) = '1' then
            s_sm_ci <= '1';
        else
            s_sm_ci <= '0';
        end if;

        if v_ctr = ctr_type'high then
            s_sd <= s_p(g_width - 1);
        else
            s_sd <= s_ff or s_p(g_width - 1);
        end if;
    end process;

    process (s_b, s_sm_ci) is
    begin
        if s_b(0) = '0' then
            s_sm_a <= (others => '0');
        else
            if s_sm_ci = '1' then
                s_sm_a <= not s_a;
            else
                s_sm_a <= s_a;
            end if;
        end if;
    end process;

    s_sm_b <= s_p;

    l_sm: entity work.c_sm
    generic map (
        g_width => g_width
    )
    port map (
        p_ci => s_sm_ci,
        p_a  => s_sm_a,
        p_b  => s_sm_b,
        p_q  => s_sm_q,
        p_co => s_sm_co,
        p_o  => open,
        p_u  => open
    );

    l_co: entity work.c_dff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => s_sm_co,
        p_cl => p_cl(0),
        p_en => '1',
        p_q  => s_ff
    );

    s_q <= s_p & s_b;

    process (s_q) is
        variable v_or:  std_logic := '0';
        variable v_and: std_logic := '1';
    begin
        for i in 2 * g_width - 2 downto g_width - 1 loop
            v_or  := v_or  or s_q(i);
            v_and := v_and and s_q(i);
        end loop;

        if s_q(2 * g_width - 1) = '0' then
            p_o <= s_q(2 * g_width - 1) xor v_or;
            p_u <= '0';
        else
            p_o <= '0';
            p_u <= s_q(2 * g_width - 1) xor v_and;
        end if;
    end process;

    p_q <= s_q;
end architecture rtl;
