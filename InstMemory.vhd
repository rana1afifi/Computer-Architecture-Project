Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity instMem is
port(address : in std_logic_vector(9 downto 0);
     dataout : out std_logic_vector(31 downto 0));
end instMem;
Architecture instMemImplementation of instMem is
type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
signal ram : ram_type;
begin
	dataout <=ram(to_integer(unsigned(address))) &ram(to_integer(unsigned(address)+1));
end instMemImplementation;