Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity RegisterFile is
  port( clk,RST,spSignal,immSignal:in std_logic;
	memValToPass,wbDest:in std_logic_vector(1 downto 0);
	WbAddress,rDst,rSrc:in std_logic_vector(2 downto 0);
	WbValue:in std_logic_vector(15 downto 0);
        pcValue:in std_logic_vector(9 downto 0);
	spValue:in std_logic_vector(15 downto 0);
	immValueEa:in std_logic_vector(15 downto 0);
        rSrcVal,rDstVal,immValue:out std_logic_vector(15 downto 0);
	wbRdst:out std_logic_vector(2 downto 0));
end entity RegisterFile;

Architecture RegisterFileImp of RegisterFile is
type regOut is array(0 to 6) of std_logic_vector(15 downto 0);
component my_nDFF is
	Generic ( n : integer := 16);
	port( 	Clk,Rst,en : in std_logic;
		d : in std_logic_vector(n-1 downto 0);
		q : out std_logic_vector(n-1 downto 0));
end component;
component stackPionter is
Generic ( n : integer := 16);
port( Clk,Rst,en : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end component;
signal readValue: regOut;
signal spWrite,rDstValue: std_logic_vector(15 downto 0);
signal spEn:std_logic;
signal e: std_logic_vector(6 downto 0);
  begin
	loop1: for i in 0 to 5 generate
		fx: my_nDFF generic map (n => 16) port map(clk,RST,e(i),WbValue,readValue(i));
	end generate;
	sp: stackPionter generic map (n => 16) port map(clk,RST,spEn,spWrite,readValue(6));
	immValue<=immValueEa when immSignal='1'
	     else rDstValue;
	spEn<=(e(6) or spSignal);
	spWrite<=spValue when spSignal='1'
	else WbValue;
	wbRdst<=rDst;
	rDstVal<="000000"&pcValue when memValToPass="01"
	else "000000"&std_logic_vector(unsigned(pcValue)+1) when memValToPass="10"
	else rDstValue;
	with rDst select
		       rDstValue<=readValue(0) when "000",
				  readValue(1) when "001",
			 	  readValue(2) when "010",
			 	  readValue(3) when "011",
				  readValue(4) when "100",
			 	  readValue(5) when "101",
			 	  readValue(6) when "110",
			  	  "000000"&pcValue when others;
		

	with rSrc select
		        rSrcVal<= readValue(0) when "000",
				  readValue(1) when "001",
			 	  readValue(2) when "010",
			 	  readValue(3) when "011",
				  readValue(4) when "100",
			 	  readValue(5) when "101",
			 	  readValue(6) when "110",
			  	  "000000"&pcValue when others;
		
	process(clk)
	begin
		if wbDest="01" and clk='1' then
			if WbAddress="000" then
			e<="0000001";
			elsif WbAddress="001" then
			e<="0000010";
			elsif WbAddress="010" then
			e<="0000100";
			elsif WbAddress="011" then
			e<="0001000";
			elsif WbAddress="100" then
			e<="0010000";
			elsif WbAddress="101" then
			e<="0100000";
			elsif WbAddress="110" then
			e<="1000000";
			else
			e<="0000000";
			end if;
		else 
			e<="0000000";
		end if;		
	
	end process;
end Architecture;