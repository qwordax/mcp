library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_shift is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_ops: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(36 downto 0);
    p_q:   out std_logic_vector(31 downto 0);
    p_fl:  out std_logic_vector(9 downto 1);
    p_ex:  out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu_shift;

architecture rtl of e_mcp_cu_shift is
    signal s_q: std_logic_vector(31 downto 0);
begin
--    process (p_opd, p_ops, p_cmd) is
--        variable v_tmp: integer := to_integer(unsigned(p_ops(4 downto 0)));
--
--        variable v_sll: std_logic_vector(31 downto 0);
--        variable v_srl: std_logic_vector(31 downto 0);
--        variable v_sla: std_logic_vector(31 downto 0);
--        variable v_sra: std_logic_vector(31 downto 0);
--        variable v_rol: std_logic_vector(31 downto 0);
--        variable v_ror: std_logic_vector(31 downto 0);
--    begin
--        v_sll(31 downto v_tmp) := p_opd(31 - v_tmp downto 0);
--        v_sll(v_tmp - 1 downto 0) := (others => '0');
--
--        v_srl(31 downto 31 - v_tmp + 1) := (others => '0');
--        v_srl(31 - v_tmp downto 0) := p_opd(31 downto v_tmp);
--
--        v_sla := v_sll;
--
--        v_sra(31 downto 31 - v_tmp + 1) := (others => p_opd(31));
--        v_sra(31 - v_tmp downto 0) := p_opd(31 downto v_tmp);
--
--        v_rol(31 downto v_tmp) := p_opd(31 - v_tmp downto 0);
--        v_rol(v_tmp - 1 downto 0) := p_opd(31 downto 31 - v_tmp + 1);
--
--        v_ror(31 downto 31 - v_tmp + 1) := p_opd(v_tmp - 1 downto 0);
--        v_ror(31 - v_tmp downto 0) := p_opd(31 downto v_tmp);
--
--        if p_cmd(11) = '1' then
--            s_q <= v_sll;
--        elsif p_cmd(12) = '1' then
--            s_q <= v_srl;
--        elsif p_cmd(13) = '1' then
--            s_q <= v_sll;
--        elsif p_cmd(14) = '1' then
--            s_q <= v_sra;
--        elsif p_cmd(15) = '1' then
--            s_q <= v_rol;
--        elsif p_cmd(16) = '1' then
--            s_q <= v_ror;
--        else
--            s_q <= (others => '0');
--        end if;
--    end process;

    s_q <= (others => '0');

    p_fl(1)          <= '1' when to_integer(unsigned(s_q(31 downto 0))) = 0 else '0';
    p_fl(2)          <= s_q(31);
    p_fl(9 downto 3) <= (others => '0');

    p_q <= s_q;
end architecture rtl;
