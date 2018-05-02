Library ieee;
Use ieee.std_logic_1164.all;

Entity controlUnit is
port( 	clk : in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	jmp : out std_logic;
	memValueToPass,jmpType : out std_logic_vector(1 downto 0);
	controlSignals : out std_logic_vector(18 downto 0);
	ccrWb: out std_logic);
end controlUnit;
	
-- 1bit signals: ccrMode,pop,memRead,memWrite,spSignal,retSignal,rtiSignal,intSignal,immSignal
-- ID/EX Buffer : aluOpCode(4) & ccrControlSig(2) & wbValueToPass(2) & wbDest(2) & 1bit signals

Architecture controlUnitImp of controlUnit is
signal ccrM,popSig,memR,memW,spSig,retSig,rtiSig,intSig,immSig : std_logic;
signal aluOp : std_logic_vector(3 downto 0);
signal ccrControl,wbPass,wbDst : std_logic_vector(1 downto 0);
begin
	Process (clk,opCode)
	begin
	if(clk='1') then
		
		if opCode(4)='0' then
			if opCode(3 downto 2)="11" then
				aluOp<= "0000";
				if opCode(1)='0' then
					wbDst(1)<='1';
				else
					wbDst(1)<='0';
				end if;
			else
				aluOp<=opCode(3 downto 0);
				wbDst(1)<='0';
			end if;
		else 
			if opCode(3 downto 2)="00" and  opCode(1 downto 0)/="11" then
				aluOp<= "0001";
			else
				aluOp<="1111";
			end if;
			if opCode(3 downto 0)="1101" or  opCode(3 downto 0)="1110" then
				wbDst(1)<='0';
			elsif opCode(3 downto 2) = "01" then
				wbDst(1)<=opCode(0);
			else
				wbDst(1)<='1';
			end if;
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode (4 downto 2) = "110" then
			ccrControl<=opCode(1 downto 0);
			jmpType<=opCode(1 downto 0);
			if opCode(1 downto 0) /="11" then
				jmp<='1';
			else
				jmp<='0';
			end if;
		else 
			ccrControl<="00";
			if opCode (4 downto 1) = "1001" then
				jmp<='1';
				jmpType<="11";
			else 
				jmp<='0';
			end if;
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode (4 downto 2) = "110" or opCode = "11100" then
			ccrM<='1';
		else
			ccrM<='0';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode (4 downto 2) = "011" then
			popSig<='1';
			wbPass<="00";
		else
			popSig<='0';
			
			if opCode (4 downto 2) = "101" then
				wbPass<=opCode(1 downto 0);
			elsif opCode="11110" then
				wbPass<="11";
			else
				wbPass<="01";
			end if;

		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode = "10101" then
			wbDst(0)<='0';
		else
			wbDst(0)<='1';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode = "01110" or opCode = "10100" then
			memR<='1';
		else
			memR<='0';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if (opCode(4 downto 2) = "100" and opCode(1 downto 0) /= "11") or opCode = "10111" then
			memW<='1';
		else
			memW<='0';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode(4 downto 2) = "100" and opCode(0) /= opCode(1) then		
			memValueToPass<=opCode(1 downto 0);
		else
			memValueToPass<="00";
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if (opCode(4 downto 2) = "100" and opCode(1 downto 0) /= "11") or opCode(4 downto 2) = "011" then
			spSig<='1';
		else
			spSig<='0';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode="01101" then
			retSig<='1';
		else
			retSig<='0';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode="01100" then
			rtiSig<='1';
			ccrWb<='1';
		else
			rtiSig<='0';
			ccrWb<='0';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode="10001" then
			intSig<='1';
		else
			intSig<='0';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
		if opCode(4 downto 1)="0101" or (opCode(4 downto 2)="101" and opCode(0)=opCode(1)) or opCode="11110" then
			immSig<='1';
		else
			immSig<='0';
		end if;
-- /////////////////////////////////////////////////////////////////////////////////////////////////////

	end if;
	end process;
	controlSignals<= aluOp & ccrControl & wbPass & wbDst & ccrM & popSig & memR & memW & spSig & retSig & rtiSig & intSig &immSig;
	
-- 1bit signals: ccrMode,pop,memRead,memWrite,spSignal,retSignal,rtiSignal,intSignal,immSignal
-- ID/EX Buffer : aluOpCode(4) & ccrControlSig(2) & wbValueToPass(2) & wbDest(2) & 1bit signals
end controlUnitImp;