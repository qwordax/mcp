library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_logic is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(37 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_logic;

architecture rtl of e_mcp_cu_logic is
    signal s_en: std_logic;

    signal s_opd: std_logic_vector(31 downto 0);
    signal s_ops: std_logic_vector(31 downto 0);
begin
    s_en <= p_cmd(4) or p_cmd(5) or p_cmd(6) or p_cmd(7) or p_cmd(8) or p_cmd(9) or p_cmd(10);

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

    process (p_opd, p_ops, p_cmd) is
    begin
        if p_cmd(3) = '1' then
            p_q <= not s_opd;
        elsif p_cmd(4) = '1' then
            p_q <= s_opd and s_ops;
        elsif p_cmd(5) = '1' then
            p_q <= s_opd or s_ops;
        elsif p_cmd(6) = '1' then
            p_q <= s_opd xor s_ops;
        elsif p_cmd(7) = '1' then
            p_q <= s_opd nand s_ops;
        elsif p_cmd(8) = '1' then
            p_q <= s_opd nor s_ops;
        elsif p_cmd(9) = '1' then
            p_q <= s_opd xnor s_ops;
        else
            p_q <= (others => '0');
        end if;
    end process;
end architecture rtl;
