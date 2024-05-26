library ieee;

use ieee.std_logic_1164.all;

entity c_div is
generic (
    g_width: natural
);
port (
    p_a:  in  std_logic_vector(g_width - 1 downto 0);
    p_b:  in  std_logic_vector(g_width / 2 - 1 downto 0);
    p_cl: in  std_logic;
    p_en: in  std_logic;
    p_q:  out std_logic_vector(g_width / 2 - 1 downto 0)
);
end entity c_div;

architecture rtl of c_div is
    subtype ctr_type is natural range 0 to g_width;

    signal s_a: std_logic;
    signal s_b: std_logic_vector(g_width / 2 - 1 downto 0);
    signal s_q: std_logic_vector(g_width / 2 - 1 downto 0);
    signal s_r: std_logic_vector(g_width / 2 - 1 downto 0);

    signal s_q_di: std_logic;
    signal s_q_d:  std_logic_vector(g_width / 2 - 1 downto 0);

    signal s_r_di: std_logic;
    signal s_r_d:  std_logic_vector(g_width / 2 - 1 downto 0);

    signal s_ff: std_logic;

    signal s_ps:   std_logic;
    signal s_ps_n: std_logic;

    signal s_sm_ci: std_logic;
    signal s_sm_a:  std_logic_vector(g_width / 2 - 1 downto 0);
    signal s_sm_b:  std_logic_vector(g_width / 2 - 1 downto 0);
    signal s_sm_q:  std_logic_vector(g_width / 2 - 1 downto 0);

    signal s_corr_ci: std_logic;
    signal s_corr_a:  std_logic_vector(g_width / 2 - 1 downto 0);
    signal s_corr_q:  std_logic_vector(g_width / 2 - 1 downto 0);
begin
    l_a: entity work.c_dff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_a(g_width - 1),
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_a
    );

    l_b: entity work.c_rg
    generic map (
        g_width => g_width / 2
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_b,
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_b
    );

    process (p_en, p_cl, p_a, s_r, s_b, s_sm_ci, s_q, s_sm_q) is
        variable v_ctr: ctr_type := 0;
    begin
        if p_en = '0' then
            v_ctr := 0;
        elsif p_cl'event and p_cl = '0' and p_en = '1' then
            if v_ctr < ctr_type'high then
                v_ctr := v_ctr + 1;
            else
                v_ctr := 0;
            end if;
        end if;

        if v_ctr = 0 or v_ctr mod 2 = 0 then
            s_ps <= '1';
        else
            s_ps <= '0';
        end if;

        if v_ctr < 2 then
            s_q_di <= s_r(g_width / 2 - 1) xor s_b(g_width / 2 - 1);
        else
            s_q_di <= s_sm_ci;
        end if;

        if v_ctr = 0 then
            s_q_d <= p_a(g_width / 2 - 1 downto 0);
            s_r_d <= p_a(g_width - 1 downto g_width / 2);
        else
            s_q_d <= s_q;
            s_r_d <= s_sm_q;
        end if;
    end process;

    s_ps_n <= not s_ps;

    l_q: entity work.c_srg
    generic map (
        g_width => g_width / 2
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_di => s_q_di,
        p_d  => s_q_d,
        p_ps => s_ps,
        p_lr => '1',
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_q
    );

    s_r_di <= s_q(g_width / 2 - 1);

    l_r: entity work.c_srg
    generic map (
        g_width => g_width / 2
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_di => s_r_di,
        p_d  => s_r_d,
        p_ps => s_ps,
        p_lr => '1',
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_r
    );

    l_ff: entity work.c_dff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => s_r(g_width / 2 - 1),
        p_cl => p_cl,
        p_en => s_ps_n,
        p_q  => s_ff
    );

    s_sm_ci <= s_ff xnor s_b(g_width / 2 - 1);
    s_sm_a  <= s_r;

    process (s_sm_ci, s_b) is
    begin
        if s_sm_ci = '1' then
            s_sm_b <= not s_b;
        else
            s_sm_b <= s_b;
        end if;
    end process;

    l_sm: entity work.c_sm
    generic map (
        g_width => g_width / 2
    )
    port map (
        p_ci => s_sm_ci,
        p_a  => s_sm_a,
        p_b  => s_sm_b,
        p_q  => s_sm_q,
        p_co => open,
        p_o  => open,
        p_u  => open
    );

    process (s_a, s_b, s_r) is
        variable v_r: std_logic := '0';
    begin
        for i in 0 to g_width / 2 - 1 loop
            v_r := v_r or s_r(i);
        end loop;

        if s_a = '0' and s_b(g_width / 2 - 1) = '1' then
            s_corr_ci <= '1';
        elsif s_a = '1' and s_b(g_width / 2 - 1) = '0' and v_r = '1' then
            s_corr_ci <= '1';
        elsif s_a = '1' and s_b(g_width / 2 - 1) = '1' and v_r = '0' then
            s_corr_ci <= '1';
        else
            s_corr_ci <= '0';
        end if;
    end process;

    s_corr_a <= s_q;

    l_corr: entity work.c_sm
    generic map (
        g_width => g_width / 2
    )
    port map (
        p_ci => s_corr_ci,
        p_a  => s_corr_a,
        p_b  => (others => '0'),
        p_q  => s_corr_q,
        p_co => open,
        p_o  => open,
        p_u  => open
    );

    p_q <= s_corr_q;
end architecture rtl;
