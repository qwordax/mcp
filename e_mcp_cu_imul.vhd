library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu_imul is
port (
    p_op0:  in  std_logic_vector(31 downto 0);
    p_op1:  in  std_logic_vector(31 downto 0);
    p_ctrl: in  std_logic_vector(10 downto 0);
    p_q:    out std_logic_vector(31 downto 0)
);
end entity e_mcp_cu_imul;

architecture rtl of e_mcp_cu_imul is
    signal s_op1:  std_logic_vector(31 downto 0);
    signal s_prod: std_logic_vector(31 downto 0);

    signal s_ci: std_logic;
    signal s_b:  std_logic_vector(31 downto 0);
    signal s_sm: std_logic_vector(31 downto 0);
    signal s_co: std_logic;

    signal s_co_ff: std_logic;

    signal s_sd: std_logic;
begin
    l_op1: entity work.c_srg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => p_ctrl(8),
        p_pd => p_op1,
        p_sd => s_prod(0),
        p_lr => '1',
        p_cl => p_ctrl(10),
        p_en => '1',
        p_q  => s_op1
    );

    process (p_ctrl, s_op1) is
        variable v_tmp: integer range 0 to 31 := 0;
    begin
        if p_ctrl(8) = '1' then
            v_tmp := 0;
        elsif p_ctrl(10)'event and p_ctrl(10) = '1' then
            v_tmp := v_tmp + 1;
        end if;

        if v_tmp = v_tmp'high and s_op1(0) = '1' then
            s_ci <= '1';
        else
            s_ci <= '0';
        end if;
    end process;

    process (s_op1, s_ci) is
    begin
        if s_op1(0) = '0' then
            s_b <= (others => '0');
        else
            if s_ci = '1' then
                s_b <= not p_op0;
            else
                s_b <= p_op0;
            end if;
        end if;
    end process;

    l_sm: entity work.c_sm
    generic map (
        g_width => 32
    )
    port map (
        p_ci => s_ci,
        p_a  => s_prod,
        p_b  => s_b,
        p_s  => s_sm,
        p_co => s_co
    );

    l_co: entity work.c_dff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => s_co,
        p_cl => p_ctrl(9),
        p_en => '1',
        p_q  => s_co_ff
    );

    s_sd <= s_co_ff or s_prod(31);

    l_prod: entity work.c_srg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => p_ctrl(9),
        p_pd => s_sm,
        p_sd => s_sd,
        p_lr => '1',
        p_cl => p_ctrl(10),
        p_en => '1',
        p_q  => s_prod
    );

    p_q <= s_op1;
end architecture rtl;
