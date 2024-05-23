library ieee;

use ieee.std_logic_1164.all;

entity t_mcp is
end entity t_mcp;

architecture rtl of t_mcp is
    signal s_op: std_logic_vector(5 downto 0);
    signal s_rd: std_logic_vector(2 downto 0);
    signal s_rs: std_logic_vector(2 downto 0);
    signal s_d:  std_logic_vector(31 downto 0);
    signal s_st: std_logic;
    signal s_cl: std_logic := '0';
    signal s_q:  std_logic_vector(31 downto 0);
    signal s_fl: std_logic_vector(9 downto 0);
begin
    uut: entity work.e_mcp
    port map (
        p_op => s_op,
        p_rd => s_rd,
        p_rs => s_rs,
        p_d  => s_d,
        p_st => s_st,
        p_cl => s_cl,
        p_q  => s_q,
        p_fl => s_fl
    );

    s_cl <= not s_cl after 10 ns;

    process is
    begin
        s_op <= "000000"; -- WR 6
        s_rd <= "110";
        s_rs <= "000";
        s_d  <= "00010000000000000000000000000000";
        s_st <= '0';
        wait for 40 ns;

        s_st <= '1';
        wait for 100 ns;

        s_st <= '0';
        wait for 100 ns;

        s_op <= "000000"; -- WR 2
        s_rd <= "010";
        s_rs <= "000";
        s_d  <= "00000000000000000000000000000011";
        s_st <= '0';
        wait for 40 ns;

        s_st <= '1';
        wait for 100 ns;

        s_st <= '0';
        wait for 100 ns;

        s_op <= "010000"; -- SLL
        s_rd <= "110";
        s_rs <= "010";
        s_d  <= (others => '0');
        s_st <= '0';
        wait for 40 ns;

        s_st <= '1';
        wait for 100 ns;

        s_st <= '0';
        wait;
    end process;
end architecture rtl;
