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
    p_fl:   out std_logic_vector(9 downto 1);
    p_ex:   out std_logic_vector(3 downto 0)
);
end entity e_mcp_cu;

architecture rtl of e_mcp_cu is
    type d_type  is array (13 downto 0) of std_logic_vector(31 downto 0);
    type fl_type is array (13 downto 0) of std_logic_vector(9 downto 1);
    type ex_type is array (13 downto 0) of std_logic_vector(3 downto 0);

    signal s_d:  d_type;
    signal s_fl: fl_type;
    signal s_ex: ex_type;

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
        p_cmd => p_cmd,
        p_q   => s_d(0),
        p_fl  => s_fl(0),
        p_ex  => s_ex(0)
    );

    l_f_add: entity work.e_mcp_cu_f_add
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_cl   => p_cl,
        p_ctrl => p_ctrl,
        p_q    => s_d(1),
        p_fl   => s_fl(1),
        p_ex   => s_ex(1)
    );

    l_f_chs: entity work.e_mcp_cu_f_chs
    port map (
        p_opd => s_opd,
        p_cmd => p_cmd,
        p_q   => s_d(2),
        p_fl  => s_fl(2),
        p_ex  => s_ex(2)
    );

    l_f_comp: entity work.e_mcp_cu_f_comp
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => s_d(3),
        p_fl  => s_fl(3),
        p_ex  => s_ex(3)
    );

    l_f_div: entity work.e_mcp_cu_f_div
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_cl   => p_cl,
        p_ctrl => p_ctrl,
        p_q    => s_d(4),
        p_fl   => s_fl(4),
        p_ex   => s_ex(4)
    );

    l_f_mul: entity work.e_mcp_cu_f_mul
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_cl   => p_cl,
        p_ctrl => p_ctrl,
        p_q    => s_d(5),
        p_fl   => s_fl(5),
        p_ex   => s_ex(5)
    );

    l_i_abs: entity work.e_mcp_cu_i_abs
    port map (
        p_opd => s_opd,
        p_cmd => p_cmd,
        p_q   => s_d(6),
        p_fl  => s_fl(6),
        p_ex  => s_ex(6)
    );

    l_i_add: entity work.e_mcp_cu_i_add
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => s_d(7),
        p_fl  => s_fl(7),
        p_ex  => s_ex(7)
    );

    l_i_chs: entity work.e_mcp_cu_i_chs
    port map (
        p_opd => s_opd,
        p_cmd => p_cmd,
        p_q   => s_d(8),
        p_fl  => s_fl(8),
        p_ex  => s_ex(8)
    );

    l_i_comp: entity work.e_mcp_cu_i_comp
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => s_d(9),
        p_fl  => s_fl(9),
        p_ex  => s_ex(9)
    );

    l_i_div: entity work.e_mcp_cu_i_div
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_cl   => p_cl,
        p_ctrl => p_ctrl,
        p_q    => s_d(10),
        p_fl   => s_fl(10),
        p_ex   => s_ex(10)
    );

    l_i_mul: entity work.e_mcp_cu_i_mul
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_cl   => p_cl,
        p_ctrl => p_ctrl,
        p_q    => s_d(11),
        p_fl   => s_fl(11),
        p_ex   => s_ex(11)
    );

    l_logic: entity work.e_mcp_cu_logic
    port map (
        p_opd => s_opd,
        p_ops => s_ops,
        p_cmd => p_cmd,
        p_q   => s_d(12),
        p_fl  => s_fl(12),
        p_ex  => s_ex(12)
    );

    l_shift: entity work.e_mcp_cu_shift
    port map (
        p_opd  => s_opd,
        p_ops  => s_ops,
        p_cmd  => p_cmd,
        p_cl   => p_cl,
        p_ctrl => p_ctrl,
        p_q    => s_d(13),
        p_fl   => s_fl(13),
        p_ex   => s_ex(13)
    );

    process (p_cmd, s_d, s_fl, s_ex) is
        variable v_f_abs:  std_logic;
        variable v_f_add:  std_logic;
        variable v_f_chs:  std_logic;
        variable v_f_comp: std_logic;
        variable v_f_mul:  std_logic;
        variable v_f_div:  std_logic;
        variable v_i_abs:  std_logic;
        variable v_i_add:  std_logic;
        variable v_i_chs:  std_logic;
        variable v_i_comp: std_logic;
        variable v_i_div:  std_logic;
        variable v_i_mul:  std_logic;
        variable v_logic:  std_logic;
        variable v_shift:  std_logic;

        variable v_tmp: integer;
    begin
        v_f_abs  := p_cmd(30);
        v_f_add  := p_cmd(32) or p_cmd(33);
        v_f_chs  := p_cmd(31);
        v_f_comp := p_cmd(36);
        v_f_div  := p_cmd(35);
        v_f_mul  := p_cmd(34);
        v_i_abs  := p_cmd(19);
        v_i_add  := p_cmd(21) or p_cmd(22);
        v_i_chs  := p_cmd(20);
        v_i_comp := p_cmd(25);
        v_i_div  := p_cmd(24);
        v_i_mul  := p_cmd(23);
        v_logic  := p_cmd(4) or p_cmd(5) or p_cmd(6) or p_cmd(7) or p_cmd(8) or p_cmd(9) or p_cmd(10);
        v_shift  := p_cmd(11) or p_cmd(12) or p_cmd(13) or p_cmd(14) or p_cmd(15) or p_cmd(16);

        if v_f_abs = '1' then
            v_tmp := 0;
        elsif v_f_add = '1' then
            v_tmp := 1;
        elsif v_f_chs = '1' then
            v_tmp := 2;
        elsif v_f_comp = '1' then
            v_tmp := 3;
        elsif v_f_div = '1' then
            v_tmp := 4;
        elsif v_f_mul = '1' then
            v_tmp := 5;
        elsif v_i_abs = '1' then
            v_tmp := 6;
        elsif v_i_add = '1' then
            v_tmp := 7;
        elsif v_i_chs = '1' then
            v_tmp := 8;
        elsif v_i_comp = '1' then
            v_tmp := 9;
        elsif v_i_div = '1' then
            v_tmp := 10;
        elsif v_i_mul = '1' then
            v_tmp := 11;
        elsif v_logic = '1' then
            v_tmp := 12;
        elsif v_shift = '1' then
            v_tmp := 13;
        else
            v_tmp := 0;
        end if;

        s_q  <= s_d(v_tmp);
        p_fl <= s_fl(v_tmp);
        p_ex <= s_ex(v_tmp);
    end process;

    l_en: entity work.c_tff
    port map (
        p_r  => '0',
        p_s  => '0',
        p_cl => p_cl,
        p_en => p_ctrl(3), -- RCU
        p_q  => s_en
    );

--    l_tri: entity work.c_tri
--    generic map (
--        g_width => 32
--    )
--    port map (
--        p_d  => s_q,
--        p_en => s_en,
--        p_q  => p_q
--    );

    p_q <= s_q when s_en = '1' else (others => '0');
end architecture rtl;
