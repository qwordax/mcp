library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_shift is
port (
    p_op0: in  std_logic_vector(31 downto 0);
    p_op1: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(37 downto 0);
    p_q:   out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_shift;

architecture rtl of e_mcp_cu_shift is
begin
    process (p_op0, p_op1, p_cmd) is
        variable v_tmp: integer := to_integer(unsigned(p_op1(4 downto 0)));

        variable v_sll: std_logic_vector(31 downto 0);
        variable v_srl: std_logic_vector(31 downto 0);
        variable v_sla: std_logic_vector(31 downto 0);
        variable v_sra: std_logic_vector(31 downto 0);
        variable v_rol: std_logic_vector(31 downto 0);
        variable v_ror: std_logic_vector(31 downto 0);
    begin
--        for i in 0 to  loop
--            v_sll := v_sll(30 downto 0) & '0';
--            v_srl := '0' & v_srl(31 downto 1);
--            v_sra := v_sra(31) & v_sra(31 downto 1);
--            v_rol := v_rol(30 downto 0) & v_rol(31);
--            v_ror := v_ror(0) & v_ror(31 downto 1);
--        end loop;
--        v_sll :=  & ;
--        v_srl :=  & ;
--
--        if v_sra(31) = '1' then
--            v_sra := v_srl(31 downto to_integer(unsigned(p_a(4 downto 0))));
--        else
--            v_sra := v_srl;
--        end if;
--
--        v_rol := v_rol(31 - to_integer(unsigned(p_a(4 downto 0))) downto 0) & v_rol(31 downto 31 - to_integer(unsigned(p_a(4 downto 0))) + 1);
--        v_ror := v_ror(to_integer(unsigned(p_a(4 downto 0))) - 1 downto 0) & v_ror(31 downto to_integer(unsigned(p_a(4 downto 0))));

        v_sll(31 downto v_tmp) := p_op0(31 - v_tmp downto 0);
        v_sll(v_tmp - 1 downto 0) := (others => '0');

        v_srl(31 downto 31 - v_tmp + 1) := (others => '0');
        v_srl(31 - v_tmp downto 0) := p_op0(31 downto v_tmp);

        v_sla := v_sll;

        v_sra(31 downto 31 - v_tmp + 1) := (others => p_op0(31));
        v_sra(31 - v_tmp downto 0) := p_op0(31 downto v_tmp);

        v_rol(31 downto v_tmp) := p_op0(31 - v_tmp downto 0);
        v_rol(v_tmp - 1 downto 0) := p_op0(31 downto 31 - v_tmp + 1);

        v_ror(31 downto 31 - v_tmp + 1) := p_op0(v_tmp - 1 downto 0);
        v_ror(31 - v_tmp downto 0) := p_op0(31 downto v_tmp);

        if p_cmd(10) = '1' then
            p_q <= v_sll;
        elsif p_cmd(11) = '1' then
            p_q <= v_srl;
        elsif p_cmd(12) = '1' then
            p_q <= v_sll;
        elsif p_cmd(13) = '1' then
            p_q <= v_sra;
        elsif p_cmd(14) = '1' then
            p_q <= v_rol;
        elsif p_cmd(15) = '1' then
            p_q <= v_ror;
        else
            p_q <= (others => '0');
        end if;
    end process;
end architecture rtl;
