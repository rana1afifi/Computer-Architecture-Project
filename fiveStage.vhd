Library ieee;
Use ieee.std_logic_1164.all;

Entity fiveStage is
port( 	clk : in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	aluOpCodeOutput : out std_logic_vector(3 downto 0);
	memValueToPass : out std_logic_vector(1 downto 0);
	twoBitSignalsOutput : out std_logic_vector(5 downto 0);
	oneBitSignalsOutput : out std_logic_vector(8 downto 0));
end fiveStage;
-- 1bit signals: ccrMode,pop,memRead,memWrite,spSignal,retSignal,rtiSignal,intSignal,immSignal
-- 2bit signals: ccrControlSig,wbValueToPass,wbDest
-- 4bit signals: aluOpCode
Architecture fiveStageImp of fiveStage is

component stageBuffer is
Generic ( n : integer := 8);
port( 	clk : in std_logic;
	dataIn : in std_logic_vector(n-1 downto 0);
	dataOut : out std_logic_vector(n-1 downto 0));
end component;

component controlUnit is
port( 	clk : in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	aluOpCode : out std_logic_vector(3 downto 0);
	ccrControlSig,wbValueToPass,wbDest,memValueToPass : out std_logic_vector(1 downto 0);
	ccrMode,pop,memRead,memWrite,spSignal,retSignal,rtiSignal,intSignal,immSignal : out std_logic);
end component;

signal aluOpCode : std_logic_vector(3 downto 0);
signal twoBitSig : std_logic_vector(5 downto 0);
signal oneBitSig : std_logic_vector(8 downto 0);
signal totalout,totalin: std_logic_vector(18 downto 0); 
begin
control : controlUnit port map(clk,opCode,aluOpCode,twoBitSig(5 downto 4),twoBitSig(3 downto 2),twoBitSig(1 downto 0),
				memValueToPass,oneBitSig(8),oneBitSig(7),oneBitSig(6),oneBitSig(5),oneBitSig(4),
				oneBitSig(3),oneBitSig(2),oneBitSig(1),oneBitSig(0));
totalin<=aluOpCode&twoBitSig&oneBitSig;
IDEXBuff : stageBuffer generic map (n => 19) port map(clk,totalin,totalout);
oneBitSignalsOutput<= totalout(8 downto 0);
twoBitSignalsOutput<= totalout(14 downto 9);
aluOpCodeOutput<= totalout(18 downto 15);
end fiveStageImp;