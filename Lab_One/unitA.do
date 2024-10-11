vsim -gui work.unit_a -gn=8

add wave -position insertpoint  \

sim:/unit_a/A \
sim:/unit_a/B \
sim:/unit_a/Cin \
sim:/unit_a/F \
sim:/unit_a/Sel

force -deposit sim:/unit_a/A 11110000 0
force -freeze sim:/unit_a/B 10110000 0
force -freeze sim:/unit_a/Sel 00 0
force -freeze sim:/unit_a/Cin 0 0
run

force -freeze sim:/unit_a/Cin 1 0
run

force -freeze sim:/unit_a/Sel 01 0
force -freeze sim:/unit_a/Cin 0 0
run

force -freeze sim:/unit_a/Cin 1 0
run

force -freeze sim:/unit_a/Sel 10 0
force -freeze sim:/unit_a/Cin 0 0
run

force -freeze sim:/unit_a/Cin 1 0
run

force -freeze sim:/unit_a/Sel 11 0
force -freeze sim:/unit_a/Cin 0 0
run

force -freeze sim:/unit_a/Cin 1 0
run