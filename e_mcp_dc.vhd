library ieee;

use ieee.std_logic_1164.all;

entity e_mcp_dc is
port (
    p_op:  in  std_logic_vector(5 downto 0);
    p_cmd: out std_logic_vector(36 downto 0)
);
end entity e_mcp_dc;

architecture rtl of e_mcp_dc is
begin
    process (p_op) is
    begin
        p_cmd <= (others => '0');

        case p_op is
            when "000000" => p_cmd(1)  <= '1'; -- WR
            when "000001" => p_cmd(2)  <= '1'; -- RD
            when "000010" => p_cmd(3)  <= '1'; -- MOV
            when "001000" => p_cmd(4)  <= '1'; -- NOT
            when "001001" => p_cmd(5)  <= '1'; -- AND
            when "001010" => p_cmd(6)  <= '1'; -- OR
            when "001011" => p_cmd(7)  <= '1'; -- XOR
            when "001101" => p_cmd(8)  <= '1'; -- NAND
            when "001110" => p_cmd(9)  <= '1'; -- NOR
            when "001111" => p_cmd(10) <= '1'; -- XNOR
            when "010000" => p_cmd(11) <= '1'; -- SLL
            when "010001" => p_cmd(12) <= '1'; -- SRL
            when "010010" => p_cmd(13) <= '1'; -- SLA
            when "010011" => p_cmd(14) <= '1'; -- SRA
            when "010100" => p_cmd(15) <= '1'; -- ROL
            when "010101" => p_cmd(16) <= '1'; -- ROR
            when "000100" => p_cmd(17) <= '1'; -- IWR0
            when "000101" => p_cmd(18) <= '1'; -- IWR1
            when "011000" => p_cmd(19) <= '1'; -- IABS
            when "011001" => p_cmd(20) <= '1'; -- ICHS
            when "011010" => p_cmd(21) <= '1'; -- IADD
            when "011011" => p_cmd(22) <= '1'; -- ISUB
            when "011100" => p_cmd(23) <= '1'; -- IMUL
            when "011101" => p_cmd(24) <= '1'; -- IDIV
            when "011111" => p_cmd(25) <= '1'; -- ICMP
            when "100000" => p_cmd(26) <= '1'; -- FWR0
            when "100001" => p_cmd(27) <= '1'; -- FWR1
            when "100010" => p_cmd(28) <= '1'; -- FWRP
            when "100011" => p_cmd(29) <= '1'; -- FWRE
            when "101000" => p_cmd(30) <= '1'; -- FABS
            when "101001" => p_cmd(31) <= '1'; -- FCHS
            when "101010" => p_cmd(32) <= '1'; -- FADD
            when "101011" => p_cmd(33) <= '1'; -- FSUB
            when "101100" => p_cmd(34) <= '1'; -- FMUL
            when "101101" => p_cmd(35) <= '1'; -- FDIV
            when "101111" => p_cmd(36) <= '1'; -- FCMP
            when others   => p_cmd(0)  <= '1';
        end case;
    end process;
end architecture rtl;
