library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_cu is
port (
    p_opd:  in  std_logic_vector(31 downto 0);
    p_ops:  in  std_logic_vector(31 downto 0);
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_cl:   in  std_logic;
    p_ctrl: in  std_logic_vector(13 downto 0);
    p_q:    out std_logic_vector(31 downto 0);
    p_fl:   out std_logic_vector(9 downto 1)
);
end entity e_mcp_cu;

architecture rtl of e_mcp_cu is
    type d_type  is array (10 downto 0) of std_logic_vector(31 downto 0);
    type fl_type is array (10 downto 0) of std_logic_vector(9 downto 1);

    signal s_d:  d_type;
    signal s_fl: fl_type;

    signal s_opd: std_logic_vector(31 downto 0);
    signal s_ops: std_logic_vector(31 downto 0);

    signal s_q:  std_logic_vector(31 downto 0);
    signal s_en: std_logic;
begin
    l_opd: entity work.c_rg
    generic map (
        g_width => 32
    )
    port map (
        p_r  => '0',
        p_s  => '0',
        p_d  => p_opd,
        p_cl => p_cl,
        p_en => p_ctrl(8), -- CU0
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
        p_cl => p_cl,
        p_en => p_ctrl(8), -- CU0
        p_q  => s_ops
    );

    l_f_abs: entity work.e_mcp_cu_f_abs
    port map (
        p_opd => s_opd,
        p_q   => s_d(0),
        p_fl  => s_fl(0)
    );

    l_f_chs: entity work.e_mcp_cu_f_chs
    port map (
        p_opd => s_opd,
        p_q   => s_d(1),
        p_fl  => s_fl(1)
    );

    l_f_comp: entity work.e_mcp_cu_f_comp
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_fl  => s_fl(2)
    );

    l_i_abs: entity work.e_mcp_cu_i_abs
    port map (
        p_opd => s_opd,
        p_q   => s_d(3),
        p_fl  => s_fl(3)
    );

    l_i_add: entity work.e_mcp_cu_i_add
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => s_d(4),
        p_fl  => s_fl(4)
    );

    l_i_chs: entity work.e_mcp_cu_i_chs
    port map (
        p_opd => s_opd,
        p_q   => s_d(5),
        p_fl  => s_fl(5)
    );

    l_i_comp: entity work.e_mcp_cu_i_comp
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_fl  => s_fl(6)
    );

    l_i_div: entity work.e_mcp_cu_i_div
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_cl   => p_cl,
        p_ctrl => p_ctrl,
        p_q    => s_d(7),
        p_fl   => s_fl(7)
    );

    l_i_mul: entity work.e_mcp_cu_i_mul
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_cl   => p_cl,
        p_ctrl => p_ctrl,
        p_q    => s_d(8),
        p_fl   => s_fl(8)
    );

    l_logic: entity work.e_mcp_cu_logic
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => s_d(9),
        p_fl  => s_fl(9)
    );

    l_shift: entity work.e_mcp_cu_shift
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => s_d(10),
        p_fl  => s_fl(10)
    );

    process (p_cmd) is
        variable v_f_abs:  std_logic;
        variable v_f_chs:  std_logic;
        variable v_f_comp: std_logic;
        variable v_i_abs:  std_logic;
        variable v_i_add:  std_logic;
        variable v_i_chs:  std_logic;
        variable v_i_comp: std_logic;
        variable v_i_div:  std_logic;
        variable v_i_mul:  std_logic;
        variable v_logic:  std_logic;
        variable v_shift:  std_logic;
    begin
        v_f_abs  := p_cmd(30);
        v_f_chs  := p_cmd(31);
        v_f_comp := p_cmd(36);
        v_i_abs  := p_cmd(19);
        v_i_add  := p_cmd(21) or p_cmd(22);
        v_i_chs  := p_cmd(20);
        v_i_comp := p_cmd(25);
        v_i_div  := p_cmd(24);
        v_i_mul  := p_cmd(23);
        v_logic  := p_cmd(4) or p_cmd(5) or p_cmd(6) or p_cmd(7) or p_cmd(8) or p_cmd(9) or p_cmd(10);
        v_shift  := p_cmd(11) or p_cmd(12) or p_cmd(13) or p_cmd(14) or p_cmd(15) or p_cmd(16);

        if v_f_abs = '1' then
            s_q  <= s_d(0);
            p_fl <= s_fl(0);
        elsif v_f_chs = '1' then
            s_q  <= s_d(1);
            p_fl <= s_fl(1);
        elsif v_f_comp = '1' then
            s_q  <= (others => '0');
            p_fl <= s_fl(2);
        elsif v_i_abs = '1' then
            s_q  <= s_d(3);
            p_fl <= s_fl(3);
        elsif v_i_add = '1' then
            s_q  <= s_d(4);
            p_fl <= s_fl(4);
        elsif v_i_chs = '1' then
            s_q  <= s_d(5);
            p_fl <= s_fl(5);
        elsif v_i_comp = '1' then
            s_q  <= (others => '0');
            p_fl <= s_fl(6);
        elsif v_i_div = '1' then
            s_q  <= s_d(7);
            p_fl <= s_fl(7);
        elsif v_i_mul = '1' then
            s_q  <= s_d(8);
            p_fl <= s_fl(8);
        elsif v_logic = '1' then
            s_q  <= s_d(9);
            p_fl <= s_fl(9);
        elsif v_shift = '1' then
            s_q  <= s_d(10);
            p_fl <= s_fl(10);
        else
            s_q  <= (others => '0');
            p_fl <= (others => '0');
        end if;
    end process;

    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_cl,
        p_en => p_ctrl(3), -- RCU
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
