Library ieee;
Use ieee.std_logic_1164.all;

Entity forwardingUnit is
port(  clk : in std_logic; 
	     rsrcIdEx , rdestIdEx : in std_logic_vector(2 downto 0); 
	     -- for ALU to ALU FWD
	     wbDestExMem: in std_logic_vector(1 downto 0); -- equal to 01 if reg  
	     rdestExMem:in std_logic_vector (2 downto 0);
	     -- MEM to ALU FWD
	     wbDestMemWb: in std_logic_vector(1 downto 0); -- equal to 01 if reg  
	     rdestMemWb:in std_logic_vector (2 downto 0);
	     -- SP Forwarding 
	     spSignalExMem:in std_logic;
	     spSignalMemWb:in std_logic;
	     spSignalIdEx:in std_logic; 
	     -- JMP Forwarding 
	     jmpDest: in std_logic_vector( 2 downto 0); 
	     wbDestIfId: in std_logic_vector( 1 downto 0); 
	     rdestIfId: in std_logic_vector (2 downto 0);
	    -- Ouput
	     aluFwdSignalForRdest:out std_logic; -- is there ALU FWD?
	     aluFwdSignalTypeForRsrc:out std_logic_vector(1 downto 0); -- 00 for ALU-ALU , 01 for Mem-ALU , 10 for SP Value 
	     aluFwdSignalTypeForRdest:out std_logic; -- 0 for ALU-ALU , 1 for Mem-ALU
	     jmpFWD: out std_logic_vector(1 downto 0) -- 11 for wbValue , 10 for aluResult  
	    );
end forwardingUnit;



Architecture forwardingUnitImpl of forwardingUnit is 
signal input : std_logic_vector(26 downto 0); 
begin
input <= rsrcIdEx & rdestIdEx & wbDestExMem & rdestExMem& wbDestMemWb&rdestMemWb& spSignalExMem &spSignalMemWb&spSignalIdEx&jmpDest& wbDestIfId &rdestIfId; 
  process(clk , input) begin 
    if(clk='1') then  
-- First assume there's no Forwarding  
     aluFwdSignalForRdest<='0'; 
     aluFwdSignalTypeForRsrc<="11";
     aluFwdSignalTypeForRdest<='0';
     jmpFwd<="00";
-- Case 1: ALU to ALU FWD   
     if (wbDestExMem="01") then
         if(rsrcIdEx=rdestExMem) then 
            aluFwdSignalTypeForRsrc<="00" ; 
          end if; 
      
         if(rdestIdEx=rdestExMem) then 
            aluFwdSignalTypeForRdest<='0' ; 
            aluFwdSignalForRdest<='1'; 
        end if; 
     end if; 
 
-- Case 2: MEM to ALU FWD 
      if (wbDestMemWb="01") then
          if(rsrcIdEx=rdestMemWb) then 
            aluFwdSignalTypeForRsrc<="01" ; 
          end if; 
      
          if(rdestIdEx=rdestMemWb) then 
            aluFwdSignalTypeForRdest<='1' ; 
            aluFwdSignalForRdest<='1'; 
          end if; 
      end if;  
  
-- Case 3: SP Forwarding: ALU to ALU -->FWD to Rsrc ALU Result , MEM to ALU --> FWD To Rsrc SP Value 
        if (spSignalIdEx='1')  then 
          if(spSignalExMem='1') then 
            aluFwdSignalTypeForRsrc<="00" ; -- ALU Result (if I have both signals , priority to ExMem )  
          elsif (spSignalMemWB='1') then 
            aluFwdSignalTypeForRsrc<="10" ; -- SPvalue 
          end if ;
        end if;
    
-- Case 4: JMP Forwarding 
         if(wbDestExMem="01") then
              if ( jmpDest=rdestExMem) then
                  jmpFwd<="11"; 
              end if; 
         end if;
         
         if(wbDestIfId="01") then
              if ( jmpDest=rdestIfId) then
                  jmpFwd<="10"; 
              end if; 
         end if;    
         
       end if;
      end process; 

end forwardingUnitImpl;
 