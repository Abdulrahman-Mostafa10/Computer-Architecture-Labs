vsim -gui work.request_solver
add wave -position insertpoint sim:/request_solver/*

# convert the radix of the current floor
radix signal sim:/request_solver/current_floor unsigned

#initalize clock 
force -freeze sim:/request_solver/clk 1 0, 0 {50 ns} -r {100 ns}

# reset the system
force -freeze sim:/request_solver/reset 1 0
force -freeze sim:/request_solver/is_moving_up 0 0
force -freeze sim:/request_solver/current_floor 0000 0
force -freeze sim:/request_solver/request 0000 0
run 100 ns

force -freeze sim:/request_solver/reset 0 0
force -freeze sim:/request_solver/request 0110 0
run 200 ns

force -freeze sim:/request_solver/is_moving_up 1 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0001 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0010 0
force -freeze sim:/request_solver/request 0100 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0011 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0100 0
force -freeze sim:/request_solver/request 0010 0
run 200 ns

force -freeze sim:/request_solver/is_moving_up 0 0
run 400 ns

force -freeze sim:/request_solver/is_moving_up 1 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0101 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0110 0
run 200 ns

force -freeze sim:/request_solver/is_moving_up 0 0
run 400 ns

force -freeze sim:/request_solver/current_floor 0101 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0100 0
force -freeze sim:/request_solver/request 0000 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0011 0
run 200 ns

force -freeze sim:/request_solver/current_floor 0010 0
run 600 ns

force -freeze sim:/request_solver/current_floor 0001 0
run 200 ns

force -freeze sim:/request_solver/current_floor 000 0
run 600 ns
