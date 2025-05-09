library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xeta_count is
    Port ( clk,load,en : in STD_LOGIC;
    D : in std_logic_vector (2 downto 0);
    
    jm1 :  out std_logic);
end xeta_count ;

architecture Behavioral of xeta_count is
signal count : unsigned(2 downto 0);
signal q : std_logic_vector( 2 downto 0);

begin
process (clk)
begin
 if rising_edge(clk) then

if load ='1' then
count<="000"  ;
else if en = '1' then
count <= count + 1;
end if;
end if;
end if;
end process;
q <= std_logic_vector(count);
jm1<= '1' when q = "010" else '0';

end Behavioral;
