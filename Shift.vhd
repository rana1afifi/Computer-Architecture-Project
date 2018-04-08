Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift is
  port(S:in std_logic_vector(1 downto 0);
       A,B:in std_logic_vector(15 downto 0);
       cin: in std_logic_vector(3 downto 0);
       cout: out std_logic_vector(3 downto 0);
       F:out std_logic_vector(15 downto 0));
end entity shift;

Architecture implementionshift of shift is
signal output:std_logic_vector(15 downto 0);
signal neg,z,c:std_logic;
  begin

    with S select
     output<= A(14 downto 0)&cin(2) when"00",
              cin(2) & A(15 downto 1) when"01",
              std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B)))) when"10",
              std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B)))) when others;

    neg<='1' when signed(output)<0
	else '0';
    z<='1' when unsigned(output)="00"
	else '0';
    with S select
	   c<= A(15) when"00",
	       A(0)  when "01",
	       cin(2) when others;
    cout<='0'&c&neg&z;
    F<=output; 
end Architecture;