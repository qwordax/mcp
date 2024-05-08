library ieee;

use ieee.std_logic_1164.all;

entity e_top_in is
port (
    p_r:  in  std_logic;
    p_s:  in  std_logic;
    p_en: in  std_logic;
    p_q:  out std_logic_vector(31 downto 0);
    p_cs: out std_logic_vector(31 downto 0);
    p_ml: out std_logic
);
end entity e_top_in;

architecture rtl of e_top_in is
    signal s_ctr_cl: std_logic;
    signal s_ctr_q:  std_logic_vector(4 downto 0);

    signal s_dc_q: std_logic_vector(31 downto 0);

    signal s_r: std_logic_vector(31 downto 0);
    signal s_s: std_logic_vector(31 downto 0);
begin
    s_ctr_cl <= p_r nor p_s;

    l_ctr: entity work.c_ctr
    generic map (
        g_width => 5
    )
    port map (
        p_r  => not p_en,
        p_cl => s_ctr_cl,
        p_en => p_en,
        p_q  => s_ctr_q
    );

    l_dc: entity work.c_dc
    generic map (
        g_width => 5
    )
    port map (
        p_d  => s_ctr_q,
        p_en => p_en,
        p_q  => s_dc_q
    );

    p_cs <= s_dc_q;
    p_ml <= s_ctr_q(4);

    l_in: for i in 0 to 31 generate
        s_r(i) <= p_r and s_dc_q(i);
        s_s(i) <= p_s and s_dc_q(i);

        l_dff: entity work.c_dff
        port map (
            p_r  => s_r(i),
            p_s  => s_s(i),
            p_d  => '0',
            p_cl => '0',
            p_en => '0',
            p_q  => p_q(i)
        );
    end generate l_in;
end architecture rtl;
