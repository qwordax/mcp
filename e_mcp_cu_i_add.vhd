library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_i_add is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_fl:   out std_logic_vector(4 downto 3)
);
end entity e_mcp_cu_i_add;

architecture rtl of e_mcp_cu_i_add is
    signal s_en: std_logic;

    signal s_ci: std_logic;
    signal s_a:  std_logic_vector(31 downto 0);
    signal s_b:  std_logic_vector(31 downto 0);
begin
    s_en <= p_cmd(21) or p_cmd(22);

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

    s_ci <= '1' when p_cmd(22) = '1' else '0';

    s_a <= s_opd;
    s_b <= not s_ops when p_cmd(22) = '1' else s_ops;

    l_sm: entity work.c_sm
    generic map (
        g_width => 32
    )
    port map (
        p_ci => s_ci,
        p_a  => s_a,
        p_b  => s_b,
        p_q  => p_q,
        p_co => open,
        p_o  => p_fl(3),
        p_u  => p_fl(4)
    );
end architecture rtl;
