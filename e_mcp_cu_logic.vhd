library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_logic is
port (
    p_op0: in  std_logic_vector(31 downto 0);
    p_op1: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(37 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_logic;

architecture rtl of e_mcp_cu_logic is
begin
    process (p_op0, p_op1, p_cmd) is
    begin
        if p_cmd(3) = '1' then
            p_q <= not p_op0;
        elsif p_cmd(4) = '1' then
            p_q <= p_op0 and p_op1;
        elsif p_cmd(5) = '1' then
            p_q <= p_op0 or p_op1;
        elsif p_cmd(6) = '1' then
            p_q <= p_op0 xor p_op1;
        elsif p_cmd(7) = '1' then
            p_q <= p_op0 nand p_op1;
        elsif p_cmd(8) = '1' then
            p_q <= p_op0 nor p_op1;
        elsif p_cmd(9) = '1' then
            p_q <= p_op0 xnor p_op1;
        else
            p_q <= (others => '0');
        end if;
    end process;
end architecture rtl;
