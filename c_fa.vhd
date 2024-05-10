library ieee;

use ieee.std_logic_1164.all;

entity c_fa is
port (
    p_ci: in  std_logic;
    p_a:  in  std_logic;
    p_b:  in  std_logic;
    p_s:  out std_logic;
    p_co: out std_logic
);
end entity c_fa;

architecture rtl of c_fa is
    signal s_a: std_logic_vector(1 downto 0);
    signal s_b: std_logic_vector(1 downto 0);
    signal s_s: std_logic_vector(1 downto 0);
    signal s_c: std_logic_vector(1 downto 0);
begin
    s_a(0) <= p_a;
    s_b(0) <= p_b;

    s_s(0) <= s_a(0) xor s_b(0);
    s_c(0) <= s_a(0) and s_b(0);

    s_a(1) <= s_c(0);
    s_b(1) <= p_ci;

    s_s(1) <= s_a(1) xor s_b(1);
    s_c(1) <= s_a(1) and s_b(1);

    p_s  <= s_s(1);
    p_co <= s_c(1);
end architecture rtl;
