library ieee;

use ieee.std_logic_1164.all;

entity c_div is
generic (
    g_width: natural
);
port (
    p_a:  in  std_logic_vector(g_width - 1 downto 0);
    p_b:  in  std_logic_vector(g_width - 1 downto 0);
    p_cl: in  std_logic;
    p_en: in  std_logic;
    p_q:  out std_logic_vector(g_width - 1 downto 0)
);
end entity c_div;

architecture rtl of c_div is
    subtype ctr_type is natural range 0 to 2 * g_width;

    signal s_chs_a: std_logic_vector(g_width - 1 downto 0);
    signal s_chs_b: std_logic_vector(g_width - 1 downto 0);

    signal s_b: std_logic_vector(g_width - 1 downto 0);
    signal s_q: std_logic_vector(g_width - 1 downto 0);
    signal s_r: std_logic_vector(2 * g_width - 1 downto 0);

    signal s_q_di: std_logic;
    signal s_q_en: std_logic;

    signal s_r_d:  std_logic_vector(2 * g_width - 1 downto 0);
    signal s_r_ps:   std_logic;

    signal s_sm_a:  std_logic_vector(g_width downto 0);
    signal s_sm_b:  std_logic_vector(g_width downto 0);
    signal s_sm_q:  std_logic_vector(g_width downto 0);

    signal s_q_np: std_logic;
begin
    l_chs_a: entity work.c_chs
    generic map (
        g_width => g_width
    )
    port map (
        p_d  => p_a,
        p_np => '0',
        p_q  => s_chs_a
    );

    l_chs_b: entity work.c_chs
    generic map (
        g_width => g_width
    )
    port map (
        p_d  => p_b,
        p_np => '0',
        p_q  => s_chs_b
    );

    l_b: entity work.c_rg
    generic map (
        g_width => g_width
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => s_chs_b,
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_b
    );

    process (p_en, p_cl, s_chs_a, s_sm_q, s_r) is
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
            s_r_ps <= '1';
        else
            s_r_ps <= '0';
        end if;

        if v_ctr > 0 and v_ctr mod 2 = 0 then
            s_q_en <= '1';
        else
            s_q_en <= '0';
        end if;

        if v_ctr = 0 then
            s_r_d(2 * g_width - 1 downto g_width) <= (others => '0');
            s_r_d(g_width - 1 downto 0) <= s_chs_a;
        else
            if s_sm_q(g_width) = '1' then
                s_r_d(2 * g_width - 1 downto g_width) <= s_r(2 * g_width - 1 downto g_width);
            else
                s_r_d(2 * g_width - 1 downto g_width) <= s_sm_q(g_width - 1 downto 0);
            end if;

            s_r_d(g_width - 1 downto 0) <= s_r(g_width - 1 downto 0);
        end if;
    end process;

    s_q_di <= not s_sm_q(g_width);

    l_q: entity work.c_srg
    generic map (
        g_width => g_width
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_di => s_q_di,
        p_d  => (others => '0'),
        p_ps => '0',
        p_lr => '1',
        p_cl => p_cl,
        p_en => s_q_en,
        p_q  => s_q
    );

    l_r: entity work.c_srg
    generic map (
        g_width => 2 * g_width
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_di => '0',
        p_d  => s_r_d,
        p_ps => s_r_ps,
        p_lr => '1',
        p_cl => p_cl,
        p_en => p_en,
        p_q  => s_r
    );

    s_sm_a  <= '0' & s_r(2 * g_width - 1 downto g_width);
    s_sm_b  <= '1' & not s_b;

    l_sm: entity work.c_sm
    generic map (
        g_width => g_width + 1
    )
    port map (
        p_ci => '1',
        p_a  => s_sm_a,
        p_b  => s_sm_b,
        p_q  => s_sm_q,
        p_co => open,
        p_o  => open,
        p_u  => open
    );

    s_q_np <= p_a(g_width - 1) xor p_b(g_width - 1);

    l_chs_q: entity work.c_chs
    generic map (
        g_width => g_width
    )
    port map (
        p_d  => s_q,
        p_np => s_q_np,
        p_q  => p_q
    );
end architecture rtl;
