library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_const is
port (
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_ctrl: in  std_logic_vector(11 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_const;

architecture rtl of e_mcp_const is
    signal s_q:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
begin
    process (p_cmd) is
    begin
        if p_cmd(17) = '1' then
            s_q <= "00000000000000000000000000000000";
        elsif p_cmd(18) = '1' then
            s_q <= "00000000000000000000000000000001";
        elsif p_cmd(26) = '1' then
            s_q <= "00000000000000000000000000000000";
        elsif p_cmd(27) = '1' then
            s_q <= "00111111100000000000000000000000";
        elsif p_cmd(28) = '1' then
            s_q <= "01000000010010010000111111011011";
        elsif p_cmd(29) = '1' then
            s_q <= "01000000001011011111100001010100";
        else
            s_q <= "00000000000000000000000000000000";
        end if;
    end process;

    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_ctrl(4), -- RC
        p_en => '1',
        p_q  => s_en
    );

    l_tri: entity work.c_tri
    generic map (
        g_width => 32
    )
    port map (
        p_d  => s_q,
        p_en => s_en,
        p_q  => p_q
    );
end architecture rtl;
