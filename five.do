vsim -gui work.fivestage
mem load -i E:/college/CMP/Arch/Assembler/Assembler/binary.mem -format binary -filltype value -filldata 16#0000 -fillradix symbolic -skip 0 /fivestage/instrucMem/ram
add wave -position end  sim:/fivestage/clk
add wave -position end  sim:/fivestage/reset
add wave -position end  sim:/fivestage/pc
force -freeze sim:/fivestage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fivestage/pc 0000000000 0
add wave -position end  sim:/fivestage/FU/*
add wave -position 10  sim:/fivestage/reg/loop1(1)/fx/q
add wave -position 11  sim:/fivestage/reg/loop1(1)/fx/en
add wave -position 3  sim:/fivestage/aluEx/aluResult
force -freeze sim:/fivestage/inPort 10#1 0
force -freeze sim:/fivestage/reset 1 0
force -freeze sim:/fivestage/reg/sp/en 1 0
force -freeze sim:/fivestage/reg/sp/d 10#1023 0
run
noforce sim:/fivestage/reg/sp/en
noforce sim:/fivestage/reg/sp/d 
force -freeze sim:/fivestage/reset 0 0
run
force -freeze sim:/fivestage/pc 0000000001 0
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
force -freeze sim:/fivestage/pc 0000001000 0
run
force -freeze sim:/fivestage/pc 0000001001 0
run
force -freeze sim:/fivestage/pc 0000001010 0
run
force -freeze sim:/fivestage/pc 0000001011 0
run
force -freeze sim:/fivestage/pc 0000001100 0
run
force -freeze sim:/fivestage/pc 0000001110 0
run