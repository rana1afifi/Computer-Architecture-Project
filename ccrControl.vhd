
Library ieee;
Use ieee.std_logic_1164.all;

Entity ccrUnit is
port( clk : in std_logic; 
	    ccrMode: in std_logic;  --0 ALU , 1 JMP Ctrl
	    wb: in std_logic; -- 1 WB  , 0 none 
	    aluInput: in std_logic_vector ( 3 downto 0); --ALU input
	    wbInput : in std_logic_vector ( 3 downto 0); -- WB input ( ret ) 
	    ccrCtrl : in std_logic_vector (1 downto 0); -- JMP input 
	    ---- output 
	    ccrOutput: out std_logic_vector(3 downto 0) 
	    ) ; 
end ccrUnit;

Architecture ccrUnitImpl of ccrUnit is 

  begin
      process(clk) 
        -- OVERFLOW  CARRY  NEGATIVE  ZERO 
      variable ccrRegister : std_logic_vector( 3 downto 0) ;  
      begin 
	if(clk='1') then 
               if (wb='1') then -- Write back from RTI
                ccrRegister:=wbInput;
                end if; 

        elsif(clk='0') then             
               if(ccrMode='1') then -- Jump Control --00	C = 0  01	N=0	 10	Z=0   11	C = 1
                case ccrCtrl is 

                   when "00" => ccrRegister:=ccrRegister(3) &'0'&ccrRegister(1 downto 0);
                   when "01" => ccrRegister:=ccrRegister(3 downto 2) &'0'& ccrRegister(0);
                   when "10" => ccrRegister:=ccrRegister(3 downto 1) &'0';
                   when "11" => ccrRegister:=ccrRegister(3) &'1'&ccrRegister(1 downto 0);
                   when others => null ; -- doesn't compile without it 
                   
                end case; 
             elsif (ccrMode='0') then 
              ccrRegister:=aluInput ;
              
           end if ; 
          
        end if;
	ccrOutput<=ccrRegister;
   	 end process; 

end ccrUnitImpl;
 