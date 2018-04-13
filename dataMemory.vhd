Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataMemory is
  port(memWrite,clk,pop:in std_logic;
       writeValue,aluResult,inPort:in std_logic_vector(15 downto 0);
       sp: in std_logic_vector(9 downto 0);
       wbValToPass: in std_logic_vector(1 downto 0);
       wbValue: out std_logic_vector(15 downto 0));
end entity dataMemory;
Architecture implementionMem of dataMemory is
 component ram is
  Generic ( n : integer := 16 ; m : integer := 16);
  port( clk,w_en : in std_logic;
	datain : in std_logic_vector(n-1 downto 0);
	address : in std_logic_vector(m-1 downto 0);
	dataout : out std_logic_vector(n-1 downto 0));
 end component;
 signal memRead:std_logic_vector(15 downto 0);
 signal address:std_logic_vector(9 downto 0);

 begin
	dataMem: ram generic map(n=>16,m=>10) port map(clk,memWrite,writeValue,address,memRead);
	address<=std_logic_vector(unsigned(sp)+1) when pop='1'
  	else sp;
	wbValue<= memRead when wbValToPass="00"
	else inPort when wbValToPass="10"
	else aluResult;

end implementionMem;
