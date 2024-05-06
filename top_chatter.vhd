library ieee;

use ieee.std_logic_1164.all;

entity top_chatter is
generic (
    width: natural
);
port (
    d:  in  std_logic;
    cl: in  std_logic;
    q:  out std_logic
);
end entity top_chatter;

architecture rtl of top_chatter is
begin
    process (d, cl) is
        variable v_tmp: natural range 0 to 2 ** width - 1;
    begin
        if cl'event and cl = '1' then
            if d = '0' and v_tmp > v_tmp'low then
                v_tmp := v_tmp - 1;
            elsif d = '1' and v_tmp < v_tmp'high then
                v_tmp := v_tmp + 1;
            end if;

            if v_tmp = v_tmp'low then
                q <= '0';
            elsif v_tmp = v_tmp'high then
                q <= '1';
            end if;
        end if;
    end process;
end architecture rtl;
