Library ieee;
Use ieee.std_logic_1164.all;

Entity jmpUnit is
port( 	clk,jmp,stallPipe : in std_logic;
	jmpType : in std_logic_vector(1 downto 0);
	ccr : in std_logic_vector(2 downto 0);
	jmpSignal : out std_logic);
end jmpUnit;
Architecture jmpUnitImp of jmpUnit is
begin
	Process (clk)
	begin
	if(falling_edge(clk)) then
		if jmp='1' and stallPipe='0' and ((ccr(0)='1' and jmpType="10") or (ccr(1)='1' and jmpType="01") 
							or (ccr(2)='1' and jmpType="00") or jmpType="11") then
			jmpSignal<='1';
		else 
			jmpSignal<='0';
		end if;
	end if;
	end process;
end jmpUnitImp;
