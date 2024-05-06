library ieee;

use ieee.std_logic_1164.all;

entity c_dff is
port (
    r:  in  std_logic;
    s:  in  std_logic;
    d:  in  std_logic;
    cl: in  std_logic;
    en: in  std_logic;
    q:  out std_logic
);
end entity c_dff;

architecture rtl of c_dff is
begin
    process (r, s, cl) is
        variable v_tmp: std_logic := '0';
    begin
        if r = '1' then
            v_tmp := '0';
        elsif s = '1' then
            v_tmp := '1';
        elsif cl'event and cl = '1' and en = '1' then
            v_tmp := d;
        end if;

        q <= v_tmp;
    end process;
end architecture rtl;
