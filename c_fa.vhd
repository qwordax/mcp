library ieee;

use ieee.std_logic_1164.all;

entity c_fa is
port (
    p_ci: in  std_logic;
    p_a:  in  std_logic;
    p_b:  in  std_logic;
    p_q:  out std_logic;
    p_co: out std_logic
);
end entity c_fa;

architecture rtl of c_fa is
    signal s_tmp: std_logic;
begin
    s_tmp <= p_a xor p_b;

    p_q  <= p_ci xor s_tmp;
    p_co <= (p_ci and s_tmp) or (p_a and p_b);
end architecture rtl;
