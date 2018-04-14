
package assembler;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Assembler {

public static void setup(HashMap<String,String>m,HashMap<String, String>mr)
{
    String k[]={"INC","DEC","SUB","ADD","AND","OR","NOT","NEG","RLC","RRC","SHL","SHR","RTI","RET","POP","NU0","PUSH","NU1"
            ,"CALL","JMP","LDD","STR","OUT","IN","JC","JN","JZ","SETC","CLRC","MOV","LDM","NOP"};
    
            for(int i=0;i<32;i++)
            {
                m.put(k[i],String.format("%05d",Integer.parseInt(Integer.toBinaryString(i))));
            }
           
            String kR[]={"R0","R1","R2","R3","R4","R5","R6","R7"};
            String vR[]={"000","001","010","011","100","101","110","111"};
            for(int i=0;i<8;i++)
            {
                mr.put(kR[i],vR[i]);
            }
}

public static void main(String[] args) throws IOException {
       
        try {
            String instruction,instOpCode;
            String tokens[],parameters[];
            HashMap<String, String> Map = new HashMap<>();
            HashMap<String, String> MapR = new HashMap<>();
            setup(Map,MapR);
            
            File binary = new File("binary.txt");
            BufferedWriter writer = null;
            writer = new BufferedWriter(new FileWriter(binary));
            
            Scanner scan = new Scanner (new File ("C:\\Users\\a\\Desktop\\code.txt"));
            
            while(scan.hasNextLine())
            {
                instruction=scan.nextLine();
                tokens=instruction.split(" ");
                instOpCode=Map.get(tokens[0])+"00000";
                //1 parameter --> duplicate
                if(tokens[0].equals("INC")||tokens[0].equals("DEC")||tokens[0].equals("NOT")||               
                        tokens[0].equals("NEG")||tokens[0].equals("RLC")||tokens[0].equals("RRC")||tokens[0].equals("OUT")||
                        tokens[0].equals("IN")||tokens[0].equals("JMP")||tokens[0].equals("JC")||tokens[0].equals("JN")||
                        tokens[0].equals("JZ"))
                {
                    instOpCode+=MapR.get(tokens[1])+MapR.get(tokens[1]);
                }
                //2 parameters
                else if (tokens[0].equals("ADD")||tokens[0].equals("SUB")||tokens[0].equals("AND")||
                        tokens[0].equals("OR")||tokens[0].equals("MOV"))
                {
                    parameters=tokens[1].split(",");
                    instOpCode+=MapR.get(parameters[0])+MapR.get(parameters[1]);
                    
                }
                //3 parameters including immediate value
                else if(tokens[0].equals("SHL")||tokens[0].equals("SHR"))
                {
                    parameters=tokens[1].split(",");
                    instOpCode+=MapR.get(parameters[0])+MapR.get(parameters[2]);
                    writer.write(instOpCode);
                    writer.newLine();
                    instOpCode=String.format("%016d",Integer.parseInt(Integer.toBinaryString(Integer.decode(parameters[1]))));
                } 
                //stack operations
                else if (tokens[0].equals("POP")||tokens[0].equals("PUSH")||tokens[0].equals("CALL"))
                {
                    instOpCode+=MapR.get("R6")+MapR.get(tokens[1]);          
                }
                //RTI,RET operations
                else if (tokens[0].equals("RTI")||tokens[0].equals("RET"))
                {
                    instOpCode+=MapR.get("R6")+"000";          
                }
                //LDD,STR,LDM operations
                else if(tokens[0].equals("LDD")||tokens[0].equals("STR")||tokens[0].equals("LDM"))
                {
                    parameters=tokens[1].split(",");
                    instOpCode+=MapR.get(parameters[0])+MapR.get(parameters[0]);
                    writer.write(instOpCode);
                    writer.newLine();
                    instOpCode=String.format("%016d",Integer.parseInt(Integer.toBinaryString(Integer.decode(parameters[1]))));         
                }
                else//NOP,CLCR,SETC
                {
                    instOpCode+="000000";
                }
                writer.write(instOpCode);
                writer.newLine();
            }
            writer.close();
            scan.close();
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Assembler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
         