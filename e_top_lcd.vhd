library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity e_top_lcd is
port (
    p_op:     in  std_logic_vector(5 downto 0);
    p_rd:     in  std_logic_vector(2 downto 0);
    p_rs:     in  std_logic_vector(2 downto 0);
    p_mode:   in  std_logic_vector(2 downto 0);
    p_cl:     in  std_logic;
    p_lcd_rs: out std_logic;
    p_lcd_rw: out std_logic;
    p_lcd_en: out std_logic;
    p_lcd_d:  out std_logic_vector(7 downto 0)
);
end entity e_top_lcd;

architecture rtl of e_top_lcd is
    constant C_SP: std_logic_vector(7 downto 0) := x"20";

    constant C_0: std_logic_vector(7 downto 0) := x"30";
    constant C_1: std_logic_vector(7 downto 0) := x"31";
    constant C_2: std_logic_vector(7 downto 0) := x"32";
    constant C_3: std_logic_vector(7 downto 0) := x"33";
    constant C_4: std_logic_vector(7 downto 0) := x"34";
    constant C_5: std_logic_vector(7 downto 0) := x"35";
    constant C_6: std_logic_vector(7 downto 0) := x"36";
    constant C_7: std_logic_vector(7 downto 0) := x"37";
    constant C_8: std_logic_vector(7 downto 0) := x"38";
    constant C_9: std_logic_vector(7 downto 0) := x"39";

    constant C_A: std_logic_vector(7 downto 0) := x"41";
    constant C_B: std_logic_vector(7 downto 0) := x"42";
    constant C_C: std_logic_vector(7 downto 0) := x"43";
    constant C_D: std_logic_vector(7 downto 0) := x"44";
    constant C_E: std_logic_vector(7 downto 0) := x"45";
    constant C_F: std_logic_vector(7 downto 0) := x"46";
    constant C_G: std_logic_vector(7 downto 0) := x"47";
    constant C_H: std_logic_vector(7 downto 0) := x"48";
    constant C_I: std_logic_vector(7 downto 0) := x"49";
    constant C_J: std_logic_vector(7 downto 0) := x"4a";
    constant C_K: std_logic_vector(7 downto 0) := x"4b";
    constant C_L: std_logic_vector(7 downto 0) := x"4c";
    constant C_M: std_logic_vector(7 downto 0) := x"4d";
    constant C_N: std_logic_vector(7 downto 0) := x"4e";
    constant C_O: std_logic_vector(7 downto 0) := x"4f";
    constant C_P: std_logic_vector(7 downto 0) := x"50";
    constant C_Q: std_logic_vector(7 downto 0) := x"51";
    constant C_R: std_logic_vector(7 downto 0) := x"52";
    constant C_S: std_logic_vector(7 downto 0) := x"53";
    constant C_T: std_logic_vector(7 downto 0) := x"54";
    constant C_U: std_logic_vector(7 downto 0) := x"55";
    constant C_V: std_logic_vector(7 downto 0) := x"56";
    constant C_W: std_logic_vector(7 downto 0) := x"57";
    constant C_X: std_logic_vector(7 downto 0) := x"58";
    constant C_Y: std_logic_vector(7 downto 0) := x"59";
    constant C_Z: std_logic_vector(7 downto 0) := x"5a";

    type state is (
        ST_DLNF,
        ST_CUR,
        ST_DCB,
        ST_CGRAM,
        WR_CGRAM,
        ST_DDRAM,
        WR_DATA
    );

    signal s_state: state := ST_DLNF;

    type ram is array(0 to 31) of std_logic_vector(7 downto 0);

    signal s_cgram: ram;
