library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_i_div is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_cl:   in  std_logic;
    p_ctrl: in  std_logic_vector(13 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_fl:   out std_logic_vector(9 downto 1);
    p_ex:   out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu_i_div;

architecture rtl of e_mcp_cu_i_div is
    signal s_en: std_logic;
    signal s_q:  std_logic_vector(31 downto 0);
begin
    process (p_cmd, p_cl, p_ctrl) is
        variable v_ctr: integer;
    begin
        if p_cl'event and p_cl = '1' and p_ctrl(8) = '1' then -- CU0
            v_ctr := 65;
        elsif p_cl'event and p_cl = '1' and p_ctrl(9) = '1' then -- CU1
            v_ctr := v_ctr - 1;
        end if;

        if v_ctr /= 0 and p_cmd(24) = '1' then
            p_ex(0) <= '1';
        else
            p_ex(0) <= '0';
        end if;
    end process;

    s_en <= p_cmd(24) and p_ctrl(9); -- CU1

    l_div: entity work.c_div
    generic map (
        g_width => 32
    )
    port map (
        p_a  => p_opd,
        p_b  => p_ops,
        p_cl => p_cl,
        p_en => s_en,
        p_q  => s_q
    );

    p_q <= s_q when p_cmd(24) = '1' else (others => '0');

    p_fl(1)          <= '0';
    p_fl(2)          <= s_q(31) when p_cmd(24) = '1' else '0';
    p_fl(7 downto 3) <= (others => '0');
    p_fl(8)          <= '1' when to_integer(unsigned(p_ops)) = 0 and p_cmd(24) = '1' else '0';
    p_fl(9)          <= '0';

    p_ex(3 downto 1) <= "000";
end architecture rtl;
