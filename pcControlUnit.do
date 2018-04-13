vsim -gui work.pccontrolunit
# vsim -gui work.pccontrolunit 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.pccontrolunit(pccontrolunitimpl)
add wave -position insertpoint sim:/pccontrolunit/*
force -freeze sim:/pccontrolunit/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pccontrolunit/resetSignal 1 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 50 ps  Iteration: 0  Instance: /pccontrolunit
force -freeze sim:/pccontrolunit/resetSignal 0 0
run
run
run
force -freeze sim:/pccontrolunit/jmpSignal 1 0
force -freeze sim:/pccontrolunit/rdest 0001010001110000 0
force -freeze sim:/pccontrolunit/fwdSignalType 01 0
run
force -freeze sim:/pccontrolunit/jmpSignal 0 0
run
run
force -freeze sim:/pccontrolunit/instOpCode 11110 0
run
run
run
force -freeze sim:/pccontrolunit/instOpCode 00000 0
run
run
force -freeze sim:/pccontrolunit/instOpCode 10111 0
run
run

run
run
force -freeze sim:/pccontrolunit/stallSignal 1 0
run
run
run
run
force -freeze sim:/pccontrolunit/intSignal U 1
force -freeze sim:/pccontrolunit/stallSignal 0 0
run
run
force -freeze sim:/pccontrolunit/intSignal 1 0
run
run
run
run
run