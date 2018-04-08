Library ieee;
use ieee.std_logic_1164.all;

entity ALU is
  port(S:in std_logic_vector(3 downto 0);
       A,B:in std_logic_vector(15 downto 0);
       cin: in std_logic_vector(3 downto 0);
       cout: out std_logic_vector(3 downto 0);
       F:out std_logic_vector(15 downto 0));
end entity ALU;

Architecture implementionALU of ALU is
component LU is
  port(S:in std_logic_vector(1 downto 0);
       A,B:in std_logic_vector(15 downto 0);
       cin: in std_logic_vector(3 downto 0);
       cout: out std_logic_vector(3 downto 0);
       F:out std_logic_vector(15 downto 0));
end component;


component shift is
  port(S:in std_logic_vector(1 downto 0);
       A,B:in std_logic_vector(15 downto 0);
       cin: in std_logic_vector(3 downto 0);
       cout: out std_logic_vector(3 downto 0);
       F:out std_logic_vector(15 downto 0));
end component;

component adder is
  port(A,B:in std_logic_vector(15 downto 0);
       cin: in std_logic_vector(3 downto 0);
       s: in std_logic_vector(1 downto 0);
       cout: out std_logic_vector(3 downto 0);
       F:out std_logic_vector(15 downto 0));
end component;

signal x,y,z:std_logic_vector(15 downto 0);
signal cy,cz,cx:std_logic_vector(3 downto 0);
  begin
OpA: adder port map (A,B,cin,S(1 downto 0),cz,z);
OpB: LU port map (S(1 downto 0),A,B,cin,cx,x);
OpC: shift port map (S(1 downto 0),A,B,cin,cy,y);

    with S(3 downto 2) select
     F<= z when"00",
	 x when"01",
	 y when "10",
         A  when others;

    with S(3 downto 2) select
     cout<= cz when"00",
	    cx when"01",
            cy when"10",
	    cin when others;
      
end Architecture;