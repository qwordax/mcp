library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_ctrl is
port (
    p_r:    in  std_logic;
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_cl:   in  std_logic;
    p_en:   in  std_logic;
    p_ctrl: out std_logic_vector(13 downto 0)
);
end entity e_mcp_ctrl;

architecture rtl of e_mcp_ctrl is
    type state is
    (
        C_ST,   C_RIN0, C_RIN1, C_RDR0, C_RDR1,
        C_RCU0, C_RCU1, C_RC0,  C_RC1,  C_WDR,
        C_WOUT, C_WFL,  C_CU0,  C_CU1,  C_CU2,
        C_CU3,  C_CU4,  C_BSY
    );

    signal s_state: state := C_ST;

    signal s_ctrl: std_logic_vector(13 downto 0);
begin
    process (p_r, p_cl, p_cmd) is
    begin
        if p_r = '1' then
            s_state <= C_ST;
        elsif p_cl'event and p_cl = '0' and p_en = '1' then
            if p_cmd(0) = '1' then
                case s_state is
                    when C_ST   => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(1) = '1' then -- WR
                case s_state is
                    when C_ST   => s_state <= C_RIN0;
                    when C_RIN0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RIN1;
                    when C_RIN1 => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(2) = '1' then -- RD
                case s_state is
                    when C_ST   => s_state <= C_RDR0;
                    when C_RDR0 => s_state <= C_WOUT;
                    when C_WOUT => s_state <= C_RDR1;
                    when C_RDR1 => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(3) = '1' then -- MOV
                case s_state is
                    when C_ST   => s_state <= C_RDR0;
                    when C_RDR0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RDR1;
                    when C_RDR1 => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(4) = '1' then -- NOT
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(5) = '1' then -- AND
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(6) = '1' then -- OR
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(7) = '1' then -- XOR
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(8) = '1' then -- NAND
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(9) = '1' then -- NOR
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(10) = '1' then -- XNOR
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(11) = '1' then -- SLL
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_CU1;
                    when C_CU1  => s_state <= C_CU2;
                    when C_CU2  => s_state <= C_RCU0; -- TODO
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(12) = '1' then -- SRL
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_CU1;
                    when C_CU1  => s_state <= C_CU2;
                    when C_CU2  => s_state <= C_RCU0; -- TODO
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(13) = '1' then -- SLA
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_CU1;
                    when C_CU1  => s_state <= C_CU2;
                    when C_CU2  => s_state <= C_RCU0; -- TODO
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(14) = '1' then -- SRA
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_CU1;
                    when C_CU1  => s_state <= C_CU2;
                    when C_CU2  => s_state <= C_RCU0; -- TODO
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(15) = '1' then -- ROL
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_CU1;
                    when C_CU1  => s_state <= C_CU2;
                    when C_CU2  => s_state <= C_RCU0; -- TODO
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(16) = '1' then -- ROR
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_CU1;
                    when C_CU1  => s_state <= C_CU2;
                    when C_CU2  => s_state <= C_RCU0; -- TODO
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(17) = '1' then -- IWR0
                case s_state is
                    when C_ST   => s_state <= C_RC0;
                    when C_RC0  => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RC1;
                    when C_RC1  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(18) = '1' then -- IWR1
                case s_state is
                    when C_ST   => s_state <= C_RC0;
                    when C_RC0  => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RC1;
                    when C_RC1  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(19) = '1' then -- IABS
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(20) = '1' then -- ICHS
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(21) = '1' then -- IADD
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(22) = '1' then -- ISUB
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(23) = '1' then -- IMUL
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_CU1;
                    when C_CU1  => s_state <= C_RCU0; -- TODO
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(24) = '1' then -- IDIV
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_CU1;
                    when C_CU1  => s_state <= C_RCU0; -- TODO
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(25) = '1' then -- ICMP
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(26) = '1' then -- FWR0
                case s_state is
                    when C_ST   => s_state <= C_RC0;
                    when C_RC0  => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RC1;
                    when C_RC1  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(27) = '1' then -- FWR1
                case s_state is
                    when C_ST   => s_state <= C_RC0;
                    when C_RC0  => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RC1;
                    when C_RC1  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(28) = '1' then -- FWRP
                case s_state is
                    when C_ST   => s_state <= C_RC0;
                    when C_RC0  => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RC1;
                    when C_RC1  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(29) = '1' then -- FWRE
                case s_state is
                    when C_ST   => s_state <= C_RC0;
                    when C_RC0  => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RC1;
                    when C_RC1  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(30) = '1' then -- FABS
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(31) = '1' then -- FCHS
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(32) = '1' then -- FADD
                case s_state is
                    when C_ST   => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(33) = '1' then -- FSUB
                case s_state is
                    when C_ST   => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(34) = '1' then -- FMUL
                case s_state is
                    when C_ST   => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(35) = '1' then -- FDIV
                case s_state is
                    when C_ST   => s_state <= C_BSY;
                    when others => null;
                end case;
            elsif p_cmd(36) = '1' then -- FCMP
                case s_state is
                    when C_ST   => s_state <= C_CU0;
                    when C_CU0  => s_state <= C_RCU0;
                    when C_RCU0 => s_state <= C_WDR;
                    when C_WDR  => s_state <= C_RCU1;
                    when C_RCU1 => s_state <= C_WFL;
                    when C_WFL  => s_state <= C_BSY;
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    process (s_state) is
    begin
        s_ctrl <= (others => '0');

        case s_state is
            when C_ST   => s_ctrl(0)  <= '1'; -- ST
            when C_RIN0 => s_ctrl(1)  <= '1'; -- RIN
            when C_RIN1 => s_ctrl(1)  <= '1'; -- RIN
            when C_RDR0 => s_ctrl(2)  <= '1'; -- RDR
            when C_RDR1 => s_ctrl(2)  <= '1'; -- RDR
            when C_RCU0 => s_ctrl(3)  <= '1'; -- RCU
            when C_RCU1 => s_ctrl(3)  <= '1'; -- RCU
            when C_RC0  => s_ctrl(4)  <= '1'; -- RC
            when C_RC1  => s_ctrl(4)  <= '1'; -- RC
            when C_WDR  => s_ctrl(5)  <= '1'; -- WDR
            when C_WOUT => s_ctrl(6)  <= '1'; -- WOUT
            when C_WFL  => s_ctrl(7)  <= '1'; -- WFL
            when C_CU0  => s_ctrl(8)  <= '1'; -- CU0
            when C_CU1  => s_ctrl(9)  <= '1'; -- CU1
            when C_CU2  => s_ctrl(10) <= '1'; -- CU2
            when C_CU3  => s_ctrl(11) <= '1'; -- CU3
            when C_CU4  => s_ctrl(12) <= '1'; -- CU4
            when C_BSY  => s_ctrl(13) <= '1'; -- BSY
        end case;
    end process;

    p_ctrl <= s_ctrl when p_en = '1' else (others => '0');
end architecture rtl;
