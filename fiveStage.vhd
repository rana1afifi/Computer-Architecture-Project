Library ieee;
Use ieee.std_logic_1164.all;

Entity fiveStage is
port( 	clk,reset : in std_logic;
	pc : in std_logic_vector(9 downto 0);
	inPort: in std_logic_vector(15 downto 0));
end fiveStage;

Architecture fiveStageImp of fiveStage is

component stageBuffer is
Generic ( n : integer := 8);
port( 	clk,reset : in std_logic;
	dataIn : in std_logic_vector(n-1 downto 0);
	dataOut : out std_logic_vector(n-1 downto 0));
end component;

-- 1bit signals: ccrMode,pop,memRead,memWrite,spSignal,retSignal,rtiSignal,intSignal,immSignal
-- ID/EX Buffer : aluOpCode(4) & ccrControlSig(2) & wbValueToPass(2) & wbDest(2) & 1bit signals

component controlUnit is
port( 	clk : in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	jmp : out std_logic;
	memValueToPass,jmpType : out std_logic_vector(1 downto 0);
	controlSignals : out std_logic_vector(18 downto 0));
end component;

component hazardDetectionUnit is
port( 	clk,memRead : in std_logic;
	regLoaded,rSrc,rDst : in std_logic_vector(2 downto 0);
	instOpCode : in std_logic_vector(4 downto 0);
	stallPipe : out std_logic);
end component;
-- memRead,regLoaded from IDEXBuff/rSrc,rDst,instOp from IFIDBuff

component jmpUnit is
port( 	clk,jmp,stallPipe : in std_logic;
	jmpType : in std_logic_vector(1 downto 0);
	ccr : in std_logic_vector(2 downto 0);
	jmpSignal : out std_logic);
end component;
component ALU is
  port(aluOp:in std_logic_vector(3 downto 0);
       rSrc,rDst,immValue,fromAlu,fromMem,spValue:in std_logic_vector(15 downto 0);
       immSignal,clk:in std_logic;
       fwdSignal:in std_logic_vector(3 downto 0);
       cin: in std_logic_vector(3 downto 0);
       cout: out std_logic_vector(3 downto 0);
       aluResult:out std_logic_vector(15 downto 0));
end component;

component RegisterFile is
port( clk,RST,spSignal:in std_logic;
	memValToPass,wbDest:in std_logic_vector(1 downto 0);
	WbAddress,rDst,rSrc:in std_logic_vector(2 downto 0);
	WbValue:in std_logic_vector(15 downto 0);
        pcValue:in std_logic_vector(9 downto 0);
	spValue:in std_logic_vector(15 downto 0);
	immValueEa:in std_logic_vector(15 downto 0);
        rSrcVal,rDstVal,immValue:out std_logic_vector(15 downto 0);
	wbRdst:out std_logic_vector(2 downto 0));
end component;
component instMem is
port(address : in std_logic_vector(9 downto 0);
     dataout : out std_logic_vector(31 downto 0));
end component;
component dataMemory is
  port(memWrite,clk,pop,spSignal:in std_logic;
       writeValue,aluResult,inPort:in std_logic_vector(15 downto 0);
       wbValToPass: in std_logic_vector(1 downto 0);
       wbValue: out std_logic_vector(15 downto 0));
end component;
component ccrUnit is
port( clk : in std_logic; 
	    ccrMode: in std_logic;  --0 ALU , 1 JMP Ctrl
	    wb: in std_logic; -- 1 WB  , 0 none 
	    aluInput: in std_logic_vector ( 3 downto 0); --ALU input
	    wbInput : in std_logic_vector ( 3 downto 0); -- WB input ( ret ) 
	    ccrCtrl : in std_logic_vector (1 downto 0); -- JMP input 
	    ---- output 
	    ccrOutput: out std_logic_vector(3 downto 0) 
	    ) ; 
end component;
signal idEx,toAlu : std_logic_vector(70 downto 0); 
signal exMem,toMem: std_logic_vector(45 downto 0);
signal memWb,toWb:std_logic_vector(40 downto 0);
signal dataOut :std_logic_vector(31 downto 0);
signal cntrl : std_logic_vector(18 downto 0); 
signal instIn,instout: std_logic_vector(41 downto 0); 
signal rSrcVal,rDstVal,immValue,aluResult,wbval:std_logic_vector(15 downto 0);
signal wbRdst:std_logic_vector(2 downto 0);
signal ccrIn,ccrVal:std_logic_vector(3 downto 0);
signal JMPTYPE,memValueToPass: std_logic_vector(1 downto 0); 
signal JMP: std_logic;
begin
	instrucMem: instMem port map(pc,dataOut);
	instIn<=dataOut&pc;
	IFIDBuff : stageBuffer generic map (n => 42) port map(clk,reset,instIn,instout);
	control : controlUnit port map(clk,instout(41 downto 37),JMP,memValueToPass,JMPTYPE,cntrl);
	reg: RegisterFile port map(clk,reset,toWb(3),memValueToPass,toWb(24 downto 23),toWb(22 downto 20),
			   	   instout(28 downto 26),instout(31 downto 29),toWb(40 downto 25),
			   	   instout(9 downto 0),toWb(19 downto 4),instout(25 downto 10),
			  	   rSrcVal,rDstVal,immValue,wbRdst);

	idEx<=cntrl&rSrcVal&rDstVal&immValue&wbRdst&'0';
	-- aluOpCode(4),ccrControlSig(2),wbValueToPass(2),wbDest(2),ccrMode,pop,
	--memRead,memWrite,spSignal,retSignal,rtiSignal,
	--intSignal,immSignal,rSrcVal&rDstVal&immValue&wbRdst,ccrwb
	IDEXBuff : stageBuffer generic map (n => 71) port map(clk,reset,idEx,toAlu);
	ccr:ccrUnit port map(clk,toAlu(60),toWb(0),ccrIn,toWb(7 downto 4),toAlu(66 downto 65),ccrVal);
	aluEx : ALU port map(toAlu(70 downto 67),toAlu(51 downto 36),toAlu(35 downto 20),
			     toAlu(19 downto 4),toMem(16 downto 1),toWb(40 downto 25),toWb(19 downto 4),
			     toAlu(52),clk,"0000",ccrVal,ccrIn,aluResult);
	exMem<=toAlu(64 downto 61)&toAlu(59 downto 54)&toAlu(19 downto 1)&aluResult&toAlu(0) when toAlu(53)='0'
		else toAlu(64 downto 61)&toAlu(59 downto 54)&toAlu(19 downto 1)&aluResult(11 downto 0)&ccrVal&toAlu(0);
	--wbValueToPass(2),wbDest(2),pop,memRead,memWrite,spSignal,retSignal,rtiSignal,
	--immValue&wbRdst,aluResult,ccrwb
	EXMEMBuff:stageBuffer generic map (n => 46) port map(clk,reset,exMem,toMem);

	mem:dataMemory port map(toMem(39),clk,toMem(41),toMem(38),toMem(35 downto 20),
				toMem(16 downto 1),inPort,toMem(45 downto 44),wbval);
	--wbval,wbDest(2),wbRdst,aluResult(Spval),spSignal,retSignal,rtiSignal,ccrWb
	memWb<=wbval&toMem(43 downto 42)&toMem(19 downto 1)&toMem(39 downto 37)&toMem(0);
	MEMWBBuff:stageBuffer generic map (n => 41) port map(clk,reset,memWb,toWb);

end fiveStageImp;