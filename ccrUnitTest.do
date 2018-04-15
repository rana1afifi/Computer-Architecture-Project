vsim -gui work.ccrunit
# vsim -gui work.ccrunit 
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.ccrunit(ccrunitimpl)
add wave -position insertpoint sim:/ccrunit/*
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
# 
#           File in use by: AA  Hostname: AA-PC  ProcessID: 10768
# 
#           Attempting to use alternate WLF file "./wlft9cesna".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
# 
#           Using alternate file: ./wlft9cesna
# 
force -freeze sim:/ccrunit/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/ccrunit/wb 1 0
force -freeze sim:/ccrunit/wbInput 1111 0
force -freeze sim:/ccrunit/aluInput 1010 0
run
force -freeze sim:/ccrunit/ccrMode 1 0
force -freeze sim:/ccrunit/wbInput 0101 0
run
force -freeze sim:/ccrunit/wb 0 0
force -freeze sim:/ccrunit/ccrCtrl 00 0
force -freeze sim:/ccrunit/aluInput 1111 0
force -freeze sim:/ccrunit/ccrMode 0 0
run
force -freeze sim:/ccrunit/ccrMode 1 0
run
force -freeze sim:/ccrunit/ccrCtrl 01 0
run
run
force -freeze sim:/ccrunit/wbInput 1111 0
run
run
force -freeze sim:/ccrunit/wb 1 0
run
force -freeze sim:/ccrunit/wb 0 0
force -freeze sim:/ccrunit/ccrCtrl 10 0
run
force -freeze sim:/ccrunit/ccrCtrl 11 0
run
