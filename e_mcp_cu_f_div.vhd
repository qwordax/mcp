library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity e_mcp_cu_f_div is
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
end entity e_mcp_cu_f_div;

architecture rtl of e_mcp_cu_f_div is
    signal s_en: std_logic;

    signal s_zero_d: std_logic;
    signal s_zero_s: std_logic;

    signal s_inf_d: std_logic;
    signal s_inf_s: std_logic;

    signal s_d_m: std_logic_vector(49 downto 0);
    signal s_s_m: std_logic_vector(24 downto 0);

    signal s_ds_m: std_logic_vector(24 downto 0);

    signal s_res_s: std_logic;
    signal s_res_e: std_logic_vector(7 downto 0);
    signal s_res_m: std_logic_vector(24 downto 0);

    signal s_q: std_logic_vector(31 downto 0);
begin
    s_zero_d <= '1' when p_opd(30 downto 0) = "00000000000000000000000" else '0';
    s_zero_s <= '1' when p_ops(30 downto 0) = "00000000000000000000000" else '0';

    s_inf_d <= '1' when p_opd(30 downto 23) = "11111111" else '0';
    s_inf_s <= '1' when p_ops(30 downto 23) = "11111111" else '0';

    process (p_cl, p_ctrl, p_opd, p_ops, p_cmd, s_res_m) is
        variable v_d_s: std_logic;
        variable v_d_e: std_logic_vector(7 downto 0);
        variable v_d_m: std_logic_vector(24 downto 0);

        variable v_s_s: std_logic;
        variable v_s_e: std_logic_vector(7 downto 0);
        variable v_s_m: std_logic_vector(24 downto 0);

        variable v_ctr: integer;
    begin
        v_d_s := p_opd(31);
        v_s_s := p_ops(31);

        v_d_e := p_opd(30 downto 23);
        v_s_e := p_ops(30 downto 23);

        v_d_m := "01" & p_opd(22 downto 0);
        v_s_m := "01" & p_ops(22 downto 0);

        if p_cl'event and p_cl = '1' and p_ctrl(9) = '1' then -- CU1
            s_res_s <= v_d_s xor v_s_s;
            s_res_e <= v_d_e - v_s_e + "01111111";

            s_d_m(49 downto 25) <= v_d_m;
            s_d_m(24 downto  0) <= (others => '0');
            s_s_m <= v_s_m;

            v_ctr := 51;
        elsif p_cl'event and p_cl = '1' and p_ctrl(10) = '1' then -- CU2
            v_ctr := v_ctr - 1;
        elsif p_cl'event and p_cl = '1' and p_ctrl(11) = '1' then -- CU3
            s_res_m <= s_ds_m;
        elsif p_cl'event and p_cl = '1' and p_ctrl(12) = '1' then -- CU4
            s_res_m <= s_res_m(23 downto 0) & '0';
            s_res_e <= s_res_e - '1';
        end if;

        if v_ctr /= 0 and p_cmd(34) = '1' then
            p_ex(1) <= '1';
        else
            p_ex(1) <= '0';
        end if;

        if s_res_m(24 downto 23) /= "01" and p_cmd(35) = '1' then
            p_ex(3) <= '1';
        else
            p_ex(3) <= '0';
        end if;
    end process;

    s_en <= p_cmd(35) and p_ctrl(9); -- CU1

    l_div: entity work.c_div
    generic map (
        g_width => 50
    )
    port map (
        p_a  => s_d_m,
        p_b  => s_s_m,
        p_cl => p_cl,
        p_en => s_en,
        p_q  => s_ds_m
    );

    process (s_res_s, s_res_e, s_res_m, s_zero_d, s_zero_s) is
    begin
        if s_zero_d = '1' then
            s_q <= (others => '0');
        else
            s_q(31)           <= s_res_s;
            s_q(30 downto 23) <= s_res_e;
            s_q(22 downto 0)  <= s_res_m(22 downto 0);
        end if;
    end process;

    p_q  <= (others => '0');

    p_fl(1)          <= s_zero_d and not s_zero_s when p_cmd(35) = '1' else '0';
    p_fl(2)          <= s_q(31) when p_cmd(35) = '1' else '0';
    p_fl(7 downto 3) <= (others => '0');
    p_fl(8)          <= s_zero_s when p_cmd(35) = '1' else '0';
    p_fl(9)          <= s_inf_d or s_inf_s or s_zero_s when p_cmd(35) = '1' else '0';

    p_ex(0) <= s_zero_d when s_en = '1' else '0';
    p_ex(2) <= s_inf_d or s_inf_s or s_zero_s when s_en = '1' else '0';
end architecture rtl;
