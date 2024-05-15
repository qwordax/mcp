library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_f_abs is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_f_abs;

architecture rtl of e_mcp_cu_f_abs is
begin
    p_q <= '0' & p_opd(30 downto 0);
end architecture rtl;
