Library ieee;
Use ieee.std_logic_1164.all;

Entity my_nDFF is
Generic ( n : integer := 16);
port( Clk,Rst,en : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end my_nDFF;

Architecture a_my_nDFF of my_nDFF is
signal output:std_logic_vector(n-1 downto 0);
begin
q<=output;
Process (Clk,Rst,output,en)
begin
if Rst = '1' then
output<= (others=>'0');
elsif Clk='1' and en='1' then
output <= d;
end if;
end process;
end a_my_nDFF;

