library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity c_comp is
generic (
    g_width: natural
);
port (
    p_a:  in  std_logic_vector(g_width - 1 downto 0);
    p_b:  in  std_logic_vector(g_width - 1 downto 0);
    p_en: in  std_logic;
    p_l:  out std_logic;
    p_e:  out std_logic;
    p_g:  out std_logic
);
end entity c_comp;

architecture rtl of c_comp is
begin
    p_l <= '1' when signed(p_a) < signed(p_b) and p_en = '1' else '0';
    p_e <= '1' when signed(p_a) = signed(p_b) and p_en = '1' else '0';
    p_g <= '1' when signed(p_a) > signed(p_b) and p_en = '1' else '0';
end architecture rtl;
