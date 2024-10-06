vsim -gui work.unit_c

add wave -position insertpoint sim:/unit_c/*

force -freeze sim:/unit_c/A "11110000" 0

force -freeze sim:/unit_c/SEL "00" 0
run

force -freeze sim:/unit_c/SEL "01" 0
run

force -freeze sim:/unit_c/SEL "10" 0
force -freeze sim:/unit_c/Cin 0 0
run

force -freeze sim:/unit_c/SEL "11" 0
run