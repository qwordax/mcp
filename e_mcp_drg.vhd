library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_drg is
port (
    p_rs:   in    std_logic_vector(2 downto 0);
    p_rd:   in    std_logic_vector(2 downto 0);
    p_ctrl: in    std_logic_vector(9 downto 0);
    p_d:    inout std_logic_vector(31 downto 0);
    p_op0:  out   std_logic_vector(31 downto 0);
    p_op1:  out   std_logic_vector(31 downto 0)
);
end entity e_mcp_drg;

architecture rtl of e_mcp_drg is
    type memory is array (7 downto 0) of std_logic_vector(31 downto 0);

    signal s_mem: memory;

    signal s_d:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
    signal s_dc: std_logic_vector(7 downto 0);
begin
    l_dc: entity work.c_dc
    generic map (
        g_width => 3
    )
    port map (
        p_d  => p_rd,
        p_en => '1',
        p_q  => s_dc
    );

    l_drg: for i in 0 to 7 generate
        l_rg: entity work.c_rg
        generic map (
            g_width => 32
        )
        port map (
            p_r  => '0',
            p_s  => '0',
            p_d  => p_d,
            p_cl => p_ctrl(5),
            p_en => s_dc(i),
            p_q  => s_mem(i)
        );
    end generate l_drg;

    l_rs: process (p_rs) is
    begin
        s_d <= s_mem(to_integer(unsigned(p_rs)));
    end process l_rs;

    l_op: process (p_rs, p_rd) is
    begin
        p_op0 <= s_mem(to_integer(unsigned(p_rs)));
        p_op1 <= s_mem(to_integer(unsigned(p_rd)));
    end process l_op;

    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_ctrl(1),
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
        p_q  => p_d
    );
end architecture rtl;
