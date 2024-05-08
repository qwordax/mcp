library ieee;

use ieee.std_logic_1164.all;

entity e_top_mode is
port (
    p_sw:   in  std_logic_vector(1 downto 0);
    p_mode: out std_logic_vector(2 downto 0)
);
end entity e_top_mode;

architecture rtl of e_top_mode is
begin
    p_mode(0) <= '1' when p_sw = "00" or p_sw = "10" else '0';
    p_mode(1) <= '1' when p_sw = "01" else '0';
    p_mode(2) <= '1' when p_sw = "11" else '0';
end architecture rtl;
