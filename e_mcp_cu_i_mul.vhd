library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_i_mul is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_ctrl: in  std_logic_vector(11 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_fl:   out std_logic_vector(9 downto 1)
);
end entity e_mcp_cu_i_mul;

architecture rtl of e_mcp_cu_i_mul is
    signal s_en: std_logic;
    signal s_q:  std_logic_vector(63 downto 0);
begin
    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_ctrl(9), -- CU1
        p_en => p_cmd(23),
        p_q  => s_en
    );

    l_mul: entity work.c_mul
    generic map (
        g_width => 32
    )
    port map (
        p_a  => p_opd,
        p_b  => p_ops,
        p_cl => p_ctrl(10), -- CU2
        p_en => s_en,
        p_q  => s_q
    );

    p_q <= s_q(31 downto 0);

    process (s_q) is
        variable v_o: std_logic := s_q(63);
        variable v_u: std_logic := s_q(63);
    begin
        for i in 62 downto 31 loop
            v_o := v_o or   s_q(i);
            v_u := v_u nand s_q(i);
        end loop;

        p_fl <= (others => '0');

        if to_integer(unsigned(s_q(31 downto 0))) = 0 then
            p_fl(1) <= '1';
        else
            p_fl(1) <= '0';
        end if;

        p_fl(2) <= s_q(31);
        p_fl(3) <= v_o and s_q(31);
        p_fl(4) <= v_u and not s_q(31);
    end process;
end architecture rtl;
