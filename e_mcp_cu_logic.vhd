library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_logic is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_ops: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(36 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_logic;

architecture rtl of e_mcp_cu_logic is
begin
    process (p_opd, p_ops, p_cmd) is
    begin
        if p_cmd(3) = '1' then
            p_q <= not p_opd;
        elsif p_cmd(4) = '1' then
            p_q <= p_opd and p_ops;
        elsif p_cmd(5) = '1' then
            p_q <= p_opd or p_ops;
        elsif p_cmd(6) = '1' then
            p_q <= p_opd xor p_ops;
        elsif p_cmd(7) = '1' then
            p_q <= p_opd nand p_ops;
        elsif p_cmd(8) = '1' then
            p_q <= p_opd nor p_ops;
        elsif p_cmd(9) = '1' then
            p_q <= p_opd xnor p_ops;
        else
            p_q <= (others => '0');
        end if;
    end process;
end architecture rtl;
