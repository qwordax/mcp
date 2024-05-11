library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu is
port (
    p_cmd:  in  std_logic_vector(37 downto 0);
    p_op0:  in  std_logic_vector(31 downto 0);
    p_op1:  in  std_logic_vector(31 downto 0);
    p_ctrl: in  std_logic_vector(9 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_f:    out std_logic_vector(8 downto 0)
);
end entity e_mcp_cu;

architecture rtl of e_mcp_cu is
    signal s_d:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
begin
    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_ctrl(2),
        p_en => '1',
        p_q  => s_en
    );

    l_tri: entity work.c_tri
    generic map (
        g_width => 32
    )
    port map (
        p_d  => s_d,
        p_en => s_en,
        p_q  => p_q
    );
end architecture rtl;
