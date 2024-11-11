vsim -gui work.elevator
add wave -position insertpoint sim:/elevator/*

#initalize clock 
force -freeze sim:/elevator/clk 1 0, 0 {50 ns} -r {100 ns}

# reset the system
force -freeze sim:/elevator/reset 1 0
run 100 ns

# request the 7th floor (floor 6)
force -freeze sim:/elevator/reset 0 0
force -freeze sim:/elevator/request 0110 0
run 100 ns

# request the 4th floor (floor 3)
force -freeze sim:/elevator/request 0011 0
run 4000 ns

# request the ground floor (floor 0)
force -freeze sim:/elevator/request 0000 0
run 100 ns

# request the 2nd floor (floor 1)
force -freeze sim:/elevator/request 0001 0
run 8000 ns