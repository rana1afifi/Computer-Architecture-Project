vsim work.fivestage
add wave sim:/fivestage/*
force -freeze sim:/fivestage/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/fivestage/reset 0 0
force -freeze sim:/fivestage/instruction 11'h000 0
run
force -freeze sim:/fivestage/instruction 11'b01110111111 0
run
force -freeze sim:/fivestage/instruction 11'b10011111111 0
run
run
force -freeze sim:/fivestage/instruction 11'h000 0
run
force -freeze sim:/fivestage/instruction 11'h000 0