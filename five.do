vsim -gui work.fivestage
mem load -i E:/college/CMP/Arch/Assembler/Assembler/binary.mem -format binary -filltype value -filldata 16#0000 -fillradix symbolic -skip 0 /fivestage/instrucMem/ram
mem load -filltype value -filldata 0 -fillradix symbolic -skip 0 /fivestage/mem/dataMem/ram
mem load -filltype value -filldata {10#2 } -fillradix symbolic /fivestage/mem/dataMem/ram(1)
mem load -filltype value -filldata 10#3 -fillradix symbolic /fivestage/mem/dataMem/ram(2)
mem load -filltype value -filldata 10#4 -fillradix symbolic /fivestage/mem/dataMem/ram(3)
mem load -filltype value -filldata 10#5 -fillradix symbolic /fivestage/mem/dataMem/ram(4)
mem load -filltype value -filldata 1 -fillradix symbolic /fivestage/mem/dataMem/ram(0)
add wave -position end  sim:/fivestage/clk
add wave -position end  sim:/fivestage/reset
add wave -position end  sim:/fivestage/pc
add wave -position end  sim:/fivestage/reg/sp/q
add wave -position end  sim:/fivestage/counter
add wave -position end  sim:/fivestage/aluResult
add wave -position 2  sim:/fivestage/interrupt
add wave -position 5  sim:/fivestage/outPort
force -freeze sim:/fivestage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fivestage/interrupt 0 0
force -freeze sim:/fivestage/inPort 10#1 0
force -freeze sim:/fivestage/reset 1 0
run
force -freeze sim:/fivestage/reset 0 0
run
run
run
run
force -freeze sim:/fivestage/interrupt 1 0
run
force -freeze sim:/fivestage/interrupt 0 0
run
run
run
run
run
run
run


mem load -i E:/college/CMP/Arch/Assembler/Assembler/binary.mem -format binary -filltype value -filldata 16#0000 -fillradix symbolic -skip 0 /fivestage/instrucMem/ram
mem load -filltype value -filldata 0 -fillradix symbolic -skip 0 /fivestage/mem/dataMem/ram
mem load -filltype value -filldata {10#2 } -fillradix symbolic /fivestage/mem/dataMem/ram(1)
mem load -filltype value -filldata 10#3 -fillradix symbolic /fivestage/mem/dataMem/ram(2)
mem load -filltype value -filldata 10#4 -fillradix symbolic /fivestage/mem/dataMem/ram(3)
mem load -filltype value -filldata 10#5 -fillradix symbolic /fivestage/mem/dataMem/ram(4)
mem load -filltype value -filldata 10#20 -fillradix symbolic /fivestage/mem/dataMem/ram(0)
force -freeze sim:/fivestage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fivestage/interrupt 0 0
force -freeze sim:/fivestage/inPort 10#1 0
force -freeze sim:/fivestage/reset 1 0
run
force -freeze sim:/fivestage/reset 0 0
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
