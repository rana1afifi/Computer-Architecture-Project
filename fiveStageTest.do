vsim -gui work.fivestage
add wave sim:/fivestage/*
force -freeze sim:/fivestage/clk 0 0, 1 {50 ns} -r 100
force -freeze sim:/fivestage/opCode 5'h00 0
run
force -freeze sim:/fivestage/opCode 5'h10 0
run
force -freeze sim:/fivestage/opCode 5'h15 0
run
force -freeze sim:/fivestage/opCode 5'h00 0
run
force -freeze sim:/fivestage/opCode 5'h1f 0
run
run