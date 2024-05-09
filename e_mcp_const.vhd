library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_const is
port (
    p_cmd:  in  std_logic_vector(5 downto 0);
    p_ctrl: in  std_logic_vector(9 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_const;

architecture rtl of e_mcp_const is
    signal s_q:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
begin
    process (p_cmd) is
    begin
        case p_cmd is
            when "000001" => s_q <= "00000000000000000000000000000000";
            when "000010" => s_q <= "00000000000000000000000000000001";
            when "000100" => s_q <= "00000000000000000000000000000000";
            when "001000" => s_q <= "00111111100000000000000000000000";
            when "010000" => s_q <= "01000000010010010000111111011011";
            when "100000" => s_q <= "01000000001011011111100001010100";
            when others   => s_q <= "00000000000000000000000000000000";
        end case;
    end process;

    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_ctrl(3),
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
