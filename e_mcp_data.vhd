library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_data is
port (
    p_rs:   in  std_logic_vector(2 downto 0);
    p_rd:   in  std_logic_vector(2 downto 0);
    p_d:    in  std_logic_vector(31 downto 0);
    p_ctrl: in  std_logic_vector(9 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_op0:  out std_logic_vector(31 downto 0);
    p_op1:  out std_logic_vector(31 downto 0)
);
end entity e_mcp_data;

architecture rtl of e_mcp_data is
    type data is array (7 downto 0) of std_logic_vector(31 downto 0);

    signal s_data: data;

    signal s_rg_en: std_logic_vector(7 downto 0);
begin
    l_dc: entity work.c_dc
    generic map (
        g_width => 3
    )
    port map (
        p_d  => p_rd,
        p_en => '1',
        p_q  => s_rg_en
    );

    l_data: for i in 0 to 7 generate
        l_rg: entity work.c_rg
        generic map (
            g_width => 32
        )
        port map (
            p_r  => '0',
            p_s  => '0',
            p_d  => p_d,
            p_cl => p_ctrl(5),
            p_en => s_rg_en(i),
            p_q  => s_data(i)
        );
    end generate l_data;

    process (p_rs) is
    begin
        p_q <= s_data(to_integer(unsigned(p_rs)));
    end process;

    process (p_rs, p_rd) is
    begin
        p_op0 <= s_data(to_integer(unsigned(p_rs)));
        p_op1 <= s_data(to_integer(unsigned(p_rd)));
    end process;
end architecture rtl;
