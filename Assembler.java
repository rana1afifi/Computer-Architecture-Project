
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
    
    public static HashMap<String, String> Map = new HashMap<>();
    public static HashMap<String, String> MapR = new HashMap<>();
    public static BufferedWriter datawriter = null;
    public static Scanner datascan = null;
    public static BufferedWriter writer = null;
    public static Scanner scan = null;

public static void setup()
{
        try {
            String k[]={"INC","DEC","SUB","ADD","AND","OR","NOT","NEG","RLC","RRC","SHL","SHR","RTI","RET","POP","NU0","PUSH","NU1"
                    ,"CALL","JMP","LDD","OUT","IN","STD","JC","JN","JZ","SETC","CLRC","MOV","LDM","NOP"};
            
            for(int i=0;i<32;i++)
            {
                Map.put(k[i],String.format("%05d",Integer.parseInt(Integer.toBinaryString(i))));
            }
            
            String kR[]={"R0","R1","R2","R3","R4","R5","R6","R7"};
            String vR[]={"000","001","010","011","100","101","110","111"};
            for(int i=0;i<8;i++)
            {
                MapR.put(kR[i],vR[i]);
            }
            
            datascan = new Scanner (new File ("C:\\Users\\a\\Desktop\\data.txt"));
            File dataMem = new File("dataMem.mem");
            datawriter = new BufferedWriter(new FileWriter(dataMem));
            
            scan = new Scanner (new File ("C:\\Users\\a\\Desktop\\code.txt"));
            File instMem = new File("instMem.mem");            
            writer = new BufferedWriter(new FileWriter(instMem));
            
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Assembler.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(Assembler.class.getName()).log(Level.SEVERE, null, ex);
        }
}

public static void writeInstructions(BufferedWriter writer,Scanner scan,int next,int ic)
{
    String instruction,instOpCode;
    String tokens[],parameters[];
    while(scan.hasNextLine())
    {
        try {
            instruction=scan.nextLine();
            if(instruction.equals("."+next))
            { 
                while(ic<next)
                {
                    writer.write("0000000000000000");
                    writer.newLine();
                    ic++;
                }
            }
            else
            {
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
                    ic++;
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
                else if(tokens[0].equals("LDD")||tokens[0].equals("STD")||tokens[0].equals("LDM"))
                {
                    parameters=tokens[1].split(",");
                    instOpCode+=MapR.get(parameters[0])+MapR.get(parameters[0]);
                    writer.write(instOpCode);
                    writer.newLine();
                    ic++;
                    instOpCode=String.format("%016d",Integer.parseInt(Integer.toBinaryString(Integer.decode(parameters[1]))));
                }
                else//NOP,CLCR,SETC
                {
                    instOpCode+="000000";
                }
                writer.write(instOpCode);
                writer.newLine();
                ic++;
            }
        } catch (IOException ex) {
            Logger.getLogger(Assembler.class.getName()).log(Level.SEVERE, null, ex);
        }
            }
 
    
}

public static void writeData()
{
        try { 
            int dataLocation = Integer.decode(datascan.nextLine().substring(1));
            for(int i=0; i < dataLocation ;i++)
            {
                datawriter.write("0000000000000000");
                datawriter.newLine();
            }
            while(datascan.hasNextLine())
            {
                datawriter.write(String.format("%016d",Integer.parseInt(Integer.toBinaryString(Integer.decode(datascan.nextLine())))));
                datawriter.newLine();
            }
            datawriter.close();
            datascan.close();
        } catch (IOException ex) {
            Logger.getLogger(Assembler.class.getName()).log(Level.SEVERE, null, ex);
        }
}
public static void main(String[] args) throws IOException {

            
            setup();
            writeData();
            
            int startAddress=Integer.decode(scan.nextLine());           
            writer.write(String.format("%016d",Integer.parseInt(Integer.toBinaryString(startAddress))));
            writer.newLine();
            
            int ISR=Integer.decode(scan.nextLine());
            writer.write(String.format("%016d",Integer.parseInt(Integer.toBinaryString(ISR))));
            writer.newLine();
            
            if (ISR>startAddress)
            {
                for(int i=0;i<startAddress-2;i++)
                {
                    writer.write("0000000000000000");
                    writer.newLine();
                }
                writeInstructions(writer,scan,ISR,startAddress);
   
            }
            else
            {
               for(int i=0;i<ISR-2;i++)
                {
                    writer.write("0000000000000000");
                    writer.newLine();
                }
                writeInstructions(writer,scan,startAddress,ISR);
            }
            
            writer.close();
            scan.close();
        
    }
}
         