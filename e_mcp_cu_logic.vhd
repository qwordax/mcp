library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_logic is
port (
    p_a:   in  std_logic_vector(31 downto 0);
    p_b:   in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(37 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_logic;

architecture rtl of e_mcp_cu_logic is
begin
    process (p_a, p_b, p_cmd) is
    begin
        if p_cmd(3) = '1' then
            p_q <= not p_a;
        elsif p_cmd(4) = '1' then
            p_q <= p_a and p_b;
        elsif p_cmd(5) = '1' then
            p_q <= p_a or p_b;
        elsif p_cmd(6) = '1' then
            p_q <= p_a xor p_b;
        elsif p_cmd(7) = '1' then
            p_q <= p_a nand p_b;
        elsif p_cmd(8) = '1' then
            p_q <= p_a nor p_b;
        elsif p_cmd(9) = '1' then
            p_q <= p_a xnor p_b;
        else
            p_q <= "00000000000000000000000000000000";
        end if;
    end process;
end architecture rtl;
