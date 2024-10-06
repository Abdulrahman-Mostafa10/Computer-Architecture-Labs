vsim -gui work.unit_d

add wave -position insertpoint sim:/unit_d/*

force -freeze sim:/unit_d/A "11110000" 0
force -freeze sim:/unit_d/Cin 0 0
force -freeze sim:/unit_d/Sel "00" 0

run

force -freeze sim:/unit_d/Sel "01" 0
run

force -freeze sim:/unit_d/Sel "10" 0
run

force -freeze sim:/unit_d/Sel "11" 0
run

force -freeze sim:/unit_d/Sel "10" 0
force -freeze sim:/unit_b/Cin 1 0
run