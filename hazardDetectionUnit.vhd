Library ieee;
Use ieee.std_logic_1164.all;

Entity hazardDetectionUnit is
port( 	clk,memRead : in std_logic;
	regLoaded,rSrc,rDst : in std_logic_vector(2 downto 0);
	instOpCode : in std_logic_vector(4 downto 0);
	stalePipe : out std_logic);
end hazardDetectionUnit;
-- memRead,regLoaded from IDEXBuff/rSrc,rDst,instOp from IFIDBuff

Architecture hazardDetectionUnitImp of hazardDetectionUnit is
begin
	Process (clk)
	begin
	if(rising_edge(clk)) then
		if memRead = '1' then
			if (((instOpCode(4)='0' and instOpCode(3 downto 1)/="101" and instOpCode(3 downto 2)/="11")			
				or (instOpCode(4)='1' and 
					(instOpCode(3 downto 1)="001" or 
					(instOpCode(3 downto 2)="10" and instOpCode(1 downto 0)/="11") or
					(instOpCode(3 downto 2)="01" and instOpCode(0)='1'))))
				and (rSrc=regLoaded or rDst=regLoaded))
			
			or ((instOpCode="11101" or instOpCode(4 downto 1)="0101") and rSrc=regLoaded)
			or (instOpCode="10000" and rDst=regLoaded) then

				stalePipe<='1';
			else
				stalePipe<='0';
			end if;
		else 
			stalePipe<='0';
		end if;
	end if;
	end process;
end hazardDetectionUnitImp;