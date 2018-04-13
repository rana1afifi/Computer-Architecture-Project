vsim work.hazarddetectionunit
add wave sim:/hazarddetectionunit/*
force -freeze sim:/hazarddetectionunit/clk 0 0, 1 {50 ns} -r 100
force -freeze sim:/hazarddetectionunit/instOpCode 5'h00 0
force -freeze sim:/hazarddetectionunit/memRead 0 0
force -freeze sim:/hazarddetectionunit/regLoaded 3'h3 0
force -freeze sim:/hazarddetectionunit/rSrc 3'h3 0
force -freeze sim:/hazarddetectionunit/rDst 3'h3 0
run
force -freeze sim:/hazarddetectionunit/memRead 1 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'h1f 0
run
force -freeze sim:/hazarddetectionunit/rSrc 3'h1 0
force -freeze sim:/hazarddetectionunit/instOpCode 5'b11110 0
run
force -freeze sim:/hazarddetectionunit/regLoaded 3'h1 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b11101 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b10010 0
force -freeze sim:/hazarddetectionunit/regLoaded 3'h0 0
run
force -freeze sim:/hazarddetectionunit/regLoaded 3'h3 0
run
force -freeze sim:/hazarddetectionunit/rDst 3'h4 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b11100 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b11011 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b11000 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b11011 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b10110 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b10101 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b10111 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b10100 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b10011 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b10000 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b01101 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b01110 0
run
force -freeze sim:/hazarddetectionunit/instOpCode 5'b00100 0
run