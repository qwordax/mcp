library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity c_comp is
generic (
    g_width: natural
);
port (
    p_a: in  std_logic_vector(31 downto 0);
    p_b: in  std_logic_vector(31 downto 0);
    p_l: out std_logic;
    p_e: out std_logic;
    p_g: out std_logic
);
end entity c_comp;

architecture rtl of c_comp is
begin
    p_l <= '1' when p_a < p_b else '0';
    p_e <= '1' when p_a = p_b else '0';
    p_g <= '1' when p_a > p_b else '0';
end architecture rtl;
