Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity pcControlUnit is
port(  clk : in std_logic; 
       wbValue: in std_logic_vector(9 downto 0); -- can either hold PC value from memory or Rdest in case of FWD
       rdest:in std_logic_vector(9 downto 0); -- rDest of jmp signal  
       -- for forwarding 
       aluResult : in  std_logic_vector(9 downto 0);
       fwdSignalType: in std_logic_vector (1 downto 0); -- 11 for wbValue , 10 for aluResult
    
       jmpSignal , intSignal , resetSignal , stallSignal:in std_logic;
       retMemWB ,rtiMemWb :in std_logic ;          
       
       instOpCode:in std_logic_vector (4 downto 0); 
       --output in rising edge
       pcValue:out std_logic_vector(9 downto 0) 
	     
	   );
end pcControlUnit;



Architecture pcControlUnitImpl of pcControlUnit is 
signal input:std_logic_vector(42 downto 0); 
signal pc: std_logic_vector(9 downto 0);
begin
  input<=wbValue&rdest&aluResult&fwdSignalType&jmpSignal&intSignal&resetSignal&stallSignal&retMemWb&rtiMemWb&instOpCode; 
  process(clk,input) 
  variable pcReg : std_logic_vector(9 downto 0);
  variable pcVar: std_logic_vector(9 downto 0);
  begin 
      
      if(clk='1') then
      
          if (jmpSignal='1')  then 
              if (fwdSignalType="11") then 
                pcVar:=std_logic_vector(to_unsigned(to_integer(unsigned(wbValue))-1,10));
                
              elsif (fwdSignalType="10") then 
                 pcVar:=std_logic_vector(to_unsigned(to_integer(unsigned(aluResult))-1,10)); 
                 
              elsif( fwdSignalType(1)='0') then 
                   pcVar:=std_logic_vector(to_unsigned(to_integer(unsigned(rdest))-1,10));               
              end if;
              
          elsif (retMemWb='1' or rtiMemWb='1') then
                pcVar:=std_logic_vector(to_unsigned(to_integer(unsigned(wbValue))-1,10));
          elsif (resetSignal='1') then
                  pcVar:= "0000000000";
          elsif (intSignal='1') then 
                  pcVar:= "0000000001"; 
          else          
             pcVar:=pcReg; 
          
          end if;
      --         pcValue<=std_logic_vector(pcVar); 
               pcReg:=pcVar; -- did so for semantic purposes  
                       
-----------------------------------------------------------------------------            
        
   end if;    
    if(rising_edge(clk)) then
    if(stallSignal='1') then
          
          pcReg:=pcReg ; 
        else  
      -- SHL 0	1	0	1	0 SHR 0	1	0	1	1 LDD 1	0	1	0	0 STR 1	0	1	1	1 LDM 1	1	1	1	0
          if( instOpCode="01010" or instOpCode = "01011" or instOpCode = "10100"  or instOpCode = "10111" or instOpCode = "11110") then  
             pcReg:=std_logic_vector(to_unsigned(to_integer(unsigned(pcReg))+2,10));
          else   
            pcReg:=std_logic_vector(to_unsigned(to_integer(unsigned(pcReg))+1,10));
          end if;
          
        end if; 
   
      end if;
    pcValue<=std_logic_vector(pcReg); 
  
  end process; 

end pcControlUnitImpl;
 


