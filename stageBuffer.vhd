Library ieee;
Use ieee.std_logic_1164.all;

Entity stageBuffer is
Generic ( n : integer := 8);
port( 	clk : in std_logic;
	dataIn : in std_logic_vector(n-1 downto 0);
	dataOut : out std_logic_vector(n-1 downto 0));
end stageBuffer;
Architecture stageBufferImp of stageBuffer is
begin
	Process (clk)
	begin
	if(falling_edge(clk)) then
		dataOut<=dataIn;
	end if;
	end process;
end stageBufferImp;