library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity stackPionter is
Generic ( n : integer := 16);
port( Clk,Rst,en : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end stackPionter;

Architecture stackPionterImp  of stackPionter  is
signal output:std_logic_vector(n-1 downto 0);
begin
q<=output;
Process (Clk,Rst,output,en)
begin
if Rst = '1' then
output<= std_logic_vector(to_unsigned(1023,n));
elsif Clk='1' and en='1' then
output <= d;
end if;
end process;
end stackPionterImp;

