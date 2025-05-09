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

entity ram_xeta is
generic (w: integer:= 16;
        r : integer := 2);
 Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
          DIN : in std_logic_vector( w-1 downto 0);
           addr : in std_logic_vector( 1 downto 0);
           dout : out std_logic_vector(w-1 downto 0));
           
end ram_xeta;

architecture Behavioral of ram_xeta is
type ram_xeta_type is array (0 to 2**r-1)
of std_logic_vector (w-1 downto 0);
signal RAM : ram_xeta_type := (others => (others => '0')); 
signal  K_i: std_logic_vector(w-1 downto 0);

begin

process (clk)
begin
if rising_edge(clk) then
if (we = '1') then
RAM(to_integer(unsigned(addr))) <= DIN;
end if;
end if;
end process;
dout <= RAM(to_integer(unsigned(addr)));


end Behavioral;
