Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity pcControlUnit is
port(  clk : in std_logic; 
       wbValue: in std_logic_vector(15 downto 0); -- can either hold PC value from memory or Rdest in case of FWD
       rdest:in std_logic_vector(15 downto 0); -- rDest of jmp signal  
       -- for forwarding 
       aluResult : in  std_logic_vector(15 downto 0);
       fwdSignalType: in std_logic_vector (1 downto 0); -- 11 for wbValue , 10 for aluResult
    
       jmpSignal , intSignal , resetSignal , stallSignal:in std_logic;
       retMemWB ,rtiMemWb :in std_logic ;          
       
       instOpCode:in std_logic_vector (4 downto 0); 
       --output in rising edge
       pcValue:out std_logic_vector(15 downto 0) 
	     
	   );
end pcControlUnit;



Architecture pcControlUnitImpl of pcControlUnit is 

begin
  process(clk) 
  variable pcReg : std_logic_vector(15 downto 0);
  variable pcVar: std_logic_vector(15 downto 0);
  begin 
      
      if(rising_edge(clk)) then
      
          if (jmpSignal='1')  then 
              if (fwdSignalType="11") then 
                pcVar:=wbValue; 
                
              elsif (fwdSignalType="10") then 
                 pcVar:=aluResult; 
                 
              elsif( fwdSignalType(1)='0') then 
                 pcVar:=rdest; 
                 
              end if;
              
          elsif (retMemWb='1' or rtiMemWb='1') then
                 pcVar:=wbValue; 
          elsif (resetSignal='1') then
                  pcVar:= "0000000000000000";
          elsif (intSignal='1') then 
                  pcVar:= "0000000000000001"; 
          else          
             pcVar:=pcReg; 
          
          end if;
               pcValue<=std_logic_vector(pcVar); 
               pcReg:=pcVar; -- did so for semantic purposes          
-----------------------------------------------------------------------------      
      elsif(falling_edge(clk)) then
        
        if(stallSignal='1') then
          
          pcReg:=pcReg ; 
        else  
      -- SHL 0	1	0	1	0 SHR 0	1	0	1	1 LDD 1	0	1	0	0 STR 1	0	1	1	1 LDM 1	1	1	1	0
          case instOpCode is 
      
           when "01010" =>  pcReg:=std_logic_vector(to_unsigned(to_integer(unsigned(pcReg))+2,16));
           when "01011" =>  pcReg:=std_logic_vector(to_unsigned(to_integer(unsigned(pcReg))+2,16));
           when "10100" =>  pcReg:=std_logic_vector(to_unsigned(to_integer(unsigned(pcReg))+2,16));
           when "10111" =>  pcReg:=std_logic_vector(to_unsigned(to_integer(unsigned(pcReg))+2,16));
           when "11110" =>  pcReg:=std_logic_vector(to_unsigned(to_integer(unsigned(pcReg))+2,16));
           when others =>   pcReg:=std_logic_vector(to_unsigned(to_integer(unsigned(pcReg))+1,16));
          
          end case;
        end if; 
          
      end if;
  
  

  end process; 

end pcControlUnitImpl;
 
