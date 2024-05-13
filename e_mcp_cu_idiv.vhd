library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity e_mcp_cu_idiv is
port (
    p_op0:  in  std_logic_vector(31 downto 0);
    p_op1:  in  std_logic_vector(31 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_idiv;

architecture rtl of e_mcp_cu_idiv is
    signal s_op1: std_logic_vector(31 downto 0);
    signal s_rem: std_logic_vector(31 downto 0);

    signal s_ci: std_logic;
    signal s_b:  std_logic_vector(31 downto 0);
    signal s_sm: std_logic_vector(31 downto 0);

    signal s_crci: std_logic;
    signal s_crsm: std_logic_vector(31 downto 0);
begin
    l_op1: entity work.c_srg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => p_ctrl(8),
        p_pd => p_op1,
        p_sd => s_ci,
        p_lr => '0',
        p_cl => p_ctrl(10),
        p_en => '1',
        p_q  => s_op1
    );

    s_ci <= s_sm(31) xnor p_op0(31);

    process (s_ci) is
    begin
        if s_ci = '1' then
            s_b <= not p_op0;
        else
            s_b <= p_op0;
        end if;
    end process;

    l_sm: entity work.c_sm
    generic map (
        g_width => 32
    )
    port map (
        p_ci => s_ci,
        p_a  => s_rem,
        p_b  => s_b,
        p_q  => s_sm,
        p_co => open,
        p_o  => open,
        p_u  => open
    );

    l_rem: entity work.c_srg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => p_ctrl(8),
        p_s  => p_ctrl(9),
        p_pd => s_sm,
        p_sd => s_op1(31),
        p_lr => '0',
        p_cl => p_ctrl(10),
        p_en => '1',
        p_q  => s_rem
    );

    process (p_op0, p_op1, s_rem) is
        variable v_op0: integer := to_integer(signed(p_op0));
        variable v_op1: integer := to_integer(signed(p_op1));
        variable v_rem: integer := to_integer(signed(s_rem));
    begin
        if v_op0 > 0 and v_op1 < 0 then
            s_crci <= '1';
        elsif v_op0 < 0 and v_op1 > 0 and v_rem /= 0 then
            s_crci <= '1';
        elsif v_op0 < 0 and v_op1 < 0 and v_rem = 0 then
            s_crci <= '1';
        else
            s_crci <= '0';
        end if;
    end process;

    l_crsm: entity work.c_sm
    generic map (
        g_width => 32
    )
    port map (
        p_ci => s_crci,
        p_a  => s_op1,
        p_b  => (others => '0'),
        p_q  => s_crsm,
        p_co => open
    );

    p_q <= s_crsm;
end architecture rtl;
