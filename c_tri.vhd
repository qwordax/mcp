library ieee;

use ieee.std_logic_1164.all;

entity c_tri is
generic (
    g_width: natural
);
port (
    p_d:  in  std_logic_vector(g_width - 1 downto 0);
    p_en: in  std_logic;
    p_q:  out std_logic_vector(g_width - 1 downto 0)
);
end entity c_tri;

architecture rtl of c_tri is
begin
    p_q <= p_d when p_en = '1' else (others => 'Z');
end architecture rtl;
