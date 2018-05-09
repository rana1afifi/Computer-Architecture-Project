Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  port(A,B:in std_logic_vector(15 downto 0);
       s: in std_logic_vector(1 downto 0);
       cout: out std_logic_vector(3 downto 0);
       F:out std_logic_vector(15 downto 0));
end entity adder;

Architecture implemention_adder of adder is

component my_nadder IS
Generic (n : integer := 8);
PORT    (a, b : in std_logic_vector(n-1 downto 0) ;
	cin : in std_logic;
	s : out std_logic_vector(n-1 downto 0);
	cout : out std_logic_vector(1 downto 0));
END component;

signal y,output:std_logic_vector(15 downto 0);
signal c:std_logic_vector(1 downto 0);
signal neg,z:std_logic;
  begin
     Adder16 : my_nadder generic map (n => 16) port map(A, y, '0', output, c);

     y<= "0000000000000001" when s="00"
	else  x"ffff" when s="01"
        else not B when s="10"
	else B;
     neg<='1' when signed(output)+1<0 and s="10"
	else '1' when signed(output)<0
	else '0';
     z<='1' when signed(output)+1=0 and  s="10"
	else '1' when signed(output)=0
	else '0';
	
     cout<= c(1)&not c(0)&neg&z when s="10" or s="01" else c&neg&z;
     F<=std_logic_vector(unsigned(output)+1) when s="10" else output;
end Architecture;