Library ieee;
Use ieee.std_logic_1164.all;

Entity stageBuffer is
Generic ( n : integer := 8);
port( 	clk,reset,en : in std_logic;
  resetValue: in std_logic_vector(n-1 downto 0);
	dataIn : in std_logic_vector(n-1 downto 0);
	dataOut : out std_logic_vector(n-1 downto 0));
end stageBuffer;
Architecture stageBufferImp of stageBuffer is
begin
	Process (clk,reset)
	begin
	if(falling_edge(clk)and en='0') then
		dataOut<=dataIn;
	end if;
	if(reset='1') then
		dataOut<=resetValue;
	end if;
	end process;
end stageBufferImp;