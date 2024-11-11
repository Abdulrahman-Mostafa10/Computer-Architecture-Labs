vsim -gui work.fsm
add wave -position insertpoint sim:/fsm/*

#initalize clock 
force -freeze sim:/fsm/clk 1 0, 0 {50 ns} -r {100 ns}

# reset system
force -freeze sim:/fsm/requested_next_floor 0000 0
force -freeze sim:/fsm/reset 1 0
run 100 ns

# request the 9th floor (floor 8)
force -freeze sim:/fsm/requested_next_floor 1000 0
run 4000 ns

# request the ground floor (floor 0)
force -freeze sim:/fsm/requested_next_floor 0000 0
run 4000 ns

# request the 4th floor (floor 3)
force -freeze sim:/fsm/requested_next_floor 0011 0
run 4000 ns

# request the 1st floor (floor 1)
force -freeze sim:/fsm/requested_next_floor 0001 0
run 4000 ns