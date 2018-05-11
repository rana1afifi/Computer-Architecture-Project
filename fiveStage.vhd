Library ieee;
Use ieee.std_logic_1164.all;

Entity fiveStage is
port( 	clk,reset,interrupt : in std_logic;
	inPort: in std_logic_vector(15 downto 0);
	outPort:out std_logic_vector(15 downto 0));
end fiveStage;

Architecture fiveStageImp of fiveStage is

component stageBuffer is
Generic ( n : integer := 8);
port( 	clk,reset,en : in std_logic;
  resetValue : in std_logic_vector(n-1 downto 0);
	dataIn : in std_logic_vector(n-1 downto 0);
	dataOut : out std_logic_vector(n-1 downto 0));
end component;
component forwardingUnit is
port(  clk,stall : in std_logic; 
	     rsrcIdEx , rdestIdEx : in std_logic_vector(2 downto 0); 
	     -- for ALU to ALU FWD
	     wbDestExMem: in std_logic_vector(1 downto 0); -- equal to 01 if reg  
	     rdestExMem:in std_logic_vector (2 downto 0);
	     memReadExMem:in std_logic; 
	     -- MEM to ALU FWD
	     wbDestMemWb: in std_logic_vector(1 downto 0); -- equal to 01 if reg  
	     rdestMemWb:in std_logic_vector (2 downto 0);
	     -- SP Forwarding 
	     spSignalExMem:in std_logic;
	     spSignalMemWb:in std_logic;
	     spSignalIdEx:in std_logic; 
	     -- JMP Forwarding 
	     jmpDest: in std_logic_vector( 2 downto 0); 
	     wbDestIdEx: in std_logic_vector( 1 downto 0);
	     memReadIdEx:in std_logic;
	    -- Ouput
	     aluFwdSignalForRdest:out std_logic; -- is there FWD?
	     aluFwdSignalTypeForRsrc:out std_logic_vector(1 downto 0); -- 00 for ALU-ALU , 01 for Mem-ALU , 10 for SP Value 
	     aluFwdSignalTypeForRdest:out std_logic; -- 0 for ALU-ALU , 1 for Mem-ALU
	     jmpFWD: out std_logic_vector(1 downto 0) -- 11 for wbValue , 10 for aluResult  
	    );
end component;

-- 1bit signals: ccrMode,pop,memRead,memWrite,spSignal,retSignal,rtiSignal,intSignal,immSignal
-- ID/EX Buffer : aluOpCode(4) & ccrControlSig(2) & wbValueToPass(2) & wbDest(2) & 1bit signals

component controlUnit is
port(clk : in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	jmp : out std_logic;
	memValueToPass,jmpType : out std_logic_vector(1 downto 0);
	controlSignals : out std_logic_vector(18 downto 0);
	ccrWb: out std_logic);
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
       aluResult:out std_logic_vector(15 downto 0); 
       rDstOut:out std_logic_vector(15 downto 0));
end component;

component RegisterFile is
port( clk,RST,spSignal,immSignal:in std_logic;
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
     dataout : out std_logic_vector(31 downto 0);
     resetPc:out std_logic_vector(9 downto 0); 
     interruptPc:out std_logic_vector(9 downto 0));
