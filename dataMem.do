vsim -gui work.datamemory
mem load -skip 0 -filltype rand -filldata 00 -fillradix symbolic /datamemory/dataMem/ram
add wave -position end  sim:/datamemory/clk
add wave -position end  sim:/datamemory/memWrite
add wave -position 2  sim:/datamemory/wbValToPass
add wave -position end  sim:/datamemory/pop
add wave -position end  sim:/datamemory/writeValue
add wave -position 1  sim:/datamemory/sp
add wave -position end  sim:/datamemory/aluResult
add wave -position end  sim:/datamemory/inPort
add wave -position end  sim:/datamemory/wbValue
force -freeze sim:/datamemory/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/datamemory/memWrite 0 0
force -freeze sim:/datamemory/sp 16#0000 0
force -freeze sim:/datamemory/pop 0 0
force -freeze sim:/datamemory/wbValToPass 10 0
force -freeze sim:/datamemory/inPort 16#1212 0
force -freeze sim:/datamemory/aluResult 16#0001 0
force -freeze sim:/datamemory/writeValue 16#0500 0
run
force -freeze sim:/datamemory/wbValToPass 00 0
force -freeze sim:/datamemory/memWrite 1 1
run
run
force -freeze sim:/datamemory/wbValToPass 00 0
run
run
force -freeze sim:/datamemory/pop 1 0
run
run
run
force -freeze sim:/datamemory/pop 0 0
force -freeze sim:/datamemory/wbValToPass 00 0
run
run