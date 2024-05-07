library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity top_sd is
port (
    d:  in  std_logic_vector(31 downto 0);
    lh: in  std_logic;
    cl: in  std_logic;
    sg: out std_logic_vector(7 downto 0);
    cs: out std_logic_vector(7 downto 0)
);
end entity top_sd;

architecture rtl of top_sd is
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

    signal s_ctr_q: std_logic_vector(2 downto 0);
    signal s_sg:    std_logic_vector(7 downto 0);
    signal s_cs:    std_logic_vector(7 downto 0);
begin
    ctr: component c_ctr
    generic map (
        width => 3
    )
    port map (
        r  => '0',
        cl => cl,
        en => '1',
        q  => s_ctr_q
    );

    dc: component c_dc
    generic map (
        width => 3
    )
    port map (
        d  => s_ctr_q,
        en => '1',
        q  => s_cs
    );

    process (s_ctr_q, lh) is
        variable v_ctr: natural;
    begin
        v_ctr := to_integer(unsigned(s_ctr_q));

        if lh = '0' then
            s_sg(0) <= '0';
            s_sg(1) <= d(2 * v_ctr);
            s_sg(2) <= '1';
            s_sg(3) <= '0';
            s_sg(4) <= '1';
            s_sg(5) <= d(2 * v_ctr + 1);
            s_sg(6) <= '0';

            if v_ctr < 4 then
                s_sg(7) <= '1';
            else
                s_sg(7) <= '0';
            end if;
        else
            s_sg(0) <= '0';
            s_sg(1) <= d(16 + 2 * v_ctr);
            s_sg(2) <= '1';
            s_sg(3) <= '0';
            s_sg(4) <= '1';
            s_sg(5) <= d(16 + 2 * v_ctr + 1);
            s_sg(6) <= '0';

            if v_ctr >= 4 then
                s_sg(7) <= '1';
            else
                s_sg(7) <= '0';
            end if;
        end if;
    end process;

    sg <= not s_sg;
    cs <= not s_cs;
end architecture rtl;
