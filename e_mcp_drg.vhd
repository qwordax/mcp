library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_drg is
port (
    p_rd:   in  std_logic_vector(2 downto 0);
    p_rs:   in  std_logic_vector(2 downto 0);
    p_cl:   in  std_logic;
    p_ctrl: in  std_logic_vector(13 downto 0);
    p_d:    in  std_logic_vector(31 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_opd:  out std_logic_vector(31 downto 0);
    p_ops:  out std_logic_vector(31 downto 0)
);
end entity e_mcp_drg;

architecture rtl of e_mcp_drg is
    type memory is array (7 downto 0) of std_logic_vector(31 downto 0);

    signal s_opd: std_logic_vector(31 downto 0);
    signal s_ops: std_logic_vector(31 downto 0);

    signal s_mem: memory;

    signal s_rg_en: std_logic_vector(7 downto 0);

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
        s_rg_en(i) <= p_ctrl(5) and s_dc(i); -- WDR

        l_rg: entity work.c_rg
        generic map (
            g_width => 32
        )
        port map (
            p_r  => '0',
            p_s  => '0',
            p_d  => p_d,
            p_cl => p_cl,
            p_en => s_rg_en(i),
            p_q  => s_mem(i)
        );
    end generate l_drg;

    l_op: process (p_rs, p_rd, s_mem) is
    begin
        s_opd <= s_mem(to_integer(unsigned(p_rd)));
        s_ops <= s_mem(to_integer(unsigned(p_rs)));
    end process l_op;

    p_opd <= s_opd;
    p_ops <= s_ops;

    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_cl,
        p_en => p_ctrl(2), -- RDR
        p_q  => s_en
    );

--    l_tri: entity work.c_tri
--    generic map (
--        g_width => 32
--    )
--    port map (
--        p_d  => s_ops,
--        p_en => s_en,
--        p_q  => p_q
--    );

    p_q <= s_ops when s_en = '1' else (others => '0');
end architecture rtl;
