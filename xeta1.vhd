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

entity xeta_1 is
generic ( w: integer:=16);
Port (
    K_i,M1,M2 : in std_logic_vector(w-1 downto 0);
         ldj,enj ,write_Ki,write_M,cycle_num,reset1,clock,enV0,enV1,en_sum,en_c:in std_logic;
 
 i : in std_logic_vector( 1 downto 0);
          
         zj : out std_logic;
          C : out std_logic_vector (2*w -1  downto 0)); 
end xeta_1;

architecture Behavioral of xeta_1 is
signal MU1,MU2,M11,M22,sum21:std_logic_vector(w-1 downto 0);
signal V0,V1,W1,W2,W3,WX,Wadd,Wf1,V011,V022: std_logic_vector(w-1 downto 0);
signal sum,sum1a,sumadd,sumr,Wf2,zero:std_logic_vector(w-1 downto 0);
signal sum11,sum22:std_logic_vector(1 downto 0);
signal C_1: std_logic_vector(31 downto 0);
signal a1,a2 ,s1,s2: std_logic_vector(1 downto 0);
signal jm11 : std_logic;



begin

a1<= sum11 when cycle_num ='0' else sum22;
a2 <= a1 when write_Ki ='0' else i;

U1 : ENTITY WORK.ram_xeta(behavioral)
port map(
clk=>clock,
we=>write_Ki,
addr=>a2,
Din=>K_i,
dout=>sumr);
M11<=M1;
M22<=M2;
process (clock)
begin
if rising_edge(clock) then 
if enV0 = '1' then
V0<=MU1;
end if;
end if;
end process;
process (clock)
begin
if rising_edge(clock) then
if enV1 = '1' then
V1<=MU2;
end if;
end if;
end process;
W1 <= V1 when cycle_num = '0' else V0;
W2<=  std_logic_vector(shift_left(unsigned(W1),4));
W3<=  std_logic_vector(shift_right(unsigned(W1),5));
WX<= W2 XOR W3;
zero<="0000000000000000";
sum<= zero when write_M = '1' else sum;

process(clock)
begin
if rising_edge(clock) then
if en_sum = '1' then
sum1a <= sum;
end if;
end if;
end process;
sum21<=std_logic_vector(unsigned(sum1a)+unsigned(sumr));

sum11<=sum1a( 1 downto 0);
sum22<=sum1a(w-1 downto w-2);
Wf1<= std_logic_vector(unsigned(W1) + unsigned(WX));
Wf2 <= V0 when cycle_num = '0' else V1;
V011<= sum21 XOR Wf1;
V022<= std_logic_vector(unsigned(V011) + unsigned(Wf2));
MU1<=M1 when write_M = '0' else V011;
MU2<= M2 when write_M = '0' else V011;
C_1 <= V0 & V022;
process(clock,reset1)
begin
if reset1 ='1' then 
C <= "00000000000000000000000000000000";
elsif rising_edge(clock) then 
if en_c = '1' then 
C <= C_1;
end if;
end if;
end process;
U2 : ENTITY WORK.xeta_count (Behavioral)
PORT MAP (
clk=>clock,
load=>ldj,
en=>enj,
D => "000",
jm1 => zj);



end Behavioral;
