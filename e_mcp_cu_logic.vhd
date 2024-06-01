library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_logic is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_ops: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(36 downto 0);
    p_q:   out std_logic_vector(31 downto 0);
    p_fl:  out std_logic_vector(9 downto 1);
    p_ex:  out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu_logic;

architecture rtl of e_mcp_cu_logic is
    signal s_q:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
begin
    s_en <= p_cmd(4) or p_cmd(5) or p_cmd(6) or p_cmd(7) or p_cmd(8) or p_cmd(9) or p_cmd(10);

    process (p_opd, p_ops, p_cmd) is
    begin
        if p_cmd(4) = '1' then -- NOT
            s_q <= not p_opd;
        elsif p_cmd(5) = '1' then -- AND
            s_q <= p_opd and p_ops;
        elsif p_cmd(6) = '1' then -- OR
            s_q <= p_opd or p_ops;
        elsif p_cmd(7) = '1' then -- XOR
            s_q <= p_opd xor p_ops;
        elsif p_cmd(8) = '1' then -- NAND
            s_q <= p_opd nand p_ops;
        elsif p_cmd(9) = '1' then -- NOR
            s_q <= p_opd nor p_ops;
        elsif p_cmd(10) = '1' then -- XNOR
            s_q <= p_opd xnor p_ops;
        else
            s_q <= (others => '0');
        end if;
    end process;

    p_fl(1)          <= '1' when to_integer(unsigned(s_q)) = 0 and s_en = '1' else '0';
    p_fl(2)          <= s_q(31) when s_en = '1' else '0';
    p_fl(9 downto 3) <= (others => '0');

    p_q <= s_q when s_en = '1' else (others => '0');

    p_ex <= "0000";
end architecture rtl;
