library ieee;

use ieee.std_logic_1164.all;

entity top is
port (
    key:    in  std_logic_vector(3 downto 0);
    sw:     in  std_logic_vector(7 downto 0);
    cl:     in  std_logic;
    led:    out std_logic_vector(11 downto 0)
--    sd_sg:  out std_logic_vector(7 downto 0);
--    sd_cs:  out std_logic_vector(7 downto 0);
--    lcd_rs: out std_logic;
--    lcd_rw: out std_logic;
--    lcd_en: out std_logic;
--    lcd_d:  out std_logic_vector(7 downto 0)
);
end entity top;

architecture rtl of top is
    component c_chatter is
    generic (
        width: natural
    );
    port (
        d:  in  std_logic;
        cl: in  std_logic;
        q:  out std_logic
    );
    end component c_chatter;

    component c_div is
    generic (
        divide: natural
    );
    port (
        d: in  std_logic;
        q: out std_logic
    );
    end component c_div;

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

    component top_ctrl is
    port (
        u:  in  std_logic;
        d:  in  std_logic;
        cl: in  std_logic;
        q:  out std_logic_vector(5 downto 0)
    );
    end component top_ctrl;

    signal s_key: std_logic_vector(3 downto 0);
    signal s_sw:  std_logic_vector(7 downto 0);

    signal s_cldiv: std_logic;

    signal s_op: std_logic_vector(5 downto 0);
    signal s_rs: std_logic_vector(2 downto 0);
    signal s_rd: std_logic_vector(2 downto 0);
begin
    key_ch: for i in 0 to 3 generate
        chatter: component c_chatter
        generic map (
            width => 20
        )
        port map (
            d  => not key(i),
            cl => cl,
            q  => s_key(i)
        );
    end generate key_ch;

    sw_ch: for i in 0 to 7 generate
        chatter: component c_chatter
        generic map (
            width => 4
        )
        port map (
            d  => not sw(i),
            cl => cl,
            q  => s_sw(i)
        );
    end generate sw_ch;

    div: component c_div
    generic map (
        divide => 12_500_000
    )
    port map (
        d => cl,
        q => s_cldiv
    );

    ctrl: component top_ctrl
    port map (
        u  => s_key(0),
        d  => s_key(1),
        cl => s_cldiv,
        q  => s_op
    );

    rs: component c_ctr
    generic map (
        width => 3
    )
    port map (
        r  => '0',
        cl => s_cldiv,
        en => s_key(2),
        q  => s_rs
    );

    rd: component c_ctr
    generic map (
        width => 3
    )
    port map (
        r  => '0',
        cl => s_cldiv,
        en => s_key(3),
        q  => s_rd
    );

    led(5 downto 0)  <= not s_op;
    led(8 downto 6)  <= not s_rs;
    led(11 downto 9) <= not s_rd;
end architecture rtl;
