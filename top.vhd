library ieee;

use ieee.std_logic_1164.all;

entity top is
port (
    key:    in  std_logic_vector(3 downto 0);
    sw:     in  std_logic_vector(7 downto 0);
    cl:     in  std_logic;
    led:    out std_logic_vector(11 downto 0);
    sd_sg:  out std_logic_vector(7 downto 0);
    sd_cs:  out std_logic_vector(7 downto 0);
    lcd_rs: out std_logic;
    lcd_rw: out std_logic;
    lcd_en: out std_logic;
    lcd_d:  out std_logic_vector(7 downto 0)
);
end entity top;

architecture rtl of top is
begin

end architecture rtl;
