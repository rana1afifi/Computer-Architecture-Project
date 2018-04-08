Library ieee;
Use ieee.std_logic_1164.all;
Entity my_adder is
          port( a,b,cin : in std_logic;
                s,cout : out std_logic); 
end my_adder;
Architecture a_my_adder of my_adder is
begin
	s <= a xor b xor cin;
	cout <= (a and b) or (cin and (a xor b));
end a_my_adder;
