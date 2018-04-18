vsim -gui work.fivestage
mem load -i E:/college/CMP/Arch/Assembler/Assembler/binary.mem -format binary -filltype value -filldata 16#0000 -fillradix symbolic -skip 0 /fivestage/instrucMem/ram
add wave -position end  sim:/fivestage/clk
add wave -position end  sim:/fivestage/reset
add wave -position end  sim:/fivestage/pc
add wave -position end  sim:/fivestage/rSrcVal
add wave -position end  sim:/fivestage/rDstVal
add wave -position end  sim:/fivestage/aluResult
add wave -position 4  sim:/fivestage/IFIDBuff/dataOut
add wave -position 5  sim:/fivestage/IDEXBuff/dataOut
force -freeze sim:/fivestage/clk 1 0, 0 {50 ps} -r 100
add wave -position 3  sim:/fivestage/instIn
add wave -position 7  sim:/fivestage/MEMWBBuff/dataOut
add wave -position 7  sim:/fivestage/EXMEMBuff/dataOut
add wave -position 10  sim:/fivestage/wbval
add wave -position 11  sim:/fivestage/wbRdst
force -freeze sim:/fivestage/pc 0000000000 0
force -freeze sim:/fivestage/reset 1 0
force -freeze sim:/fivestage/reg/sp/en 1 0
force -freeze sim:/fivestage/reg/sp/d 10#1023 0
run
force -freeze sim:/fivestage/reg/sp/en 0 0
force -freeze sim:/fivestage/reset 0 0
force -freeze sim:/fivestage/pc 0000000001 0
run
force -freeze sim:/fivestage/pc 0000000010 0
run
force -freeze sim:/fivestage/pc 0000000011 0
run
force -freeze sim:/fivestage/pc 0000000100 0
run
force -freeze sim:/fivestage/pc 0000000101 0
run
force -freeze sim:/fivestage/pc 0000000110 0
run
force -freeze sim:/fivestage/pc 0000000111 0
run
force -freeze sim:/fivestage/pc 0000001001 0
run
force -freeze sim:/fivestage/pc 0000001011 0
run
force -freeze sim:/fivestage/pc 0000001100 0
run
force -freeze sim:/fivestage/pc 0000001101 0
run
force -freeze sim:/fivestage/pc 0000001110 0
run
force -freeze sim:/fivestage/pc 0000001111 0
run
force -freeze sim:/fivestage/pc 0000010000 0
run
force -freeze sim:/fivestage/pc 0000010010 0
run