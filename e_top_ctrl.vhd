library ieee;

use ieee.std_logic_1164.all;

entity e_top_ctrl is
port (
    p_sc: in  std_logic;
    p_pr: in  std_logic;
    p_cl: in  std_logic;
    p_q:  out std_logic_vector(5 downto 0)
);
end entity e_top_ctrl;

architecture rtl of e_top_ctrl is
    type state is
    (
        C_WR,   C_RD,   C_MOV,  C_NOT,  C_AND,  C_OR,
        C_XOR,  C_NAND, C_NOR,  C_XNOR, C_SLL,  C_SRL,
        C_SLA,  C_SRA,  C_ROL,  C_ROR,  C_IWR0, C_IWR1,
        C_IABS, C_ICHS, C_IADD, C_ISUB, C_IMUL, C_IDIV,
        C_ICMP, C_FWR0, C_FWR1, C_FWRP, C_FWRE, C_FABS,
        C_FCHS, C_FADD, C_FSUB, C_FMUL, C_FDIV, C_FCMP
    );

    signal s_state: state := C_WR;
begin
    process (p_cl) is
    begin
        if p_cl'event and p_cl = '1' then
            if p_sc = '1' and p_pr = '0' then
                s_state <= state'succ(s_state);
            elsif p_sc = '0' and p_pr = '1' then
                s_state <= state'pred(s_state);
            end if;
        end if;
    end process;

    process (s_state) is
    begin
        case s_state is
            when C_WR   => p_q <= "000000";
            when C_RD   => p_q <= "000001";
            when C_MOV  => p_q <= "000010";
            when C_NOT  => p_q <= "001000";
            when C_AND  => p_q <= "001001";
            when C_OR   => p_q <= "001010";
            when C_XOR  => p_q <= "001011";
            when C_NAND => p_q <= "001101";
            when C_NOR  => p_q <= "001110";
            when C_XNOR => p_q <= "001111";
            when C_SLL  => p_q <= "010000";
            when C_SRL  => p_q <= "010001";
            when C_SLA  => p_q <= "010010";
            when C_SRA  => p_q <= "010011";
            when C_ROL  => p_q <= "010100";
            when C_ROR  => p_q <= "010101";
            when C_IWR0 => p_q <= "000100";
            when C_IWR1 => p_q <= "000101";
            when C_IABS => p_q <= "011000";
            when C_ICHS => p_q <= "011001";
            when C_IADD => p_q <= "011010";
            when C_ISUB => p_q <= "011011";
            when C_IMUL => p_q <= "011100";
            when C_IDIV => p_q <= "011101";
            when C_ICMP => p_q <= "011111";
            when C_FWR0 => p_q <= "100000";
            when C_FWR1 => p_q <= "100001";
            when C_FWRP => p_q <= "100010";
            when C_FWRE => p_q <= "100011";
            when C_FABS => p_q <= "101000";
            when C_FCHS => p_q <= "101001";
            when C_FADD => p_q <= "101010";
            when C_FSUB => p_q <= "101011";
            when C_FMUL => p_q <= "101100";
            when C_FDIV => p_q <= "101101";
            when C_FCMP => p_q <= "101111";
        end case;
    end process;
end architecture rtl;
