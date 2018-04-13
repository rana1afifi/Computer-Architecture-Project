Library ieee;
Use ieee.std_logic_1164.all;

Entity fiveStage is
port( 	clk,reset : in std_logic;
	instruction: in std_logic_vector(10 downto 0);
	stalePipe,jmpSignal : out std_logic;
	memValueToPass : out std_logic_vector(1 downto 0);
	controlSig : out std_logic_vector(18 downto 0));
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
	stalePipe : out std_logic);
end component;
-- memRead,regLoaded from IDEXBuff/rSrc,rDst,instOp from IFIDBuff

component jmpUnit is
port( 	clk,jmp,stalePipe : in std_logic;
	jmpType : in std_logic_vector(1 downto 0);
	ccr : in std_logic_vector(2 downto 0);
	jmpSignal : out std_logic);
end component;

signal totalin,totalout : std_logic_vector(24 downto 0); 
signal instout: std_logic_vector(10 downto 0); 
signal JMPTYPE: std_logic_vector(1 downto 0); 
signal stale,JMP: std_logic;
begin

IFIDBuff : stageBuffer generic map (n => 11) port map(clk,reset,instruction,instout);
control : controlUnit port map(clk,instout(10 downto 6),JMP,memValueToPass,JMPTYPE,totalin(24 downto 6));
HDU : hazardDetectionUnit port map (clk,totalout(12),totalout(5 downto 3),instout(5 downto 3),instout(2 downto 0),instout(10 downto 6),stale);
JMPU : jmpUnit port map (clk,JMP,stale,JMPTYPE,"101",jmpSignal);
IDEXBuff : stageBuffer generic map (n => 25) port map(clk,reset,totalin,totalout);
totalin(5 downto 0)<=instout(5 downto 0);

controlSig<= totalout(24 downto 6);
stalePipe<=stale;
end fiveStageImp;
