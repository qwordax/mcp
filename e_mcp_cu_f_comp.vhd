library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_f_comp is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_fl:   out std_logic_vector(7 downto 5)
);
end entity e_mcp_cu_f_comp;

architecture rtl of e_mcp_cu_f_comp is
    signal s_opd: std_logic_vector(31 downto 0);
    signal s_ops: std_logic_vector(31 downto 0);

    signal s_s_l: std_logic;
    signal s_s_e: std_logic;
    signal s_s_g: std_logic;

    signal s_e_l: std_logic;
    signal s_e_e: std_logic;
    signal s_e_g: std_logic;

    signal s_m_l: std_logic;
    signal s_m_e: std_logic;
    signal s_m_g: std_logic;

    signal s_e_en: std_logic;
    signal s_m_en: std_logic;
begin
    l_opd: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_opd,
        p_cl => p_ctrl(8), -- CU0
        p_en => p_cmd(36), -- FCMP
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
        p_en => p_cmd(36), -- FCMP
        p_q  => s_ops
    );

    s_s_l <= (s_opd(31) and not s_ops(31)) and p_cmd(36);
    s_s_e <= (s_opd(31) xnor s_ops(31)) and p_cmd(36);
    s_s_g <= (not s_opd(31) and s_ops(31)) and p_cmd(36);

    s_e_en <= s_s_e and p_cmd(36);

    l_e: entity work.c_comp
    generic map (
        g_width => 8
    )
    port map (
        p_a  => s_opd(30 downto 23),
        p_b  => s_ops(30 downto 23),
        p_en => s_e_en,
        p_l  => s_e_l,
        p_e  => s_e_e,
        p_g  => s_e_g
    );

    s_m_en <= s_e_e and p_cmd(36);

    l_m: entity work.c_comp
    generic map (
        g_width => 23
    )
    port map (
        p_a  => s_opd(22 downto 0),
        p_b  => s_ops(22 downto 0),
        p_en => s_m_en,
        p_l  => s_m_l,
        p_e  => s_m_e,
        p_g  => s_m_g
    );

    p_fl <= s_m_g & s_m_e & s_m_l when s_e_e = '1' else
            s_e_g & s_e_e & s_e_l when s_s_e = '1' else
            s_s_g & s_s_e & s_s_l;
end architecture rtl;
