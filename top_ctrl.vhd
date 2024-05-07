library ieee;

use ieee.std_logic_1164.all;

entity top_ctrl is
port (
    u:  in  std_logic;
    d:  in  std_logic;
    cl: in  std_logic;
    q:  out std_logic_vector(5 downto 0)
);
end entity top_ctrl;

architecture rtl of top_ctrl is
    type state_type is
    (
        C_WR,   C_RD,   C_MOV,  C_NOT,  C_AND,  C_OR,
        C_XOR,  C_NAND, C_NOR,  C_XNOR, C_SLL,  C_SRL,
        C_SLA,  C_SRA,  C_ROL,  C_ROR,  C_IWR0, C_IWR1,
        C_IABS, C_ICHS, C_IADD, C_ISUB, C_IMUL, C_IDIV,
        C_ICMP, C_FWR0, C_FWR1, C_FWRP, C_FWRE, C_FABS,
        C_FCHS, C_FADD, C_FSUB, C_FMUL, C_FDIV, C_FCMP,
        C_ITOF, C_FTOI
    );

    signal state: state_type := C_WR;
begin
    process (cl) is
    begin
        if cl'event and cl = '1' then
            if u = '1' and d = '0' then
                state <= state_type'succ(state);
            elsif u = '0' and d = '1' then
                state <= state_type'pred(state);
            end if;
        end if;
    end process;

    process (state) is
    begin
        case state is
            when C_WR   => q <= "000000";
            when C_RD   => q <= "000001";
            when C_MOV  => q <= "000010";
            when C_NOT  => q <= "001000";
            when C_AND  => q <= "001001";
            when C_OR   => q <= "001010";
            when C_XOR  => q <= "001011";
            when C_NAND => q <= "001101";
            when C_NOR  => q <= "001110";
            when C_XNOR => q <= "001111";
            when C_SLL  => q <= "010000";
            when C_SRL  => q <= "010001";
            when C_SLA  => q <= "010010";
            when C_SRA  => q <= "010011";
            when C_ROL  => q <= "010100";
            when C_ROR  => q <= "010101";
            when C_IWR0 => q <= "000100";
            when C_IWR1 => q <= "000101";
            when C_IABS => q <= "011000";
            when C_ICHS => q <= "011001";
            when C_IADD => q <= "011010";
            when C_ISUB => q <= "011011";
            when C_IMUL => q <= "011100";
            when C_IDIV => q <= "011101";
            when C_ICMP => q <= "011111";
            when C_FWR0 => q <= "100000";
            when C_FWR1 => q <= "100001";
            when C_FWRP => q <= "100010";
            when C_FWRE => q <= "100011";
            when C_FABS => q <= "101000";
            when C_FCHS => q <= "101001";
            when C_FADD => q <= "101010";
            when C_FSUB => q <= "101011";
            when C_FMUL => q <= "101100";
            when C_FDIV => q <= "101101";
            when C_FCMP => q <= "101111";
            when C_ITOF => q <= "111000";
            when C_FTOI => q <= "111001";
        end case;
    end process;
end architecture rtl;
