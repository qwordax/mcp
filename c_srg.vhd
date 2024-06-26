library ieee;

use ieee.std_logic_1164.all;

entity c_srg is
generic (
    g_width: natural
);
port (
    p_r:  in  std_logic;
    p_s:  in  std_logic;
    p_di: in  std_logic;
    p_d:  in  std_logic_vector(g_width - 1 downto 0);
    p_ps: in  std_logic;
    p_lr: in  std_logic;
    p_cl: in  std_logic;
    p_en: in  std_logic;
    p_q:  out std_logic_vector(g_width - 1 downto 0)
);
end entity c_srg;

architecture rtl of c_srg is
begin
    process (p_r, p_s, p_cl, p_en) is
        variable v_tmp: std_logic_vector(g_width - 1 downto 0) := (others => '0');
    begin
        if p_r = '1' then
            v_tmp := (others => '0');
        elsif p_s = '1' then
            v_tmp := (others => '1');
        elsif p_cl'event and p_cl = '1' and p_en = '1' then
            if p_ps = '0' then
                if p_lr = '0' then
                    v_tmp := p_di & v_tmp(g_width - 1 downto 1);
                elsif p_lr = '1' then
                    v_tmp := v_tmp(g_width - 2 downto 0) & p_di;
                end if;
            else
                v_tmp := p_d;
            end if;
        end if;

        p_q <= v_tmp;
    end process;
end architecture rtl;
