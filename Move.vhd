Library ieee;
Use ieee.std_logic_1164.all;

Entity Move_Ins is
Generic ( n : integer := 8);
port( clk,RST,W_en,R_en : in std_logic;
R_sel,W_sel: in std_logic_vector(1 downto 0);
d : in std_logic_vector(n-1 downto 0));
end Move_Ins;

Architecture Move_Ins_Imp of Move_Ins is
	component my_nDFF is
	Generic ( n : integer := 16);
	port( 	Clk,Rst,en : in std_logic;
		d : in std_logic_vector(n-1 downto 0);
		q : out std_logic_vector(n-1 downto 0));
	end component;

component tri_state is
Generic ( n : integer := 16);
	port(	input : in std_logic_vector(n-1 downto 0);
		en : in std_logic;
		output : out std_logic_vector(n-1 downto 0));
end component;

signal q0,q1,q2,q3,f: std_logic_vector(7 downto 0);
signal e: std_logic_vector(3 downto 0);
signal tri: std_logic_vector(4 downto 0);
  begin
reg0: my_nDFF generic map (n => 8) port map(clk,RST,e(0),f,q0);
reg1: my_nDFF generic map (n => 8) port map(clk,RST,e(1),f,q1);
reg2: my_nDFF generic map (n => 8) port map(clk,RST,e(2),f,q2);
reg3: my_nDFF generic map (n => 8) port map(clk,RST,e(3),f,q3);
tri0: tri_state generic map (n => 8) port map (q0,tri(0),f);
tri1: tri_state generic map (n => 8) port map (q1,tri(1),f);
tri2: tri_state generic map (n => 8) port map (q2,tri(2),f);
tri3: tri_state generic map (n => 8) port map (q3,tri(3),f);
tri4: tri_state generic map (n => 8) port map (d,tri(4),f);
Process (W_en,R_en,W_sel,R_sel,d)
begin
		if W_en='1' then
			if W_sel="00" then
			e<="0001";
			elsif W_sel="01" then
			e<="0010";
			elsif W_sel="10" then
			e<="0100";
			elsif W_sel="11" then
			e<="1000";
			end if;
		else 
			e<="0000";
		end if;

		if R_en='1' then
			if R_sel="00" then
			tri<="00001";
			elsif R_sel="01" then
			tri<="00010";
			elsif R_sel="10" then
			tri<="00100";
			elsif R_sel="11" then
			tri<="01000";
			end if;
		else 
			tri<="10000";
		end if;
end process;
end Move_Ins_Imp;
