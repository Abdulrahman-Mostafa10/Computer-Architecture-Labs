vsim -gui work.unit_b

add wave -position insertpoint sim:/unit_b/*

force -freeze sim:/unit_b/A 11110000 0
force -freeze sim:/unit_b/B 10110000 0
force -freeze sim:/unit_b/SEL 00 0
run
force -freeze sim:/unit_b/SEL 01 0
force -freeze sim:/unit_b/B 00001011 0
run
force -freeze sim:/unit_b/B 10110000 0
force -freeze sim:/unit_b/SEL 10 0
run
force -freeze sim:/unit_b/SEL 11 0
run