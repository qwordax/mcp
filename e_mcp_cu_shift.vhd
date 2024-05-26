library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_shift is
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
end entity e_mcp_cu_shift;

architecture rtl of e_mcp_cu_shift is
    signal s_q:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
begin
    s_en <= p_cmd(11) or p_cmd(12) or p_cmd(13) or p_cmd(14) or p_cmd(15) or p_cmd(16);

    process (p_cl, p_ctrl, p_cmd) is
        variable v_tmp:  std_logic_vector(31 downto 0) := (others => '0');
        variable v_next: std_logic_vector(31 downto 0) := (others => '0');
    begin
        if p_cl'event and p_cl = '1' and p_ctrl(9) = '1' then -- CU1
            v_tmp := p_opd;
        end if;

        if p_cmd(11) = '1' then -- SLL
            v_next := v_tmp(30 downto 0) & '0';
        elsif p_cmd(12) = '1' then -- SRL
            v_next := '0' & v_tmp(31 downto 1);
        elsif p_cmd(13) = '1' then -- SLA
            v_next := v_tmp(30 downto 0) & '0';
        elsif p_cmd(14) = '1' then -- SRA
            v_next := v_tmp(31) & v_tmp(31 downto 1);
        elsif p_cmd(15) = '1' then -- ROL
            v_next := v_tmp(30 downto 0) & v_tmp(31);
        elsif p_cmd(16) = '1' then -- ROR
            v_next := v_tmp(0) & v_tmp(31 downto 1);
        else
            v_next := v_tmp;
        end if;

        if p_cl'event and p_cl = '1' and p_ctrl(10) = '1' then -- CU2
            v_tmp := v_next;
        end if;

        s_q <= v_tmp;
    end process;

    process (p_cl, p_ctrl, s_en) is
        variable v_ctr: integer := 0;
    begin
        if p_cl'event and p_cl = '1' and p_ctrl(9) = '1' and s_en = '1' then -- CU1
            v_ctr := to_integer(unsigned(p_ops(5 downto 0)));
        elsif p_cl'event and p_cl = '1' and p_ctrl(10) = '1' and s_en = '1' then -- CU2
            v_ctr := v_ctr - 1;
        end if;

        if v_ctr /= 0 and s_en = '1' then
            p_ex(1) <= '1';
        else
            p_ex(1) <= '0';
        end if;
    end process;

    p_q <= s_q when s_en = '1' else (others => '0');

    p_fl(1)          <= '1' when to_integer(unsigned(s_q(31 downto 0))) = 0 and s_en = '1' else '0';
    p_fl(2)          <= s_q(31) when s_en = '1' else '0';
    p_fl(9 downto 3) <= (others => '0');

    p_ex(0) <= '0';
    p_ex(2) <= '0';
    p_ex(3) <= '0';
end architecture rtl;
