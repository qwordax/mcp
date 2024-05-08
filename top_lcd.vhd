library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_lcd is
port (
    op:     in  std_logic_vector(5 downto 0);
    rs:     in  std_logic_vector(2 downto 0);
    rd:     in  std_logic_vector(2 downto 0);
    mode:   in  std_logic_vector(1 downto 0);
    cl:     in  std_logic;
    lcd_rs: out std_logic;
    lcd_rw: out std_logic;
    lcd_en: out std_logic;
    lcd_d:  out std_logic_vector(7 downto 0)
);
end entity top_lcd;

architecture rtl of top_lcd is
    constant c_sp: std_logic_vector(7 downto 0) := x"20";
    constant c_0:  std_logic_vector(7 downto 0) := x"30";
    constant c_1:  std_logic_vector(7 downto 0) := x"31";
    constant c_2:  std_logic_vector(7 downto 0) := x"32";
    constant c_3:  std_logic_vector(7 downto 0) := x"33";
    constant c_4:  std_logic_vector(7 downto 0) := x"34";
    constant c_5:  std_logic_vector(7 downto 0) := x"35";
    constant c_6:  std_logic_vector(7 downto 0) := x"36";
    constant c_7:  std_logic_vector(7 downto 0) := x"37";
    constant c_8:  std_logic_vector(7 downto 0) := x"38";
    constant c_9:  std_logic_vector(7 downto 0) := x"39";
    constant c_a:  std_logic_vector(7 downto 0) := x"41";
    constant c_b:  std_logic_vector(7 downto 0) := x"42";
    constant c_c:  std_logic_vector(7 downto 0) := x"43";
    constant c_d:  std_logic_vector(7 downto 0) := x"44";
    constant c_e:  std_logic_vector(7 downto 0) := x"45";
    constant c_f:  std_logic_vector(7 downto 0) := x"46";
    constant c_g:  std_logic_vector(7 downto 0) := x"47";
    constant c_h:  std_logic_vector(7 downto 0) := x"48";
    constant c_i:  std_logic_vector(7 downto 0) := x"49";
    constant c_j:  std_logic_vector(7 downto 0) := x"4a";
    constant c_k:  std_logic_vector(7 downto 0) := x"4b";
    constant c_l:  std_logic_vector(7 downto 0) := x"4c";
    constant c_m:  std_logic_vector(7 downto 0) := x"4d";
    constant c_n:  std_logic_vector(7 downto 0) := x"4e";
    constant c_o:  std_logic_vector(7 downto 0) := x"4f";
    constant c_p:  std_logic_vector(7 downto 0) := x"50";
    constant c_q:  std_logic_vector(7 downto 0) := x"51";
    constant c_r:  std_logic_vector(7 downto 0) := x"52";
    constant c_s:  std_logic_vector(7 downto 0) := x"53";
    constant c_t:  std_logic_vector(7 downto 0) := x"54";
    constant c_u:  std_logic_vector(7 downto 0) := x"55";
    constant c_v:  std_logic_vector(7 downto 0) := x"56";
    constant c_w:  std_logic_vector(7 downto 0) := x"57";
    constant c_x:  std_logic_vector(7 downto 0) := x"58";
    constant c_y:  std_logic_vector(7 downto 0) := x"59";
    constant c_z:  std_logic_vector(7 downto 0) := x"5a";

    type state_type is (
        set_dlnf,
        set_cur,
        set_dcb,
        set_cgram,
        wr_cgram,
        set_ddram,
        wr_data
    );

    signal state: state_type := set_dlnf;

    type ram is array(0 to 31) of std_logic_vector(7 downto 0);

    signal s_cgram: ram := (
        c_sp, c_sp, c_sp, c_sp, c_sp, c_sp, c_sp, c_sp, -- 1
        c_sp, c_sp, c_sp, c_sp, c_sp, c_r,  c_s,  c_sp,
        c_sp, c_sp, c_sp, c_sp, c_sp, c_sp, c_sp, c_sp, -- 2
        c_sp, c_sp, c_sp, c_sp, c_sp, c_r,  c_s,  c_sp
    );
