vsim -gui work.controlunit
add wave sim:/controlunit/*
force -freeze sim:/controlunit/clk 0 0, 1 {100 ns} -r 200
#force -freeze sim:/controlunit/clk 1 0, 0 {100 ns} -r 200
force -freeze sim:/controlunit/opCode 5'b00000 0
run
run
force -freeze sim:/controlunit/opCode 5'b00101 0
run
run
force -freeze sim:/controlunit/opCode 5'b01010 0
run
run
force -freeze sim:/controlunit/opCode 5'b01101 0
run
run
force -freeze sim:/controlunit/opCode 5'b11001 0
run
run
force -freeze sim:/controlunit/opCode 5'b01110 0
run
run
force -freeze sim:/controlunit/opCode 5'b10000 0
run
run
force -freeze sim:/controlunit/opCode 5'b10001 0
run
run
force -freeze sim:/controlunit/opCode 5'b10011 0
run
run
force -freeze sim:/controlunit/opCode 5'b10111 0
run
run
force -freeze sim:/controlunit/opCode 5'b11010 0
run
run
force -freeze sim:/controlunit/opCode 5'b11011 0
run
run
force -freeze sim:/controlunit/opCode 5'b11110 0
run
run
force -freeze sim:/controlunit/opCode 5'b11000 0
run
run
force -freeze sim:/controlunit/opCode 5'b11111 0
run
run
force -freeze sim:/controlunit/opCode 5'b11100 0
run
run
run