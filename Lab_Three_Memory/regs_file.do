vsim -gui work.regs_file
add wave -position insertpoint sim:/regs_file/*

force -freeze sim:/regs_file/reset 1 0
force -freeze sim:/regs_file/r_addr0 000 0
force -freeze sim:/regs_file/r_addr1 000 0
force -freeze sim:/regs_file/w_addr 000 0
force -freeze sim:/regs_file/write_data 00000000 0
force -freeze sim:/regs_file/we 0 0
force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
run

force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/regs_file/reset 0 0
force -freeze sim:/regs_file/write_data 11111111 0
force -freeze sim:/regs_file/w_addr 000 0
force -freeze sim:/regs_file/we 1 0
run

force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/regs_file/w_addr 001 0
force -freeze sim:/regs_file/write_data 00010001 0
force -freeze sim:/regs_file/we 1 0
run

force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/regs_file/w_addr 111 0
force -freeze sim:/regs_file/write_data 10010000 0
force -freeze sim:/regs_file/we 1 0
run

force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/regs_file/w_addr 011 0
force -freeze sim:/regs_file/write_data 00001000 0
force -freeze sim:/regs_file/we 1 0
run

force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/regs_file/we 1 0
force -freeze sim:/regs_file/w_addr 100 0
force -freeze sim:/regs_file/r_addr0 001 0
force -freeze sim:/regs_file/r_addr1 111 0
force -freeze sim:/regs_file/write_data 00000011 0
run

force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/regs_file/r_addr0 010 0
force -freeze sim:/regs_file/r_addr1 011 0
force -freeze sim:/regs_file/we 0 0
run

force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/regs_file/r_addr0 100 0
force -freeze sim:/regs_file/r_addr1 101 0
run

force -freeze sim:/regs_file/clk 1 0, 0 {50 ps} 100
force -freeze sim:/regs_file/we 1 0
force -freeze sim:/regs_file/r_addr0 110 0
force -freeze sim:/regs_file/r_addr1 000 0
force -freeze sim:/regs_file/w_addr 000 0
force -freeze sim:/regs_file/write_data 00000001 0
run
