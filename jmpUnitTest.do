vsim work.jmpunit
add wave sim:/jmpunit/*
force -freeze sim:/jmpunit/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/jmpunit/jmp 0 0
force -freeze sim:/jmpunit/jmpType 2'b11 0
force -freeze sim:/jmpunit/ccr 3'b111 0
run
force -freeze sim:/jmpunit/jmp 1 0
run
force -freeze sim:/jmpunit/jmp 0 0
run
run