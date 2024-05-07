library ieee;

use ieee.std_logic_1164.all;

entity top_in is
port (
    r:  in  std_logic;
    s:  in  std_logic;
    en: in  std_logic;
    q:  out std_logic_vector(31 downto 0);
    cs: out std_logic_vector(31 downto 0);
    lh: out std_logic
);
end entity top_in;

architecture rtl of top_in is
    component c_ctr is
    generic (
        width: natural
    );
    port (
        r:  in  std_logic;
        cl: in  std_logic;
        en: in  std_logic;
        q:  out std_logic_vector(width - 1 downto 0)
    );
    end component c_ctr;

    component c_dc is
    generic (
        width: natural
    );
    port (
        d:  in  std_logic_vector(width - 1 downto 0);
        en: in  std_logic;
        q:  out std_logic_vector(2 ** width - 1 downto 0)
    );
    end component c_dc;

    component c_dff is
    port (
        r:  in  std_logic;
        s:  in  std_logic;
        d:  in  std_logic;
        cl: in  std_logic;
        en: in  std_logic;
        q:  out std_logic
    );
    end component c_dff;

    signal s_en_p: std_logic;
    signal s_en_n: std_logic;

    signal s_ctr_cl: std_logic;
    signal s_ctr_q:  std_logic_vector(4 downto 0);

    signal s_dc_q: std_logic_vector(31 downto 0);

    signal s_ff_r: std_logic_vector(31 downto 0);
    signal s_ff_s: std_logic_vector(31 downto 0);
begin
    s_en_p <= en;
    s_en_n <= not en;

    s_ctr_cl <= r nor s;

    ctr: component c_ctr
    generic map (
        width => 5
    )
    port map (
        r  => s_en_n,
        cl => s_ctr_cl,
        en => s_en_p,
        q  => s_ctr_q
    );

    dc: component c_dc
    generic map (
        width => 5
    )
    port map (
        d  => s_ctr_q,
        en => s_en_p,
        q  => s_dc_q
    );

    cs <= s_dc_q;
    lh <= s_ctr_q(4);

    input: for i in 0 to 31 generate
        s_ff_r(i) <= r and s_dc_q(i);
        s_ff_s(i) <= s and s_dc_q(i);

        ff: component c_dff
        port map (
            r  => s_ff_r(i),
            s  => s_ff_s(i),
            d  => '0',
            cl => '0',
            en => '0',
            q  => q(i)
        );
    end generate input;
end architecture rtl;
