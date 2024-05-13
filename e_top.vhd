library ieee;

use ieee.std_logic_1164.all;

entity e_top is
port (
    p_k:      in  std_logic_vector(3 downto 0);
    p_sw:     in  std_logic_vector(3 downto 0);
    p_cl:     in  std_logic;
    p_led:    out std_logic_vector(8 downto 0);
    p_sd_sg:  out std_logic_vector(7 downto 0);
    p_sd_cs:  out std_logic_vector(7 downto 0);
    p_lcd_rs: out std_logic;
    p_lcd_rw: out std_logic;
    p_lcd_en: out std_logic;
    p_lcd_d:  out std_logic_vector(7 downto 0)
);
end entity e_top;

architecture rtl of e_top is
    signal s_p_k:  std_logic_vector(3 downto 0);
    signal s_p_sw: std_logic_vector(3 downto 0);

    signal s_k:  std_logic_vector(3 downto 0);
    signal s_sw: std_logic_vector(3 downto 0);

    signal s_ctrl_cl: std_logic;

    signal s_mode: std_logic_vector(2 downto 0);

    signal s_rs_en: std_logic;
    signal s_rd_en: std_logic;

    signal s_lcd_cl: std_logic;

    signal s_mcp_op: std_logic_vector(5 downto 0);
    signal s_mcp_rs: std_logic_vector(2 downto 0);
    signal s_mcp_rd: std_logic_vector(2 downto 0);
    signal s_mcp_d:  std_logic_vector(31 downto 0);
    signal s_mcp_q:  std_logic_vector(31 downto 0);
    signal s_mcp_f:  std_logic_vector(8 downto 0);

    signal s_in_ml: std_logic;

    signal s_sd_d:  std_logic_vector(31 downto 0);
    signal s_sd_ml: std_logic;
    signal s_sd_cs: std_logic_vector(31 downto 0);
begin
    s_p_k  <= not p_k;
    s_p_sw <= not p_sw;

    l_k: for i in 0 to 3 generate
        l_bn: entity work.c_bn
        generic map (
            g_width => 20
        )
        port map (
            p_d  => s_p_k(i),
            p_cl => p_cl,
            p_q  => s_k(i)
        );
    end generate l_k;

    l_sw: for i in 0 to 3 generate
        l_bn: entity work.c_bn
        generic map (
            g_width => 4
        )
        port map (
            p_d  => s_p_sw(i),
            p_cl => p_cl,
            p_q  => s_sw(i)
        );
    end generate l_sw;

    l_div_ctrl: entity work.c_freq
    generic map (
        g_divide => 25_000_000
    )
    port map (
        p_d => p_cl,
        p_q => s_ctrl_cl
    );

    l_ctrl: entity work.e_top_ctrl
    port map (
        p_sc => s_k(0),
        p_pr => s_k(1),
        p_cl => s_ctrl_cl,
        p_q  => s_mcp_op
    );

    l_mode: entity work.e_top_mode
    port map (
        p_sw   => s_sw(2 downto 1),
        p_mode => s_mode(2 downto 0)
    );

    s_rs_en <= s_k(2) and not s_mode(2);

    l_rs: entity work.c_ctr
    generic map (
        g_width => 3
    )
    port map (
        p_r  => '0',
        p_cl => s_ctrl_cl,
        p_en => s_rs_en,
        p_q  => s_mcp_rs
    );

    s_rd_en <= s_k(3) and not s_mode(2);

    l_rd: entity work.c_ctr
    generic map (
        g_width => 3
    )
    port map (
        p_r  => '0',
        p_cl => s_ctrl_cl,
        p_en => s_rd_en,
        p_q  => s_mcp_rd
    );

    l_in: entity work.e_top_in
    port map (
        p_r  => s_k(2),
        p_s  => s_k(3),
        p_en => s_mode(2),
        p_q  => s_mcp_d,
        p_cs => s_sd_cs,
        p_ml => s_in_ml
    );

    l_div_lcd: entity work.c_freq
    generic map (
        g_divide => 20_000
    )
    port map (
        p_d => p_cl,
        p_q => s_lcd_cl
    );

    l_lcd: entity work.e_top_lcd
    port map (
        p_op     => s_mcp_op,
        p_rs     => s_mcp_rs,
        p_rd     => s_mcp_rd,
        p_mode   => s_mode,
        p_cl     => s_lcd_cl,
        p_lcd_rs => p_lcd_rs,
        p_lcd_rw => p_lcd_rw,
        p_lcd_en => p_lcd_en,
        p_lcd_d  => p_lcd_d
    );

    l_mcp: entity work.e_mcp
    port map (
        p_op => s_mcp_op,
        p_rs => s_mcp_rs,
        p_rd => s_mcp_rd,
        p_d  => s_mcp_d,
        p_st => s_sw(3),
        p_cl => p_cl,
        p_q  => s_mcp_q,
        p_f  => s_mcp_f
    );

    p_led <= not s_mcp_f;

    s_sd_d  <= s_mcp_q when s_sw(1) = '0' else s_mcp_d;
    s_sd_ml <= s_in_ml when s_mode = "100" else s_sw(0);

    l_sd: entity work.e_top_sd
    port map (
        p_d     => s_sd_d,
        p_cs    => s_sd_cs,
        p_ml    => s_sd_ml,
        p_cl    => s_lcd_cl,
        p_sd_sg => p_sd_sg,
        p_sd_cs => p_sd_cs
    );
end architecture rtl;
