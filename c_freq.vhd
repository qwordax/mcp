library ieee;

use ieee.std_logic_1164.all;

entity c_freq is
generic (
    g_divide: natural
);
port (
    p_d: in  std_logic;
    p_q: out std_logic
);
end entity c_freq;

architecture rtl of c_freq is
    subtype tmp_type is natural range 0 to g_divide - 1;

    signal s_q: std_logic := '0';
begin
    process (p_d) is
        variable v_tmp: tmp_type;
    begin
        if p_d'event and p_d = '1' then
            if v_tmp = tmp_type'high then
                s_q <= not s_q; v_tmp := 0;
            else
                v_tmp := v_tmp + 1;
            end if;
        end if;
    end process;

    p_q <= s_q;
end architecture rtl;
