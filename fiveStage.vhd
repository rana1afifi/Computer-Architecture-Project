Library ieee;
Use ieee.std_logic_1164.all;

Entity fiveStage is
port( 	clk : in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	memValueToPass : out std_logic_vector(1 downto 0);
	controlSig : out std_logic_vector(18 downto 0));
end fiveStage;
-- 1bit signals: ccrMode,pop,memRead,memWrite,spSignal,retSignal,rtiSignal,intSignal,immSignal
-- ID/EX Buffer : aluOpCode(4) & ccrControlSig(2) & wbValueToPass(2) & wbDest(2) & 1bit signals
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
	memValueToPass : out std_logic_vector(1 downto 0);
	controlSignals : out std_logic_vector(18 downto 0));
end component;


signal totalout,totalin: std_logic_vector(18 downto 0); 
signal instout: std_logic_vector(4 downto 0); 
begin
IFIDBuff : stageBuffer generic map (n => 5) port map(clk,opCode,instout);
control : controlUnit port map(clk,instout,memValueToPass,totalin);
IDEXBuff : stageBuffer generic map (n => 19) port map(clk,totalin,totalout);

controlSig<= totalout;
end fiveStageImp;