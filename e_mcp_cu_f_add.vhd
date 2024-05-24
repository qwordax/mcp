library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity e_mcp_cu_f_add is
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
end entity e_mcp_cu_f_add;

architecture rtl of e_mcp_cu_f_add is
    signal s_en: std_logic;

    signal s_zero_d: std_logic;
    signal s_zero_s: std_logic;

    signal s_inf_d: std_logic;
    signal s_inf_s: std_logic;

    signal s_d_s: std_logic;
    signal s_d_e: std_logic_vector(7 downto 0);
    signal s_d_m: std_logic_vector(25 downto 0);

    signal s_s_s: std_logic;
    signal s_s_e: std_logic_vector(7 downto 0);
    signal s_s_m: std_logic_vector(25 downto 0);

    signal s_res_m: std_logic_vector(25 downto 0);

    signal s_q: std_logic_vector(31 downto 0);
begin
    s_zero_d <= '1' when p_opd(30 downto 0) = "00000000000000000000000" else '0';
    s_zero_s <= '1' when p_ops(30 downto 0) = "00000000000000000000000" else '0';

    s_inf_d <= '1' when p_opd(30 downto 23) = "11111111" else '0';
    s_inf_s <= '1' when p_ops(30 downto 23) = "11111111" else '0';

    process (p_cl, p_cmd, p_ctrl, p_opd, p_ops, s_res_m) is
        variable v_d_s: std_logic;
        variable v_d_e: std_logic_vector(7 downto 0);
        variable v_d_m: std_logic_vector(25 downto 0);

        variable v_s_s: std_logic;
        variable v_s_e: std_logic_vector(7 downto 0);
        variable v_s_m: std_logic_vector(25 downto 0);

        variable v_tmp_s: std_logic;
        variable v_tmp_e: std_logic_vector(7 downto 0);
        variable v_tmp_m: std_logic_vector(25 downto 0);

        variable v_ctr: integer;
    begin
        v_d_s := p_opd(31);
        v_s_s := p_ops(31);

        v_d_e := p_opd(30 downto 23);
        v_s_e := p_ops(30 downto 23);

        v_d_m := "001" & p_opd(22 downto 0);
        v_s_m := "001" & p_ops(22 downto 0);

        if v_d_s = '1' then
            v_d_m := not v_d_m + '1';
        end if;

        if p_cmd(22) = '1' xor v_s_s = '1' then
            v_s_m := not v_s_m + '1';
        end if;

        if unsigned(v_d_e) < unsigned(v_s_e) then
            v_tmp_s := v_d_s;
            v_tmp_e := v_d_e;
            v_tmp_m := v_d_m;

            v_d_s := v_s_s;
            v_d_e := v_s_e;
            v_d_m := v_s_m;

            v_s_s := v_tmp_s;
            v_s_e := v_tmp_e;
            v_s_m := v_tmp_m;
        end if;

        if p_cl'event and p_cl = '1' and p_ctrl(9) = '1' then -- CU1
            s_d_s <= v_d_s;
            s_d_e <= v_d_e;
            s_d_m <= v_d_m;

            s_s_s <= v_s_s;
            s_s_e <= v_s_e;
            s_s_m <= v_s_m;

            v_ctr := to_integer(unsigned(v_d_e)) - to_integer(unsigned(v_s_e));
        elsif p_cl'event and p_cl = '1' and p_ctrl(10) = '1' then -- CU2
            s_s_m <= s_s_m(25) & s_s_m(25 downto 1);

            v_ctr := v_ctr - 1;
        elsif p_cl'event and p_cl = '1' and p_ctrl(11) = '1' then -- CU3
            s_res_m <= s_d_m + s_s_m;
        elsif p_cl'event and p_cl = '1' and p_ctrl(12) = '1' then -- CU4
            s_res_m <= s_res_m(25) & s_res_m(25 downto 1);
            s_d_e   <= s_d_e + '1';
        end if;

        if v_ctr /= 0 and s_en = '1' then
            p_ex(1) <= '1';
        else
            p_ex(1) <= '0';
        end if;

        if s_res_m(25 downto 23) /= "001" and s_res_m(25 downto 23) /= "110" and s_en = '1' then
            p_ex(3) <= '1';
        else
            p_ex(3) <= '0';
        end if;
    end process;

    process (s_d_e, s_res_m, s_zero_d, s_zero_s) is
        variable v_res_m: std_logic_vector(25 downto 0);
    begin
        v_res_m := s_res_m;

        if v_res_m(25) = '1' then
            v_res_m := not v_res_m + '1';
        end if;

        if s_zero_d = '1' and s_zero_s = '0' then
            s_q <= p_ops;
        elsif s_zero_d = '0' and s_zero_s = '1' then
            s_q <= p_opd;
        elsif s_zero_d = '1' and s_zero_s = '1' then
            s_q <= "00000000000000000000000000000000";
        else
            s_q(31)           <= s_res_m(25);
            s_q(30 downto 23) <= s_d_e;
            s_q(22 downto 0)  <= v_res_m(22 downto 0);
        end if;
    end process;

    s_en <= p_cmd(32) or p_cmd(33);

    p_q  <= s_q when s_en = '1' else (others => '0');

    p_fl(1)          <= s_zero_d and s_zero_s when s_en = '1' else '0';
    p_fl(2)          <= s_q(31) when s_en = '1' else '0';
    p_fl(8 downto 3) <= (others => '0');
    p_fl(9)          <= s_inf_d or s_inf_s when s_en = '1' else '0';

    p_ex(0) <= s_zero_d or s_zero_s when s_en = '1' else '0';
    p_ex(2) <= s_inf_d  or s_inf_s  when s_en = '1' else '0';
end architecture rtl;
