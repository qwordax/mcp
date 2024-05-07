library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity c_ctr is
generic (
    width: natural
);
port (
    r:  in  std_logic;
    cl: in  std_logic;
    en: in  std_logic;
    q:  out std_logic_vector(width - 1 downto 0)
);
end entity c_ctr;

architecture rtl of c_ctr is
begin
    process (r, cl) is
        variable v_tmp: std_logic_vector(width - 1 downto 0) := (others => '0');
    begin
        if r = '1' then
            v_tmp := (others => '0');
        elsif cl'event and cl = '1' and en = '1' then
            v_tmp := v_tmp + 1;
        end if;

        q <= v_tmp;
    end process;
end architecture rtl;
