vsim -gui work.memory
add wave -position insertpoint sim:/memory/*

force -freeze sim:/memory/reset 1 0
force -freeze sim:/memory/r_addr1 000 0
force -freeze sim:/memory/r_addr0 000 0
force -freeze sim:/memory/w_addr 000 0
force -freeze sim:/memory/write_data 00000000 0
force -freeze sim:/memory/we 0 0
force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
run

force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
force -freeze sim:/memory/reset 0 0
force -freeze sim:/memory/write_data 11111111 0  
force -freeze sim:/memory/w_addr 000 0           
force -freeze sim:/memory/we 1 0                  
run

force -freeze sim:/memory/w_addr 001 0 
force -freeze sim:/memory/write_data 00010001 0   
force -freeze sim:/memory/we 1 0
force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
run

force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
force -freeze sim:/memory/w_addr 111 0           
force -freeze sim:/memory/write_data 10010000 0   
force -freeze sim:/memory/we 1 0                  
run

force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
force -freeze sim:/memory/w_addr 011 0           
force -freeze sim:/memory/write_data 00001000 0   
force -freeze sim:/memory/we 1 0                  
run

force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
force -freeze sim:/memory/r_addr0 001 0           
force -freeze sim:/memory/r_addr1 111 0           
force -freeze sim:/memory/w_addr 100 0            
force -freeze sim:/memory/write_data 00000011 0    
force -freeze sim:/memory/we 1 0                   
run

force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
force -freeze sim:/memory/we 0 0                   
force -freeze sim:/memory/r_addr0 010 0           
force -freeze sim:/memory/r_addr1 011 0           
run

force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
force -freeze sim:/memory.r_addr0 100 0           
force -freeze sim:/memory.r_addr1 101 0           
run

force -freeze sim:/memory/clk 1 0, 0 {50 ps} 100
force -freeze sim:/memory.r_addr0 110 0           
force -freeze sim:/memory.r_addr1 000 0           
force -freeze sim:/memory.w_addr 000 0             
force -freeze sim:/memory.write_data 00000001 0    
force -freeze sim:/memory.we 1 0                   
run
