library ieee;

use ieee.std_logic_1164.all;

entity c_mul is
generic (
    g_width: natural
);
port (
    p_a:  in  std_logic_vector(g_width - 1 downto 0);
    p_b:  in  std_logic_vector(g_width - 1 downto 0);
    p_cl: in  std_logic;
    p_en: in  std_logic;
    p_q:  out std_logic_vector(2 * g_width - 1 downto 0)
);
end entity c_mul;

architecture rtl of c_mul is
    subtype ctr_type is natural range 0 to 2 * g_width;
    subtype ci_type  is natural range 0 to g_width;

    signal s_a: std_logic_vector(g_width - 1 downto 0);
    signal s_b: std_logic_vector(g_width - 1 downto 0);
    signal s_p: std_logic_vector(g_width - 1 downto 0);

    signal s_b_d: std_logic_vector(g_width - 1 downto 0);
    signal s_p_d: std_logic_vector(g_width - 1 downto 0);

    signal s_ps: std_logic;

    signal s_sm_ci: std_logic;
    signal s_sm_a:  std_logic_vector(g_width - 1 downto 0);
    signal s_sm_b:  std_logic_vector(g_width - 1 downto 0);
    signal s_sm_q:  std_logic_vector(g_width - 1 downto 0);
    signal s_sm_co: std_logic;

    signal s_co_r: std_logic;
    signal s_co_q: std_logic;

    signal s_di: std_logic;
begin
    process (p_en, p_cl, p_b, s_b, s_sm_q) is
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

        if v_ctr = 0 or v_ctr mod 2 /= 0 then
            s_ps <= '1';
        else
            s_ps <= '0';
        end if;

        if v_ctr = ctr_type'high - 1 and s_b(0) = '1' then
            s_sm_ci <= '1';
        else
            s_sm_ci <= '0';
        end if;

        if v_ctr = 0 then
            s_b_d <= p_b;
            s_p_d <= (others => '0');
        else
            s_b_d <= s_b;
            s_p_d <= s_sm_q;
        end if;

        if v_ctr < ctr_type'high then
            s_di <= s_co_q or s_p(g_width - 1);
        else
            s_di <= s_p(g_width - 1);
        end if;
    end process;

    l_a: entity work.c_rg
    generic map (
        g_width => g_width
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_a,
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_a
    );

    l_b: entity work.c_srg
    generic map (
        g_width => g_width
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_di => s_p(0),
        p_d  => s_b_d,
        p_ps => s_ps,
        p_lr => '0',
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_b
    );

    l_p: entity work.c_srg
    generic map (
        g_width => g_width
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_di => s_di,
        p_d  => s_p_d,
        p_ps => s_ps,
        p_lr => '0',
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_p
    );

--    process (p_en, p_cl, s_ps) is
--        variable v_ctr: ci_type := 0;
--    begin
--        if p_en = '0' then
--            v_ctr := 0;
--        elsif p_cl'event and p_cl = '1' and s_ps = '0' then
--            if v_ctr < ci_type'high then
--                v_ctr := v_ctr + 1;
--            else
--                v_ctr := 0;
--            end if;
--        end if;
--
--        if v_ctr = ci_type'high - 1 and s_b(0) = '1' then
--            s_sm_ci <= '1';
--        else
--            s_sm_ci <= '0';
--        end if;
--    end process;

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

    s_co_r <= not p_en;

    l_co: entity work.c_dff
    port map (
        p_r  => s_co_r,
        p_s  => '0',
        p_d  => s_sm_co,
        p_cl => p_cl,
        p_en => s_ps,
        p_q  => s_co_q
    );

    p_q <= s_p & s_b;
end architecture rtl;
