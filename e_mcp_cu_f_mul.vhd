library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_f_mul is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_cl:   in  std_logic;
    p_ctrl: in  std_logic_vector(13 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_fl:   out std_logic_vector(9 downto 1);
    p_ex:   out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu_f_mul;

architecture rtl of e_mcp_cu_f_mul is
begin
    p_q  <= (others => '0');
    p_fl <= (others => '0');
    p_ex <= (others => '0');
end architecture rtl;
