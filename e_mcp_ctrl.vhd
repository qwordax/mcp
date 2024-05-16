library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_ctrl is
port (
    p_r:    in  std_logic;
    p_cmd:  in  std_logic_vector(36 downto 0);
    p_cl:   in  std_logic;
    p_en:   in  std_logic;
    p_ctrl: out std_logic_vector(11 downto 0)
);
end entity e_mcp_ctrl;

architecture rtl of e_mcp_ctrl is
    constant C_ST:   natural := 0;
    constant C_RIN:  natural := 1;
    constant C_RDR:  natural := 2;
    constant C_RCU:  natural := 3;
    constant C_RC:   natural := 4;
    constant C_WDR:  natural := 5;
    constant C_WOUT: natural := 6;
    constant C_WFL:  natural := 7;
    constant C_CU0:  natural := 8;
    constant C_CU1:  natural := 9;
    constant C_CU2:  natural := 10;
    constant C_BSY:  natural := 11;

    signal s_ctrl: std_logic_vector(11 downto 0);
begin
    process (p_r, p_cl, p_cmd) is
        variable v_tmp: natural := 0;
    begin
        if p_r = '1' then
            v_tmp := 0;
        elsif p_cl'event and p_cl = '0' and p_en = '1' then
            if v_tmp < 31 then
                v_tmp := v_tmp + 1;
            else
                v_tmp := 0;
            end if;
        end if;

        s_ctrl <= (others => '0');

        if p_cmd(0) = '1' then
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(1) = '1' then -- WR
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_RIN) <= '1';
                when 2 => s_ctrl(C_WDR) <= '1';
                when 3 => s_ctrl(C_RIN) <= '1';
                when 4 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(2) = '1' then -- RD
            case v_tmp is
                when 0 => s_ctrl(C_ST)   <= '1';
                when 1 => s_ctrl(C_RDR)  <= '1';
                when 2 => s_ctrl(C_WOUT) <= '1';
                when 3 => s_ctrl(C_RDR)  <= '1';
                when 4 => s_ctrl(C_BSY)  <= '1';
                when others => null;
            end case;
        elsif p_cmd(3) = '1' then -- MOV
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_RDR) <= '1';
                when 2 => s_ctrl(C_WDR) <= '1';
                when 3 => s_ctrl(C_RDR) <= '1';
                when 4 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(4) = '1' then -- NOT
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(5) = '1' then -- AND
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(6) = '1' then -- OR
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(7) = '1' then -- XOR
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(8) = '1' then -- NAND
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(9) = '1' then -- NOR
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(10) = '1' then -- XNOR
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(11) = '1' then -- SLL
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(12) = '1' then -- SRL
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(13) = '1' then -- SLA
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(14) = '1' then -- SRA
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(15) = '1' then -- ROL
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(16) = '1' then -- ROR
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(17) = '1' then -- IWR0
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_RC)  <= '1';
                when 2 => s_ctrl(C_WDR) <= '1';
                when 3 => s_ctrl(C_RC)  <= '1';
                when 4 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(18) = '1' then -- IWR1
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_RC)  <= '1';
                when 2 => s_ctrl(C_WDR) <= '1';
                when 3 => s_ctrl(C_RC)  <= '1';
                when 4 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(19) = '1' then -- IABS
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(20) = '1' then -- ICHS
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(21) = '1' then -- IADD
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(22) = '1' then -- ISUB
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(23) = '1' then -- IMUL
            case v_tmp is
                when 0       => s_ctrl(C_ST)  <= '1';
                when 1       => s_ctrl(C_CU0) <= '1';
                when 2       => s_ctrl(C_CU1) <= '1';
                when 3 to 67 => s_ctrl(C_CU2) <= '1';
                when 68      => s_ctrl(C_CU1) <= '1';
                when 69      => s_ctrl(C_RCU) <= '1';
                when 70      => s_ctrl(C_WDR) <= '1';
                when 71      => s_ctrl(C_RCU) <= '1';
                when 72      => s_ctrl(C_WFL) <= '1';
                when 73      => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(24) = '1' then -- IDIV
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(25) = '1' then -- ICMP
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(26) = '1' then -- FWR0
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_RC)  <= '1';
                when 2 => s_ctrl(C_WDR) <= '1';
                when 3 => s_ctrl(C_RC)  <= '1';
                when 4 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(27) = '1' then -- FWR1
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_RC)  <= '1';
                when 2 => s_ctrl(C_WDR) <= '1';
                when 3 => s_ctrl(C_RC)  <= '1';
                when 4 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(28) = '1' then -- FWRP
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_RC)  <= '1';
                when 2 => s_ctrl(C_WDR) <= '1';
                when 3 => s_ctrl(C_RC)  <= '1';
                when 4 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(29) = '1' then -- FWRE
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_RC)  <= '1';
                when 2 => s_ctrl(C_WDR) <= '1';
                when 3 => s_ctrl(C_RC)  <= '1';
                when 4 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(30) = '1' then -- FABS
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(31) = '1' then -- FCHS
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(32) = '1' then -- FADD
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(33) = '1' then -- FSUB
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(34) = '1' then -- FMUL
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(35) = '1' then -- FDIV
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        elsif p_cmd(36) = '1' then -- FCMP
            case v_tmp is
                when 0 => s_ctrl(C_ST)  <= '1';
                when 1 => s_ctrl(C_CU0) <= '1';
                when 2 => s_ctrl(C_RCU) <= '1';
                when 3 => s_ctrl(C_WDR) <= '1';
                when 4 => s_ctrl(C_RCU) <= '1';
                when 5 => s_ctrl(C_WFL) <= '1';
                when 6 => s_ctrl(C_BSY) <= '1';
                when others => null;
            end case;
        end if;
    end process;

    p_ctrl <= s_ctrl when p_cl = '1' and p_en = '1' else (others => '0');
end architecture rtl;
