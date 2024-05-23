library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_f_comp is
port (
    p_opd: in  std_logic_vector(31 downto 0);
    p_ops: in  std_logic_vector(31 downto 0);
    p_cmd: in  std_logic_vector(36 downto 0);
    p_q:   out std_logic_vector(31 downto 0);
    p_fl:  out std_logic_vector(9 downto 1);
    p_ex:  out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu_f_comp;

architecture rtl of e_mcp_cu_f_comp is
    signal s_s_l: std_logic;
    signal s_s_e: std_logic;
    signal s_s_g: std_logic;

    signal s_e_l: std_logic;
    signal s_e_e: std_logic;
    signal s_e_g: std_logic;

    signal s_m_l: std_logic;
    signal s_m_e: std_logic;
    signal s_m_g: std_logic;
begin
    s_s_l <= p_opd(31) and not p_ops(31);
    s_s_e <= p_opd(31) xnor p_ops(31);
    s_s_g <= not p_opd(31) and p_ops(31);

    l_e: entity work.c_comp
    generic map (
        g_width => 8
    )
    port map (
        p_a  => p_opd(30 downto 23),
        p_b  => p_ops(30 downto 23),
        p_en => s_s_e,
        p_l  => s_e_l,
        p_e  => s_e_e,
        p_g  => s_e_g
    );

    l_m: entity work.c_comp
    generic map (
        g_width => 23
    )
    port map (
        p_a  => p_opd(22 downto 0),
        p_b  => p_ops(22 downto 0),
        p_en => s_e_e,
        p_l  => s_m_l,
        p_e  => s_m_e,
        p_g  => s_m_g
    );

    p_fl(4 downto 1) <= (others => '0');
    p_fl(7 downto 5) <= (others => '0') when p_cmd(36) = '0' else
                        s_m_g & s_m_e & s_m_l when s_e_e = '1' else
                        s_e_g & s_e_e & s_e_l when s_s_e = '1' else
                        s_s_g & s_s_e & s_s_l;
    p_fl(9 downto 8) <= (others => '0');

    p_q <= (others => '0');

    p_ex <= "0000";
end architecture rtl;
