Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LU is
  port(S:in std_logic_vector(1 downto 0);
       A,B:in std_logic_vector(15 downto 0);
       cin: in std_logic_vector(3 downto 0);
       cout: out std_logic_vector(3 downto 0);
       F:out std_logic_vector(15 downto 0)
);
end entity LU;

Architecture implemention of LU is
signal output:std_logic_vector(15 downto 0);
signal neg,z:std_logic;
  begin
    with S select
     output<=A and B when"00",
        A or B when"01",
        not A when"10",
        std_logic_vector(unsigned(not A)+1) when others;

     neg<='1' when signed(output)<0
	else '0';
     z<='1' when unsigned(output)=0
	else '0';
     cout<=cin(3 downto 2)&neg&z;
     F<=output;
end Architecture;
