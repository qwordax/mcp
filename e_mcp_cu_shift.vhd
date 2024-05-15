library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_shift is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_shift;

architecture rtl of e_mcp_cu_shift is
    signal s_opd: std_logic_vector(31 downto 0);
    signal s_ops: std_logic_vector(31 downto 0);

    signal s_en: std_logic;
begin
    s_en <= p_cmd(11) or p_cmd(12) or p_cmd(13) or p_cmd(14) or p_cmd(15) or p_cmd(16);

    l_opd: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_opd,
        p_cl => p_ctrl(8), -- CU0
        p_en => s_en,
        p_q  => s_opd
    );

    l_ops: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_ops,
        p_cl => p_ctrl(8), -- CU0
        p_en => s_en,
        p_q  => s_ops
    );

    process (s_opd, s_ops, p_cmd) is
        variable v_tmp: integer := to_integer(unsigned(s_ops(4 downto 0)));

        variable v_sll: std_logic_vector(31 downto 0);
        variable v_srl: std_logic_vector(31 downto 0);
        variable v_sla: std_logic_vector(31 downto 0);
        variable v_sra: std_logic_vector(31 downto 0);
        variable v_rol: std_logic_vector(31 downto 0);
        variable v_ror: std_logic_vector(31 downto 0);
    begin
        v_sll(31 downto v_tmp) := s_opd(31 - v_tmp downto 0);
        v_sll(v_tmp - 1 downto 0) := (others => '0');

        v_srl(31 downto 31 - v_tmp + 1) := (others => '0');
        v_srl(31 - v_tmp downto 0) := s_opd(31 downto v_tmp);

        v_sla := v_sll;

        v_sra(31 downto 31 - v_tmp + 1) := (others => s_opd(31));
        v_sra(31 - v_tmp downto 0) := s_opd(31 downto v_tmp);

        v_rol(31 downto v_tmp) := s_opd(31 - v_tmp downto 0);
        v_rol(v_tmp - 1 downto 0) := s_opd(31 downto 31 - v_tmp + 1);

        v_ror(31 downto 31 - v_tmp + 1) := s_opd(v_tmp - 1 downto 0);
        v_ror(31 - v_tmp downto 0) := s_opd(31 downto v_tmp);

        if p_cmd(11) = '1' then
            p_q <= v_sll;
        elsif p_cmd(12) = '1' then
            p_q <= v_srl;
        elsif p_cmd(13) = '1' then
            p_q <= v_sll;
        elsif p_cmd(14) = '1' then
            p_q <= v_sra;
        elsif p_cmd(15) = '1' then
            p_q <= v_rol;
        elsif p_cmd(16) = '1' then
            p_q <= v_ror;
        else
            p_q <= (others => '0');
        end if;
    end process;
end architecture rtl;
