vsim -gui work.forwardingunit 
add wave -position insertpoint sim:/forwardingunit/*
# SP Fwd for rsrc + fwd for rdest
# 
force -freeze sim:/forwardingunit/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/forwardingunit/rdestIdEx 101 0
force -freeze sim:/forwardingunit/wbDestExMem 01 0
force -freeze sim:/forwardingunit/rdestExMem 101 0
force -freeze sim:/forwardingunit/spSignalExMem 1 0
force -freeze sim:/forwardingunit/spSignalIdEx 1 0
run
# MEM sp forward for rsrc + ALU fwd for dest 
# 
force -freeze sim:/forwardingunit/wbDestExMem 11 0
force -freeze sim:/forwardingunit/wbDestMemWb 01 0
force -freeze sim:/forwardingunit/rdestMemWb 101 0
force -freeze sim:/forwardingunit/spSignalExMem 0 0
force -freeze sim:/forwardingunit/spSignalMemWb 1 0 
# MEM FWD
force -freeze sim:/forwardingunit/spSignalMemWb 0 0
force -freeze sim:/forwardingunit/rsrcIdEx 110 0
force -freeze sim:/forwardingunit/wbDestExMem 01 0
force -freeze sim:/forwardingunit/rdestExMem 001 0
force -freeze sim:/forwardingunit/rsrcIdEx 110 0
force -freeze sim:/forwardingunit/rdestIdEx 110 0
force -freeze sim:/forwardingunit/rdestMemWb 110 0
run
# JMP FWD 
force -freeze sim:/forwardingunit/jmpDest 110 0
force -freeze sim:/forwardingunit/rdestIfId 110 0
force -freeze sim:/forwardingunit/wbDestIfId 01 0
run