begin
    process (op) is
    begin
        case op is
            when "000000" =>
                s_cgram(0) <= c_w; -- WR
                s_cgram(1) <= c_r;
                s_cgram(2) <= c_sp;
                s_cgram(3) <= c_sp;
            when "000001" =>
                s_cgram(0) <= c_r; -- RD
                s_cgram(1) <= c_d;
                s_cgram(2) <= c_sp;
                s_cgram(3) <= c_sp;
            when "000010" =>
                s_cgram(0) <= c_m; -- MOV
                s_cgram(1) <= c_o;
                s_cgram(2) <= c_v;
                s_cgram(3) <= c_sp;
            when "001000" =>
                s_cgram(0) <= c_n; -- NOT
                s_cgram(1) <= c_o;
                s_cgram(2) <= c_t;
                s_cgram(3) <= c_sp;
            when "001001" =>
                s_cgram(0) <= c_a; -- AND
                s_cgram(1) <= c_n;
                s_cgram(2) <= c_d;
                s_cgram(3) <= c_sp;
            when "001010" =>
                s_cgram(0) <= c_o; -- OR
                s_cgram(1) <= c_r;
                s_cgram(2) <= c_sp;
                s_cgram(3) <= c_sp;
            when "001011" =>
                s_cgram(0) <= c_x; -- XOR
                s_cgram(1) <= c_o;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_sp;
            when "001101" =>
                s_cgram(0) <= c_n; -- NAND
                s_cgram(1) <= c_a;
                s_cgram(2) <= c_n;
                s_cgram(3) <= c_d;
            when "001110" =>
                s_cgram(0) <= c_n; -- NOR
                s_cgram(1) <= c_o;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_sp;
            when "001111" =>
                s_cgram(0) <= c_x; -- XNOR
                s_cgram(1) <= c_n;
                s_cgram(2) <= c_o;
                s_cgram(3) <= c_r;
            when "010000" =>
                s_cgram(0) <= c_s; -- SLL
                s_cgram(1) <= c_l;
                s_cgram(2) <= c_l;
                s_cgram(3) <= c_sp;
            when "010001" =>
                s_cgram(0) <= c_s; -- SRL
                s_cgram(1) <= c_r;
                s_cgram(2) <= c_l;
                s_cgram(3) <= c_sp;
            when "010010" =>
                s_cgram(0) <= c_s; -- SLA
                s_cgram(1) <= c_l;
                s_cgram(2) <= c_a;
                s_cgram(3) <= c_sp;
            when "010011" =>
                s_cgram(0) <= c_s; -- SRA
                s_cgram(1) <= c_r;
                s_cgram(2) <= c_a;
                s_cgram(3) <= c_sp;
            when "010100" =>
                s_cgram(0) <= c_r; -- ROL
                s_cgram(1) <= c_o;
                s_cgram(2) <= c_l;
                s_cgram(3) <= c_sp;
            when "010101" =>
                s_cgram(0) <= c_r; -- ROR
                s_cgram(1) <= c_o;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_sp;
            when "000100" =>
                s_cgram(0) <= c_i; -- IWR0
                s_cgram(1) <= c_w;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_0;
            when "000101" =>
                s_cgram(0) <= c_i; -- IWR1
                s_cgram(1) <= c_w;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_1;
            when "011000" =>
                s_cgram(0) <= c_i; -- IABS
                s_cgram(1) <= c_a;
                s_cgram(2) <= c_b;
                s_cgram(3) <= c_s;
            when "011001" =>
                s_cgram(0) <= c_i; -- ICHS
                s_cgram(1) <= c_c;
                s_cgram(2) <= c_h;
                s_cgram(3) <= c_s;
            when "011010" =>
                s_cgram(0) <= c_i; -- IADD
                s_cgram(1) <= c_a;
                s_cgram(2) <= c_d;
                s_cgram(3) <= c_d;
            when "011011" =>
                s_cgram(0) <= c_i; -- ISUB
                s_cgram(1) <= c_s;
                s_cgram(2) <= c_u;
                s_cgram(3) <= c_b;
            when "011100" =>
                s_cgram(0) <= c_i; -- IMUL
                s_cgram(1) <= c_m;
                s_cgram(2) <= c_u;
                s_cgram(3) <= c_l;
            when "011101" =>
                s_cgram(0) <= c_i; -- IDIV
                s_cgram(1) <= c_d;
                s_cgram(2) <= c_i;
                s_cgram(3) <= c_v;
            when "011111" =>
                s_cgram(0) <= c_i; -- ICMP
                s_cgram(1) <= c_c;
                s_cgram(2) <= c_m;
                s_cgram(3) <= c_p;
            when "100000" =>
                s_cgram(0) <= c_f; -- FWR0
                s_cgram(1) <= c_w;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_0;
            when "100001" =>
                s_cgram(0) <= c_f; -- FWR1
                s_cgram(1) <= c_w;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_1;
            when "100010" =>
                s_cgram(0) <= c_f; -- FWRP
                s_cgram(1) <= c_w;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_p;
            when "100011" =>
                s_cgram(0) <= c_f; -- FWRE
                s_cgram(1) <= c_w;
                s_cgram(2) <= c_r;
                s_cgram(3) <= c_e;
            when "101000" =>
                s_cgram(0) <= c_f; -- FABS
                s_cgram(1) <= c_a;
                s_cgram(2) <= c_b;
                s_cgram(3) <= c_s;
            when "101001" =>
                s_cgram(0) <= c_f; -- FCHS
                s_cgram(1) <= c_c;
                s_cgram(2) <= c_h;
                s_cgram(3) <= c_s;
            when "101010" =>
                s_cgram(0) <= c_f; -- FADD
                s_cgram(1) <= c_a;
                s_cgram(2) <= c_d;
                s_cgram(3) <= c_d;
            when "101011" =>
                s_cgram(0) <= c_f; -- FSUB
                s_cgram(1) <= c_s;
                s_cgram(2) <= c_u;
                s_cgram(3) <= c_b;
            when "101100" =>
                s_cgram(0) <= c_f; -- FMUL
                s_cgram(1) <= c_m;
                s_cgram(2) <= c_u;
                s_cgram(3) <= c_l;
            when "101101" =>
                s_cgram(0) <= c_f; -- FDIV
                s_cgram(1) <= c_d;
                s_cgram(2) <= c_i;
                s_cgram(3) <= c_v;
            when "101111" =>
                s_cgram(0) <= c_f; -- FCMP
                s_cgram(1) <= c_c;
                s_cgram(2) <= c_m;
                s_cgram(3) <= c_p;
            when "111000" =>
                s_cgram(0) <= c_i; -- ITOF
                s_cgram(1) <= c_t;
                s_cgram(2) <= c_o;
                s_cgram(3) <= c_f;
            when "111001" =>
                s_cgram(0) <= c_f; -- FTOI
                s_cgram(1) <= c_t;
                s_cgram(2) <= c_o;
                s_cgram(3) <= c_i;
            when others =>
                null;
        end case;
    end process;

    process (rs) is
    begin
        case rs is
            when "000"  => s_cgram(15) <= c_0;
            when "001"  => s_cgram(15) <= c_1;
            when "010"  => s_cgram(15) <= c_2;
            when "011"  => s_cgram(15) <= c_3;
            when "100"  => s_cgram(15) <= c_4;
            when "101"  => s_cgram(15) <= c_5;
            when "110"  => s_cgram(15) <= c_6;
            when "111"  => s_cgram(15) <= c_7;
            when others => null;
        end case;
    end process;

    process (rd) is
    begin
        case rd is
            when "000"  => s_cgram(31) <= c_0;
            when "001"  => s_cgram(31) <= c_1;
            when "010"  => s_cgram(31) <= c_2;
            when "011"  => s_cgram(31) <= c_3;
            when "100"  => s_cgram(31) <= c_4;
            when "101"  => s_cgram(31) <= c_5;
            when "110"  => s_cgram(31) <= c_6;
            when "111"  => s_cgram(31) <= c_7;
            when others => null;
        end case;
    end process;

    process (mode) is
    begin
        case mode is
            when "00" =>
                s_cgram(16) <= c_r;
                s_cgram(17) <= c_o;
                s_cgram(18) <= c_u;
                s_cgram(19) <= c_t;
            when "01" =>
                s_cgram(16) <= c_r;
                s_cgram(17) <= c_i;
                s_cgram(18) <= c_n;
                s_cgram(19) <= c_sp;
            when "10" =>
                s_cgram(16) <= c_r;
                s_cgram(17) <= c_o;
                s_cgram(18) <= c_u;
                s_cgram(19) <= c_t;
            when "11" =>
                s_cgram(16) <= c_w;
                s_cgram(17) <= c_i;
                s_cgram(18) <= c_n;
                s_cgram(19) <= c_sp;
            when others =>
                null;
        end case;
    end process;

    lcd_rw <= '0';
    lcd_en <= cl;

    process (cl) is
        variable v_ctr: natural range 0 to 31 := 0;
    begin
        if cl'event and cl = '1' then
            lcd_rs <= '0';

            case state is
                when set_dlnf =>
                    lcd_d <= "00000001";
                    state <= set_cur;
                when set_cur =>
                    lcd_d <= "00111000";
                    state <= set_dcb;
                when set_dcb =>
                    lcd_d <= "00001100";
                    state <= set_cgram;
                when set_cgram =>
                    lcd_d <= "00000110";
                    state <= wr_cgram;
                when wr_cgram =>
                    lcd_rs <= '1';
                    lcd_d  <= s_cgram(v_ctr);
                    state  <= set_ddram;
                when set_ddram =>
                    v_ctr := v_ctr + 1;

                    if v_ctr < 16 then
                        lcd_d <= "10000000" + v_ctr;
                    else
                        lcd_d <= "11000000" + v_ctr - 16;
                    end if;

                    state <= wr_data;
                when wr_data =>
                    lcd_d <= "00000000";
                    state <= set_cur;
                when others =>
                    null;
            end case;
        end if;
    end process;
end architecture rtl;