begin
    process (p_op, p_mode, p_rs, p_rd) is
    begin
        s_cgram <= (
            C_SP, C_SP, C_SP, C_SP, C_SP, C_SP, C_SP, C_SP,
            C_SP, C_SP, C_SP, C_SP, C_SP, C_R,  C_D,  C_SP,
            C_SP, C_SP, C_SP, C_SP, C_SP, C_SP, C_SP, C_SP,
            C_SP, C_SP, C_SP, C_SP, C_SP, C_R,  C_S,  C_SP
        );

        case p_op is
            when "000000" => s_cgram(0 to 3) <= (C_W,  C_R,  C_SP, C_SP);
            when "000001" => s_cgram(0 to 3) <= (C_R,  C_D,  C_SP, C_SP);
            when "000010" => s_cgram(0 to 3) <= (C_M,  C_O,  C_V,  C_SP);
            when "001000" => s_cgram(0 to 3) <= (C_N,  C_O,  C_T,  C_SP);
            when "001001" => s_cgram(0 to 3) <= (C_A,  C_N,  C_D,  C_SP);
            when "001010" => s_cgram(0 to 3) <= (C_O,  C_R,  C_SP, C_SP);
            when "001011" => s_cgram(0 to 3) <= (C_X,  C_O,  C_R,  C_SP);
            when "001101" => s_cgram(0 to 3) <= (C_N,  C_A,  C_N,  C_D );
            when "001110" => s_cgram(0 to 3) <= (C_N,  C_O,  C_R,  C_SP);
            when "001111" => s_cgram(0 to 3) <= (C_X,  C_N,  C_O,  C_R );
            when "010000" => s_cgram(0 to 3) <= (C_S,  C_L,  C_L,  C_SP);
            when "010001" => s_cgram(0 to 3) <= (C_S,  C_R,  C_L,  C_SP);
            when "010010" => s_cgram(0 to 3) <= (C_S,  C_L,  C_A,  C_SP);
            when "010011" => s_cgram(0 to 3) <= (C_S,  C_R,  C_A,  C_SP);
            when "010100" => s_cgram(0 to 3) <= (C_R,  C_O,  C_L,  C_SP);
            when "010101" => s_cgram(0 to 3) <= (C_R,  C_O,  C_R,  C_SP);
            when "000100" => s_cgram(0 to 3) <= (C_I,  C_W,  C_R,  C_0 );
            when "000101" => s_cgram(0 to 3) <= (C_I,  C_W,  C_R,  C_1 );
            when "011000" => s_cgram(0 to 3) <= (C_I,  C_A,  C_B,  C_S );
            when "011001" => s_cgram(0 to 3) <= (C_I,  C_C,  C_H,  C_S );
            when "011010" => s_cgram(0 to 3) <= (C_I,  C_A,  C_D,  C_D );
            when "011011" => s_cgram(0 to 3) <= (C_I,  C_S,  C_U,  C_B );
            when "011100" => s_cgram(0 to 3) <= (C_I,  C_M,  C_U,  C_L );
            when "011101" => s_cgram(0 to 3) <= (C_I,  C_D,  C_I,  C_V );
            when "011111" => s_cgram(0 to 3) <= (C_I,  C_C,  C_M,  C_P );
            when "100000" => s_cgram(0 to 3) <= (C_F,  C_W,  C_R,  C_0 );
            when "100001" => s_cgram(0 to 3) <= (C_F,  C_W,  C_R,  C_1 );
            when "100010" => s_cgram(0 to 3) <= (C_F,  C_W,  C_R,  C_P );
            when "100011" => s_cgram(0 to 3) <= (C_F,  C_W,  C_R,  C_E );
            when "101000" => s_cgram(0 to 3) <= (C_F,  C_A,  C_B,  C_S );
            when "101001" => s_cgram(0 to 3) <= (C_F,  C_C,  C_H,  C_S );
            when "101010" => s_cgram(0 to 3) <= (C_F,  C_A,  C_D,  C_D );
            when "101011" => s_cgram(0 to 3) <= (C_F,  C_S,  C_U,  C_B );
            when "101100" => s_cgram(0 to 3) <= (C_F,  C_M,  C_U,  C_L );
            when "101101" => s_cgram(0 to 3) <= (C_F,  C_D,  C_I,  C_V );
            when "101111" => s_cgram(0 to 3) <= (C_F,  C_C,  C_M,  C_P );
            when others => null;
        end case;

        case p_mode is
            when "001" => s_cgram(16 to 19) <= (C_R, C_O, C_U, C_T );
            when "010" => s_cgram(16 to 19) <= (C_R, C_I, C_N, C_SP);
            when "100" => s_cgram(16 to 19) <= (C_W, C_I, C_N, C_SP);
            when others => null;
        end case;

        case p_rd is
            when "000" => s_cgram(15) <= C_0;
            when "001" => s_cgram(15) <= C_1;
            when "010" => s_cgram(15) <= C_2;
            when "011" => s_cgram(15) <= C_3;
            when "100" => s_cgram(15) <= C_4;
            when "101" => s_cgram(15) <= C_5;
            when "110" => s_cgram(15) <= C_6;
            when "111" => s_cgram(15) <= C_7;
            when others => null;
        end case;

        case p_rs is
            when "000" => s_cgram(31) <= C_0;
            when "001" => s_cgram(31) <= C_1;
            when "010" => s_cgram(31) <= C_2;
            when "011" => s_cgram(31) <= C_3;
            when "100" => s_cgram(31) <= C_4;
            when "101" => s_cgram(31) <= C_5;
            when "110" => s_cgram(31) <= C_6;
            when "111" => s_cgram(31) <= C_7;
            when others => null;
        end case;
    end process;

    p_lcd_rw <= '0';
    p_lcd_en <= p_cl;

    process (p_cl) is
        variable v_ctr: natural range 0 to 31 := 0;
    begin
        if p_cl'event and p_cl = '1' then
            p_lcd_rs <= '0';

            case s_state is
                when ST_DLNF =>
                    p_lcd_d <= "00000001";
                    s_state <= ST_CUR;
                when ST_CUR =>
                    p_lcd_d <= "00111000";
                    s_state <= ST_DCB;
                when ST_DCB =>
                    p_lcd_d <= "00001100";
                    s_state <= ST_CGRAM;
                when ST_CGRAM =>
                    p_lcd_d <= "00000110";
                    s_state <= WR_CGRAM;
                when WR_CGRAM =>
                    p_lcd_rs <= '1';
                    p_lcd_d  <= s_cgram(v_ctr);
                    s_state  <= ST_DDRAM;
                when ST_DDRAM =>
                    v_ctr := v_ctr + 1;

                    if v_ctr < 16 then
                        p_lcd_d <= "10000000" + v_ctr;
                    else
                        p_lcd_d <= "11000000" + v_ctr - 16;
                    end if;

                    s_state <= WR_DATA;
                when WR_DATA =>
                    p_lcd_d <= "00000000";
                    s_state <= ST_CUR;
                when others =>
                    null;
            end case;
        end if;
    end process;
end architecture rtl;
