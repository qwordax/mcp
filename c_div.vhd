library ieee;

use ieee.std_logic_1164.all;

entity c_div is
generic (
    divide: natural
);
port (
    d: in  std_logic;
    q: out std_logic
);
end entity c_div;

architecture rtl of c_div is
    signal s_q: std_logic := '0';
begin
    process (d) is
        variable v_tmp: natural range 0 to divide - 1;
    begin
        if d'event and d = '1' then
            if v_tmp = v_tmp'high then
                s_q <= not s_q; v_tmp := 0;
            else
                v_tmp := v_tmp + 1;
            end if;
        end if;
    end process;

    q <= s_q;
end architecture rtl;
