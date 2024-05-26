library ieee;

use ieee.std_logic_1164.all;

entity c_dff is
port (
    p_r:  in  std_logic;
    p_s:  in  std_logic;
    p_d:  in  std_logic;
    p_cl: in  std_logic;
    p_en: in  std_logic;
    p_q:  out std_logic
);
end entity c_dff;

architecture rtl of c_dff is
begin
    process (p_r, p_s, p_cl, p_en) is
        variable v_tmp: std_logic := '0';
    begin
        if p_r = '1' then
            v_tmp := '0';
        elsif p_s = '1' then
            v_tmp := '1';
        elsif p_cl'event and p_cl = '1' and p_en = '1' then
            v_tmp := p_d;
        end if;

        p_q <= v_tmp;
    end process;
end architecture rtl;
