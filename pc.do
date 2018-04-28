vsim -gui work.fivestage
add wave -position insertpoint  \
sim:/fivestage/clk \
sim:/fivestage/reset \
sim:/fivestage/pc \
add wave -position 16  sim:/fivestage/aluEx/fromAlu
add wave -position insertpoint  \
add wave -position 3  sim:/fivestage/pcUnit/instOpCode
add wave -position 4  sim:/fivestage/pcUnit/jmpSignal
add wave -position 5  sim:/fivestage/pcUnit/intSignal
add wave -position 5  sim:/fivestage/pcUnit/rdest
sim:/fivestage/reg/loop1(1)/fx/q
add wave -position insertpoint  \
sim:/fivestage/reg/loop1(2)/fx/q
add wave -position insertpoint  \
sim:/fivestage/reg/loop1(3)/fx/q
add wave -position insertpoint  \
sim:/fivestage/reg/loop1(4)/fx/q
add wave -position insertpoint  \
sim:/fivestage/reg/loop1(5)/fx/q
add wave -position insertpoint  \
sim:/fivestage/reg/sp/q
add wave -position insertpoint  \
sim:/fivestage/FU/wbDestExMem \
sim:/fivestage/FU/rdestExMem \
sim:/fivestage/FU/memReadExMem \
sim:/fivestage/FU/wbDestMemWb \
sim:/fivestage/FU/rdestMemWb \
sim:/fivestage/FU/aluFwdSignalForRdest \
sim:/fivestage/FU/aluFwdSignalTypeForRsrc \
sim:/fivestage/FU/aluFwdSignalTypeForRdest
add wave -position insertpoint  \
sim:/fivestage/FU/spSignalExMem \
sim:/fivestage/FU/spSignalMemWb \
sim:/fivestage/FU/spSignalIdEx
add wave -position insertpoint  \
sim:/fivestage/pcUnit/stallSignal \
sim:/fivestage/pcUnit/retMemWB \
sim:/fivestage/pcUnit/rtiMemWb
force -freeze sim:/fivestage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fivestage/reset 1 0
force -freeze sim:/fivestage/inPort 10#6 0
force -freeze sim:/fivestage/reg/sp/en 1 0 
force -freeze sim:/fivestage/reg/sp/d 10#1023 0
run
force -freeze sim:/fivestage/reset 0 0
noforce sim:/fivestage/reg/sp/en
noforce sim:/fivestage/reg/sp/d
mem load -i {D:/CUFE/8th Semester/Computer Architecture/Project-New/binary.mem} -format binary /fivestage/instrucMem/ram
mem load -filltype value -filldata 10#7 -fillradix symbolic /fivestage/mem/dataMem/ram(0)
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run