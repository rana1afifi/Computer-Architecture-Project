Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity ram is
Generic ( n : integer := 16 ; m : integer := 16);
port( clk,w_en : in std_logic;
datain : in std_logic_vector(n-1 downto 0);
address : in std_logic_vector(m-1 downto 0);
dataout : out std_logic_vector(n-1 downto 0));
end ram;

Architecture ram_imp of ram is
type ram_type is array (0 to 2**m-1) of std_logic_vector(n-1 downto 0);
signal ram : ram_type;
begin
	process(clk) is
	begin
		if rising_edge(clk) then
			if w_en = '1' then
				ram(to_integer(unsigned(address))) <= datain;
			end if;
		end if;
	end process;
	dataout <= ram(to_integer(unsigned(address)));
end ram_imp;