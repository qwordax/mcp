library ieee;

use ieee.std_logic_1164.all;

entity c_bn is
generic (
    g_width: natural
);
port (
    p_d:  in  std_logic;
    p_cl: in  std_logic;
    p_q:  out std_logic
);
end entity c_bn;

architecture rtl of c_bn is
begin
    process (p_d, p_cl) is
        variable v_tmp: natural range 0 to 2 ** width - 1;
    begin
        if p_cl'event and p_cl = '1' then
            if p_d = '0' and v_tmp > v_tmp'low then
                v_tmp := v_tmp - 1;
            elsif d = '1' and v_tmp < v_tmp'high then
                v_tmp := v_tmp + 1;
            end if;

            if v_tmp = v_tmp'low then
                p_q <= '0';
            elsif v_tmp = v_tmp'high then
                p_q <= '1';
            end if;
        end if;
    end process;
end architecture rtl;
