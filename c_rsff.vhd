library ieee;

use ieee.std_logic_1164.all;

entity c_rsff is
port (
    r: in  std_logic;
    s: in  std_logic;
    q: out std_logic
);
end entity c_rsff;

architecture rtl of c_rsff is
begin
    process (r, s) is
        variable v_tmp: std_logic := '0';
    begin
        if r = '1' then
            v_tmp := '0';
        elsif s = '1' then
            v_tmp := '1';
        end if;

        q <= v_tmp;
    end process;
end architecture rtl;
