library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity c_dc is
generic (
    g_width: natural
);
port (
    p_d:  in  std_logic_vector(g_width - 1 downto 0);
    p_en: in  std_logic;
    p_q:  out std_logic_vector(2 ** g_width - 1 downto 0)
);
end entity c_dc;

architecture rtl of c_dc is
begin
    process (p_d, p_en) is
    begin
        p_q <= (others => '0');

        if p_en = '1' then
            p_q(to_integer(unsigned(p_d))) <= '1';
        end if;
    end process;
end architecture rtl;
