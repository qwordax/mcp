library ieee;

use ieee.std_logic_1164.all;

entity e_mcp is
port (
    p_op: in  std_logic_vector(5 downto 0);
    p_rs: in  std_logic_vector(2 downto 0);
    p_rd: in  std_logic_vector(2 downto 0);
    p_d:  in  std_logic_vector(31 downto 0);
    p_st: in  std_logic;
    p_cl: in  std_logic;
    p_q:  out std_logic_vector(31 downto 0);
    p_f:  out std_logic_vector(9 downto 0)
);
end entity e_mcp;

architecture rtl of e_mcp is
begin

end architecture rtl;
