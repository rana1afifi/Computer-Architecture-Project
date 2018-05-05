Library ieee;
use ieee.std_logic_1164.all;

entity ALU is
  port(aluOp:in std_logic_vector(3 downto 0);
       rSrc,rDst,immValue,fromAlu,fromMem,spValue:in std_logic_vector(15 downto 0);
       immSignal,clk:in std_logic;
       fwdSignal:in std_logic_vector(3 downto 0);
       cin: in std_logic_vector(3 downto 0);
       cout: out std_logic_vector(3 downto 0);
       aluResult:out std_logic_vector(15 downto 0); 
       rDstOut:out std_logic_vector(15 downto 0));
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
       s: in std_logic_vector(1 downto 0);
       cout: out std_logic_vector(3 downto 0);
       F:out std_logic_vector(15 downto 0));
end component;

signal Op1,Op2,x,y,z:std_logic_vector(15 downto 0);
signal cy,cz,cx:std_logic_vector(3 downto 0);
  begin
    OpA: adder port map (Op1,Op2,aluOp(1 downto 0),cz,z);
    OpB: LU port map (aluOp(1 downto 0),Op1,Op2,cin,cx,x);
    OpC: shift port map (aluOp(1 downto 0),Op1,Op2,cin,cy,y);

    with fwdSignal(1 downto 0) select
	Op1<=fromAlu when "00",
	     fromMem when "01",
	     spValue when "10",
	     rSrc when others;

	Op2<=fromAlu when fwdSignal(3 downto 2)="10"
	     else fromMem when fwdSignal(3 downto 2)="11"
	     else immValue when immSignal='1'
	     else rDst ;
	process(clk,cin,z,x,y,fwdSignal)
	begin
		if(clk='1') then
			case aluOp(3 downto 2)  is 
            			when "00" => aluResult<=z; cout<=cz; 
				when "01" => aluResult<=x; cout<=cx; 
				when "10" => aluResult<=y; cout<=cy; 
				when others => aluResult <=Op1; cout<=cin; 
			end case; 
      rDstout<=Op2;             
		end if; 
            end process; 
end Architecture;