end component;
component dataMemory is
   port(memWrite,clk,pop,spSignal:in std_logic;
       writeValue,immValue,aluResult,inPort:in std_logic_vector(15 downto 0);
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

component pcControlUnit is
port(  clk : in std_logic; 
       wbValue: in std_logic_vector(9 downto 0); -- can either hold PC value from memory or Rdest in case of FWD
       rdest:in std_logic_vector(9 downto 0); -- rDest of jmp signal  
       -- for forwarding 
       aluResult : in  std_logic_vector(9 downto 0);
       fwdSignalType: in std_logic_vector (1 downto 0); -- 11 for wbValue , 10 for aluResult
    --pc for reset and interrupt
     	resetPc:in std_logic_vector(9 downto 0); 
     	interruptPc:in std_logic_vector(9 downto 0);
    ----
       jmpSignal , intSignal , resetSignal , stallSignal:in std_logic;
       retMemWB ,rtiMemWb :in std_logic ;          
       
       instOpCode:in std_logic_vector (4 downto 0); 
       --output in rising edge
       pcValue:out std_logic_vector(9 downto 0) 
	     
	   );
end component;

signal idEx,toAlu , idExReset: std_logic_vector(73 downto 0); 
signal exMem,toMem , exMemReset: std_logic_vector(61 downto 0);
signal memWb,toWb ,memWbReset:std_logic_vector(40 downto 0);
signal dataOut :std_logic_vector(31 downto 0);
signal cntrl : std_logic_vector(18 downto 0); 
signal instIn,instout ,ifIdReset: std_logic_vector(41 downto 0); 
signal rSrcVal,rDstVal,immValue,aluResult,wbval,FromAlu,aluOutput2:std_logic_vector(15 downto 0);
signal pc,resetPc,interruptPc :  std_logic_vector(9 downto 0);
signal wbRdst,jmpDest:std_logic_vector(2 downto 0);
signal ccrIn,ccrVal,fwdSignal:std_logic_vector(3 downto 0);
signal opCode:std_logic_vector(4 downto 0);
signal jmpType,memValueToPass: std_logic_vector(1 downto 0); 
signal jmp,ccrWb,stall,jmpSig,aluFwdSignalForRdest,aluFwdSignalTypeForRdest: std_logic;
signal aluFwdSignalTypeForRsrc,jmpFWD: std_logic_vector(1 downto 0);  
signal counter:integer;

begin
  ---initialize resetSignals 
  ifIdReset<="111110000000000000000000000000000000000000";
  idExReset<="00011110011110000000000000000000000000000000000000000000000000000000000000";
  exMemReset<="00000000000000001111000000000000000000000000000000000000000000"; 
  memWbReset<="00000000000000001111100000000000000000000";  
  --- Stage 1: Fetch
	instrucMem: instMem port map(pc,dataOut,resetPc,interruptPc);
	instIn<="10001000001101011111100000000000"&pc when interrupt='1'
	   else "11111000000000001111100000000000"&pc when counter>0
	   else  dataOut&pc;
	
	IFIDBuff : stageBuffer generic map (n => 42) port map(clk,reset,stall,ifIdReset,instIn,instout);
	  
	---Stage 2: Decode , Stage 5:WB
	opCode<=instout(41 downto 37) when stall='0' and jmpSig='0' 
	   else "11111";--flushing
	control : controlUnit port map(clk,opCode,jmp,memValueToPass,jmpType,cntrl,ccrWb);
	reg: RegisterFile port map(clk,reset,toWb(3),cntrl(0),memValueToPass,toWb(24 downto 23),toWb(22 downto 20),
			   	   instout(28 downto 26),instout(31 downto 29),toWb(40 downto 25),
			   	   instout(9 downto 0),toWb(19 downto 4),instout(25 downto 10),
			  	   rSrcVal,rDstVal,immValue,wbRdst);

	idEx<=instout(31 downto 29)&cntrl&rSrcVal&rDstVal&immValue&"111"&ccrWb when stall='1'
	  else instout(31 downto 29)&cntrl&rSrcVal&rDstVal&immValue&wbRdst&ccrWb;
	-- rsrc,aluOpCode(4),ccrControlSig(2),wbValueToPass(2),wbDest(2),ccrMode,pop,
	--memRead,memWrite,spSignal,retSignal,rtiSignal,
	--intSignal,immSignal,rSrcVal&rDstVal&immValue&wbRdst,ccrwb
	IDEXBuff : stageBuffer generic map (n => 74) port map(clk,reset,'0',idExReset,idEx,toAlu);
	  
 -----Stage 3:Execute
	ccr:ccrUnit port map(clk,toAlu(60),toWb(0),ccrIn,toWb(40 downto 37),toAlu(66 downto 65),ccrVal);
	FromAlu<=toMem(35 downto 20) when toMem(45 downto 44)="11" --imm value
	        else inPort when toMem(45 downto 44)="10"              --inPort
	        else toMem(16 downto 1);                           --aluResult
	fwdSignal<=aluFwdSignalForRdest&aluFwdSignalTypeForRdest&aluFwdSignalTypeForRsrc;
	aluEx : ALU port map(toAlu(70 downto 67),toAlu(51 downto 36),toAlu(35 downto 20),
			     toAlu(19 downto 4),FromAlu,toWb(40 downto 25),toWb(19 downto 4),
			     toAlu(52),clk,fwdSignal,ccrVal,ccrIn,aluResult,aluOutput2);

	exMem<=aluOutput2&toAlu(64 downto 61)&toAlu(59 downto 54)&toAlu(19 downto 1)&aluResult&toAlu(0) when toAlu(53)='0'
		else ccrVal&toAlu(31 downto 20)&toAlu(64 downto 61)&toAlu(59 downto 54)&toAlu(19 downto 1)&aluResult&toAlu(0);
	--writeval(Rdst),wbValueToPass(2),wbDest(2),pop,memRead,memWrite,spSignal,retSignal,rtiSignal,
	--immValue&wbRdst,aluResult,ccrwb
	EXMEMBuff:stageBuffer generic map (n => 62) port map(clk,reset,'0',exMemReset,exMem,toMem);
	  
  ------Stage 4:Memory 
	mem:dataMemory port map(toMem(39),clk,toMem(41),toMem(38),toMem(61 downto 46),toMem(35 downto 20),
				toMem(16 downto 1),inPort,toMem(45 downto 44),wbval);
	--wbval,wbDest(2),wbRdst,spValue,spSignal,retSignal,rtiSignal,ccrWb
	memWb<=wbval&toMem(43 downto 42)&toMem(19 downto 1)&toMem(38 downto 36)&toMem(0);
	MEMWBBuff:stageBuffer generic map (n => 41) port map(clk,reset,'0', memWbReset, memWb,toWb);
	  
	  
	  ---------------------------------Units----------------------------------------------------
	--clk,memRead,Regloaded(id/ex),rsrc(if/id),rdst(if/id),instop,out
	HDU:hazardDetectionUnit port map(clk,toAlu(58),toAlu(3 downto 1),instout(31 downto 29),
					 instout(28 downto 26),instout(41 downto 37),stall);
	
	FU:forwardingUnit port map(clk,stall,toAlu(73 downto 71),toAlu(3 downto 1)
				  ,toMem(43 downto 42),toMem(19 downto 17),toMem(40)
				  ,toWb(24 downto 23),toWb(22 downto 20)
				  ,toMem(38),toWb(3),toAlu(56)
				  ,instout(28 downto 26),toALU(62 downto 61),toALU(58)
	    			  ,aluFwdSignalForRdest,aluFwdSignalTypeForRsrc,aluFwdSignalTypeForRdest,jmpFWD);
	    			  
	jmpU:jmpUnit port map(clk,jmp,stall,jmpType,ccrIn(2 downto 0),jmpSig);
	  
  pcUnit: pcControlUnit port map (clk , 
          toWb(34 downto 25) , toAlu(13 downto 4) ,fromAlu(9 downto 0)  ,
          jmpFWD ,resetPc,interruptPc, jmpSig , cntrl(1) , reset , stall , 
          toWb(2) , toWb(1) , 
          instout(41 downto 37),
          pc);
          
  -- toMem(10 downto 1) 
	process(clk,cntrl)
	begin
		if toWb(24 downto 23)="10" and clk='1' then
			outPort<=toWb(40 downto 25);
		end if;
		if cntrl(2)='1' or cntrl(3)='1' then
			counter<=3;
		
		elsif clk='1' and counter>0 then
			counter<=counter-1;
		end if;
	end process;
end fiveStageImp;